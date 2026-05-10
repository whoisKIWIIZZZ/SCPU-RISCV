#pragma GCC push_options
#pragma GCC optimize ("O0")
#include<stdlib.h>
#include<stdint.h>
void main();
void Entry()
{
    asm("li\tsp,1024");
    main();
    DeadLoop:goto DeadLoop;
}

// =============================================================================
// Memory-mapped I/O addresses
// =============================================================================
#define DISPLAY_ADDR        0xE0000000
#define KEYBOARD_ADDR       0xA0000000
#define AUDIONOTE_ADDR      0xB0000000   // reg 0x00: key_bitmap[20:0]
#define AUDIOCTRL_ADDR      0xB1000000   // reg 0x01: waveform|detune|unison|volume
#define AUDIOADSR_ADDR      0xB2000000   // reg 0x02: ADSR
#define AUDIOFILTER_ADDR    0xB3000000   // reg 0x03: filter cutoff
#define AUDIOPIANO_ADDR     0xB4000000   // reg 0x04: piano params
#define VGA_ADDR            0xC0000000
#define SD_CARD_ADDR        0xD0000000
#define SD_STATUS           (SD_CARD_ADDR + 0x0)
#define SD_BLK_ADDR         (SD_CARD_ADDR + 0x4)
#define SD_DATA_ADDR        (SD_CARD_ADDR + 0x8)
#define SD_WORD_ADDR        (SD_CARD_ADDR + 0xC)
#define SD_BLOCK_SIZE       128

// =============================================================================
// CPU-local variables (carefully spaced to avoid conflicts)
// =============================================================================

// --- scan map: 21 ints = 84 bytes, occupies 0x100 .. 0x153 ---
#define MAP_ADDR            0x00000100
#define SCAN_MAP_IN_MEM     ((volatile int*)0x00000100)

// --- keys_state: read/write by handler, kept at safe distance ---
#define DISPLAY_BASE        0x00000160

// --- interrupt state ---
#define f0_pending          (*(volatile uint8_t *)0x00000170)
#define e0_pending          (*(volatile uint8_t *)0x00000171)

// --- synthesis control params (one byte each) ---
#define wavet_state         (*(volatile uint8_t *)0x00000180)
#define vol_state           (*(volatile uint8_t *)0x00000184)
#define unison_state        (*(volatile uint8_t *)0x00000188)
#define detune_state        (*(volatile uint8_t *)0x0000018C)
#define filter_state        (*(volatile uint8_t *)0x00000190)
#define adsr_att            (*(volatile uint8_t *)0x00000194)
#define adsr_dec            (*(volatile uint8_t *)0x00000198)
#define adsr_sus            (*(volatile uint8_t *)0x0000019C)
#define adsr_rel            (*(volatile uint8_t *)0x000001A0)
#define piano_att           (*(volatile uint8_t *)0x000001A4)
#define piano_bdy           (*(volatile uint8_t *)0x000001A8)
#define piano_tail          (*(volatile uint8_t *)0x000001AC)
#define piano_noise         (*(volatile uint8_t *)0x000001B0)

// --- sd test trigger ---
#define FLAG_NONE           0
#define FLAG_SD_TEST        1
#define sd_flag             (*(volatile uint8_t *)0x000001B4)

// =============================================================================
// Forward declarations
// =============================================================================
void wait(int cycles);
void write(int addr,int data);
void update_keys(uint32_t keys_mask);
void write_ctrl();
void write_adsr();
void write_piano();

// =============================================================================
// Helpers
// =============================================================================
void read(int addr,int *data)
{
    int *p=(int *)addr;
    *data=*p;
}
void write(int addr,int data)
{
    int *p=(int *)addr;
    *p=data;
}

__attribute__((noinline))void wait(int cycles){asm volatile("1:addi %0,%0,-1;bnez %0,1b":"+r"(cycles));}

void update_keys(uint32_t keys_mask) {
    *(volatile uint32_t*)VGA_ADDR = (uint32_t)(keys_mask & 0x1FFFFF);
}

void write_ctrl() {
    uint32_t ctrl = ((uint32_t)wavet_state << 26) |
                    ((uint32_t)detune_state << 22) |
                    ((uint32_t)unison_state << 18) |
                    ((uint32_t)vol_state   << 14);
    write(AUDIOCTRL_ADDR, (int)ctrl);
}

void write_adsr() {
    uint32_t adsr = ((uint32_t)adsr_att << 24) |
                    ((uint32_t)adsr_dec << 16) |
                    ((uint32_t)adsr_sus <<  8) |
                    ((uint32_t)adsr_rel);
    write(AUDIOADSR_ADDR, (int)adsr);
}

