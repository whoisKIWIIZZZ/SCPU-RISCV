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

// ---- Hardware addresses ----
#define DISPLAY_ADDR        0xE0000000
#define KEYBOARD_ADDR       0xA0000000
#define AUDIOMAIN_ADDR      0xB0000000   // CTRL: waveform+detune+unison+volume+keymap
#define AUDIOADSR_ADDR      0xB1000000   // ADSR: attack+decay+sustain+release
#define AUDIOFILTER_ADDR    0xB2000000   // FILT: cutoff
#define AUDIOPIANO_ADDR     0xB3000000   // PIANO: attack+body+tail+noise
#define VGA_ADDR            0xC0000000
#define DISPLAY_BASE        0x000000C0

// ---- PS/2 state variables (in scratchpad RAM) ----
#define f0_pending          (*(volatile uint8_t  *)0x0000007C)
#define shift_pending       (*(volatile uint8_t  *)0x00000080)
#define wavet_state         (*(volatile uint8_t  *)0x00000070)   // 0=square 1=tri 2=saw 3=sine 4=piano

// ---- Scan-code → bit-index lookup table ----
#define MAP_ADDR            0x00000084
#define SCAN_MAP_IN_MEM     ((volatile int*)0x00000084)

// ---- Control-word construction ----
// reg_ctrl = {res[31:29], wf[28:26], det[25:22], uni[21:18], vol[17:14], keys[13:0]}
#define DETUNE_DEFAULT      7
#define UNISON_DEFAULT      4
#define VOLUME_DEFAULT      8

void wait(int cycles);
void write(int addr, int data);
void read(int addr, int *data);
int transform(int data);
void update_keys(uint32_t keys_mask);

// =============================================================================
// Keyboard interrupt handler
// =============================================================================
__attribute__((interrupt)) void handler()
{
    uint32_t keys_state = *(uint32_t*)DISPLAY_BASE;
    unsigned char key;
    int *p = (int *)(KEYBOARD_ADDR);
    key = *p;

    // ---- modifier tracking ----
    if (key == 0x12) {          // Left Shift (make)
        shift_pending = 1;
    }
    if (key == 0x59) {          // Right Shift (make)
        shift_pending = 1;
    }
    if (key == 0xF0) {          // Break prefix
        f0_pending = 1;
        return;
    }

    // Debug: display last scancode
    int *q = (int *)0xE0000000;
    *q = key;

    // ---- Wavetable switch: key "1" (PS/2 Set2 scancode 0x16) ----
    if (key == 0x16 && !f0_pending) {
        wavet_state = (wavet_state + 1) % 5;   // cycle 0→1→2→3→4→0
        uint32_t ctrl = ((uint32_t)wavet_state << 26)
                      | (DETUNE_DEFAULT << 22)
                      | (UNISON_DEFAULT << 18)
                      | (VOLUME_DEFAULT << 14)
                      | (keys_state & 0x3FFF);
        write(AUDIOMAIN_ADDR, (int)ctrl);
        return;
    }

    // ---- Look up bit index from scan map ----
    int bit_idx = -1;
    for (int i = 0; i <= 14; i++) {
        if (key == (unsigned char)SCAN_MAP_IN_MEM[i]) {
            bit_idx = i;
            break;
        }
    }

    // Shift released while no other key: ignore
    if (shift_pending && f0_pending) {
        f0_pending  = 0;
        shift_pending = 0;
        return;
    }

    // ---- Update key state ----
    if (bit_idx != -1) {
        if (shift_pending) {
            bit_idx += 12;                 // shift → next octave
        }
        if (f0_pending) {
            keys_state &= ~(1U << bit_idx);   // release
        } else {
            keys_state |=  (1U << bit_idx);   // press
        }
    }

    // Persist key state
    
    f0_pending = 0;

    // Write full control word to audio (waveform + detune + unison + volume + keys)
    uint32_t ctrl = ((uint32_t)wavet_state << 26)
                  | (DETUNE_DEFAULT << 22)
                  | (UNISON_DEFAULT << 18)
                  | (VOLUME_DEFAULT << 14)
                  | (keys_state & 0x3FFF);
    write(AUDIOMAIN_ADDR, (int)ctrl);
    write(DISPLAY_BASE, (int)ctrl);

    // Mirror low 14 bits to VGA for chess board
    update_keys(keys_state);
}