void write_piano() {
    uint32_t piano = ((uint32_t)piano_att  << 24) |
                     ((uint32_t)piano_bdy  << 16) |
                     ((uint32_t)piano_tail <<  8) |
                     ((uint32_t)piano_noise);
    write(AUDIOPIANO_ADDR, (int)piano);
}
void write_seg(int key){
    uint32_t seg = 0;
    switch (key) {
        case 0x16: seg = 0x01000000 | (uint32_t)wavet_state;  break; // '1': waveform
        case 0x1E: seg = 0x02000000 | (uint32_t)vol_state;    break; // '2': volume
        case 0x26: seg = 0x03000000 | (uint32_t)unison_state; break; // '3': unison
        case 0x25: seg = 0x04000000 | (uint32_t)detune_state; break; // '4': detune
        case 0x2E: seg = 0x05000000 | (uint32_t)filter_state; break; // '5': filter
        case 0x36: seg = 0x06000000 | (uint32_t)piano_att;    break; // '6': piano attack
        case 0x3D: seg = 0x07000000 | (uint32_t)piano_bdy;    break; // '7': piano body
        case 0x3E: seg = 0x08000000 | (uint32_t)piano_tail;   break; // '8': piano tail
        case 0x46: seg = 0x09000000 | (uint32_t)piano_noise;  break; // '9': piano noise
        case 0x45: seg = 0x0A000000 | (uint32_t)adsr_att;     break; // '0': ADSR attack
        case 0x43: seg = 0x0B000000 | (uint32_t)adsr_dec;     break; // 'I': ADSR decay
        case 0x44: seg = 0x0C000000 | (uint32_t)adsr_sus;     break; // 'O': ADSR sustain
        case 0x4D: seg = 0x0D000000 | (uint32_t)adsr_rel;     break; // 'P': ADSR release
    }
    write(DISPLAY_ADDR, (int)seg);
}
// =============================================================================
// Keyboard interrupt handler
// =============================================================================
__attribute__((interrupt)) void handler()
{
    uint32_t keys_state = *(uint32_t*)DISPLAY_BASE;
    unsigned char key;
    int *p = (int *)(KEYBOARD_ADDR);
    key = *p;

    if (key == 0xF0) {
        f0_pending = 1;
        return;
    }
    if (key == 0xE0) {
        e0_pending = 1;
        return;
    }

    // ---- search 21-entry white-key scan map ----
    int bit_idx = -1;
    for (int i = 0; i < 21; i++) {
        if (key == (unsigned char)SCAN_MAP_IN_MEM[i]) {
            bit_idx = i;
            break;
        }
    }

    if (bit_idx != -1) {
        // note key: update bitmap (ignore extended-key and break variants)
        if (!e0_pending && !f0_pending) {
            keys_state |= (1U << bit_idx);
        } else {
            keys_state &= ~(1U << bit_idx);
        }
        write(DISPLAY_BASE, keys_state);
        write(AUDIONOTE_ADDR, (int)keys_state);
        write(DISPLAY_ADDR,(int)(keys_state));
    } else if (!f0_pending && !e0_pending) {
        // control key: act on make (press) only
        int ctrl_changed = 0;
        int adsr_changed = 0;
        int piano_changed = 0;

        switch (key) {
            // ---- synthesis control (0x01) ----
            case 0x16: // '1' — waveform cycle 0→1→2→3→4→0
                wavet_state++;
                if (wavet_state >= 5) wavet_state = 0;
                ctrl_changed = 1;
                break;
            case 0x1E: // '2' — volume +1, wrap 0→15
                vol_state++;
                vol_state &= 0xF;
                ctrl_changed = 1;
                break;
            case 0x26: // '3' — unison cycle 1→2→4→8→1
                if (unison_state >= 8)
                    unison_state = 1;
                else
                    unison_state = unison_state << 1;
                ctrl_changed = 1;
                break;
            case 0x25: // '4' — detune +1, wrap 0→15
                detune_state++;
                detune_state &= 0xF;
                ctrl_changed = 1;
                break;

            // ---- filter (0x03) ----
            case 0x2E: // '5' — filter cutoff +1, wrap 0→31
                filter_state++;
                filter_state &= 0x1F;
                write(AUDIOFILTER_ADDR, (int)filter_state);
                break;

            // ---- piano (0x04) ----
            case 0x36: // '6' — piano attack +16
                piano_att += 16;
                piano_changed = 1;
                break;
            case 0x3D: // '7' — piano body +16
                piano_bdy += 16;
                piano_changed = 1;
                break;
            case 0x3E: // '8' — piano tail +8
                piano_tail += 8;
                piano_changed = 1;
                break;
            case 0x46: // '9' — piano noise +16
                piano_noise += 16;
                piano_changed = 1;
                break;

            // ---- ADSR (0x02) ----
            case 0x45: // '0' — ADSR attack +16
                adsr_att += 16;
                adsr_changed = 1;
                break;
            case 0x43: // 'I' — ADSR decay +16
                adsr_dec += 16;
                adsr_changed = 1;
                break;
            case 0x44: // 'O' — ADSR sustain +16
                adsr_sus += 16;
                adsr_changed = 1;
                break;
            case 0x4D: // 'P' — ADSR release +16
                adsr_rel += 16;
                adsr_changed = 1;
                break;

            // ---- SD test ----
            case 0x5A: // Enter — trigger SD card read/write test
                sd_flag = FLAG_SD_TEST;
                write(DISPLAY_ADDR, 0x8B5179); // "buSY"
                break;
        }

        if (ctrl_changed)  write_ctrl();
        if (adsr_changed)  write_adsr();
        if (piano_changed) write_piano();

        write_seg(key);
    }

    // always consume pending flags after the key byte arrives
    f0_pending = 0;
    e0_pending = 0;
    update_keys(keys_state);
}



void sd_test()
{
    int i,val,errors,timeout;
    write(DISPLAY_ADDR,0x8B5179); // "buSY"
    // fill buffer with test pattern
    for(i=0;i<SD_BLOCK_SIZE;i++)
    {
        write(SD_WORD_ADDR,i);
        write(SD_DATA_ADDR,0xDEAD0000+i);
    }
    // write buffer to SD block 0
    write(SD_BLK_ADDR,0);
    write(SD_STATUS,3);
    timeout=50000000;
    do{read(SD_STATUS,&val);timeout--;}while((val&1)&&timeout>0);
    if(!timeout){write(DISPLAY_ADDR,0x0d00E401);return;}
    // read SD block 0 back to buffer
    write(SD_BLK_ADDR,0);
    write(SD_STATUS,1);
    timeout=50000000;
    do{read(SD_STATUS,&val);timeout--;}while((val&1)&&timeout>0);
    if(!timeout){write(DISPLAY_ADDR,0x0d00E402);return;}
    // diagnostic: read and display first word
    write(SD_WORD_ADDR,0);
    read(SD_DATA_ADDR,&val);
    write(DISPLAY_ADDR,val);
    wait(5000000);
    // verify
    errors=0;
    for(i=0;i<SD_BLOCK_SIZE;i++)
    {
        write(SD_WORD_ADDR,i);
        read(SD_DATA_ADDR,&val);
        if(val!=(0xDEAD0000+i))
            errors++;
    }
    if(errors==0)
    {
        write(DISPLAY_ADDR,0x9A55); // "PASS"
        wait(3000000);
    }
    else
        write(DISPLAY_ADDR,(errors<<16)|0xFA11); // "FAIL"+count
}
// =============================================================================
// Initialization
// =============================================================================
void init(){
    // --- scan map: 21 white keys C4—B6, 3 keyboard rows ---

    // Z—M row  → C4—B4
    write(MAP_ADDR + ( 0<<2), (int)0x1A); // Z → C4
    write(MAP_ADDR + ( 1<<2), (int)0x22); // X → D4
    write(MAP_ADDR + ( 2<<2), (int)0x21); // C → E4
    write(MAP_ADDR + ( 3<<2), (int)0x2A); // V → F4
    write(MAP_ADDR + ( 4<<2), (int)0x32); // B → G4
    write(MAP_ADDR + ( 5<<2), (int)0x31); // N → A4
    write(MAP_ADDR + ( 6<<2), (int)0x3A); // M → B4

    // A—J row  → C5—B5
    write(MAP_ADDR + ( 7<<2), (int)0x1C); // A → C5
    write(MAP_ADDR + ( 8<<2), (int)0x1B); // S → D5
    write(MAP_ADDR + ( 9<<2), (int)0x23); // D → E5
    write(MAP_ADDR + (10<<2), (int)0x2B); // F → F5
    write(MAP_ADDR + (11<<2), (int)0x34); // G → G5
    write(MAP_ADDR + (12<<2), (int)0x33); // H → A5
    write(MAP_ADDR + (13<<2), (int)0x3B); // J → B5

    // Q—U row  → C6—B6
    write(MAP_ADDR + (14<<2), (int)0x15); // Q → C6
    write(MAP_ADDR + (15<<2), (int)0x1D); // W → D6
    write(MAP_ADDR + (16<<2), (int)0x24); // E → E6
    write(MAP_ADDR + (17<<2), (int)0x2D); // R → F6
    write(MAP_ADDR + (18<<2), (int)0x2C); // T → G6
    write(MAP_ADDR + (19<<2), (int)0x35); // Y → A6
    write(MAP_ADDR + (20<<2), (int)0x3C); // U → B6

    // --- init parameter defaults ---
    wavet_state  = 0;    // square
    vol_state    = 8;    // volume 8
    unison_state = 4;    // 4 voices
    detune_state = 7;    // detune 7
    filter_state = 16;   // filter bypass
    adsr_att     = 20;
    adsr_dec     = 100;
    adsr_sus     = 255;
    adsr_rel     = 100;
    piano_att    = 128;
    piano_bdy    = 200;
    piano_tail   = 16;
    piano_noise  = 128;

    f0_pending=0;
    e0_pending=0;
    sd_flag = FLAG_NONE;
    // --- push all registers ---
    write(DISPLAY_BASE,      (int)0);
    write(AUDIONOTE_ADDR,    (int)0);   // no notes active
    write_ctrl();
    write_adsr();
    write(AUDIOFILTER_ADDR,  (int)filter_state);
    write_piano();
}

void main()
{
    init();
    loop:
    if (sd_flag == FLAG_SD_TEST) {
        sd_test();
        sd_flag = FLAG_NONE;
    }
    goto loop;
}
#pragma GCC pop_options