// =============================================================================
// Utility functions
// =============================================================================
void write(int addr, int data)
{
    int *p = (int *)addr;
    *p = data;
}

__attribute__((noinline)) void wait(int cycles)
{
    while (cycles--);
}

void update_keys(uint32_t keys_mask)
{
    *(volatile uint32_t*)VGA_ADDR = (uint32_t)(keys_mask & 0x3FFF);
}

// =============================================================================
// Scan-code → bit-index mapping table
//
//   Bottom row (Z..M):      bits  0~ 6  → C4 ~ B4
//   Home   row (A..J):      bits  7~13  → C5 ~ B5
//   Top    row (Q..U):      bits 14~20  → C6 ~ B6 (unused, key_bitmap is 14-bit)
//
//   PS/2 Set 2 scan codes:
//     0x16 = "1"       → reserved for wavetable switching
//     0x12 = Left Shift → octave shift (+12)
//     0x59 = Right Shift
//     0xF0 = break prefix
// =============================================================================
void init()
{
    // ---- Bottom row (Z-M): C4-B4 (bits 0-6) ----
    write(MAP_ADDR + ( 0 << 2), (int)0x1A);   // Z  → C4
    write(MAP_ADDR + ( 1 << 2), (int)0x22);   // X  → D4
    write(MAP_ADDR + ( 2 << 2), (int)0x21);   // C  → E4
    write(MAP_ADDR + ( 3 << 2), (int)0x2A);   // V  → F4
    write(MAP_ADDR + ( 4 << 2), (int)0x32);   // B  → G4
    write(MAP_ADDR + ( 5 << 2), (int)0x31);   // N  → A4
    write(MAP_ADDR + ( 6 << 2), (int)0x3A);   // M  → B4

    // ---- Home row (A-J): C5-B5 (bits 7-13) ----
    write(MAP_ADDR + ( 7 << 2), (int)0x1C);   // A  → C5
    write(MAP_ADDR + ( 8 << 2), (int)0x1B);   // S  → D5
    write(MAP_ADDR + ( 9 << 2), (int)0x23);   // D  → E5
    write(MAP_ADDR + (10 << 2), (int)0x2B);   // F  → F5
    write(MAP_ADDR + (11 << 2), (int)0x34);   // G  → G5
    write(MAP_ADDR + (12 << 2), (int)0x33);   // H  → A5
    write(MAP_ADDR + (13 << 2), (int)0x3B);   // J  → B5

    // ---- Top row (Q-U): C6-B6 (bits 14-20, unused for 14-bit keymap) ----
    write(MAP_ADDR + (14 << 2), (int)0x15);   // Q  → C6
    write(MAP_ADDR + (15 << 2), (int)0x1D);   // W  → D6
    write(MAP_ADDR + (16 << 2), (int)0x24);   // E  → E6
    write(MAP_ADDR + (17 << 2), (int)0x2D);   // R  → F6
    write(MAP_ADDR + (18 << 2), (int)0x2C);   // T  → G6
    write(MAP_ADDR + (19 << 2), (int)0x35);   // Y  → A6
    write(MAP_ADDR + (20 << 2), (int)0x3C);   // U  → B6
}

// =============================================================================
// Main
// =============================================================================
void main()
{
    init();

    // Initialize audio CTRL: waveform=0 (square), detune=7, unison=4, volume=8, keys=0
    uint32_t ctrl_init = ((uint32_t)wavet_state << 26)
                       | (DETUNE_DEFAULT << 22)
                       | (UNISON_DEFAULT << 18)
                       | (VOLUME_DEFAULT << 14);
    write(AUDIOMAIN_ADDR, (int)ctrl_init);

    // Initialize ADSR: A=20, D=100, S=255, R=100 (matches HW defaults)
    write(AUDIOADSR_ADDR, (int)0x1464FF64);

    // Initialize filter: cutoff=16 (bypass, lets harmonics through)
    write(AUDIOFILTER_ADDR, (int)16);

    // Initialize piano: attack=128, body=200, tail=16, noise=128
    write(AUDIOPIANO_ADDR, (int)0x80C81080);

    begin:
    goto begin;
}
#pragma GCC pop_options
