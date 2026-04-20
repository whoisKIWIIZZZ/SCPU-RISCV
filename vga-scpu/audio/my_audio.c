#pragma GCC push_options
#pragma GCC optimize ("O0")
#include<stdlib.h>
void main();
void Entry()
{
    asm("li\tsp,1024");
    main();
    DeadLoop:goto DeadLoop;
}
#define SWITCH_ADDR         0xF0000000
#define LED_ADDR            0xF0000000
#define DISPLAY_ADDR        0xE0000000
#define KEYBOARD_ADDR       0xA0000000
#define AUDIO_ADDR          0xB0000000
#define VGA_ADDR            0xC0000000
#define DISPLAY_BASE        0x000000A0
#define f0_pending          (*(volatile uint8_t *)0x00000080)
enum {
    NOTE_C4  = 0,   // bit0
    NOTE_CS4 = 1,   // bit1  C#4
    NOTE_D4  = 2,
    NOTE_DS4 = 3,   // D#4
    NOTE_E4  = 4,
    NOTE_F4  = 5,
    NOTE_FS4 = 6,   // F#4
    NOTE_G4  = 7,
    NOTE_GS4 = 8,   // G#4
    NOTE_A4  = 9,
    NOTE_AS4 = 10,  // A#4
    NOTE_B4  = 11,
    NOTE_C5  = 12,
    NOTE_CS5 = 13   // bit13 C#5
};
static const unsigned char SCAN_MAP[14] = {
    0x1A, 0x22, 0x21, 0x2A, 0x32, 0x31, 0x3A, 
    0x1C, 0x1B, 0x23, 0x2B, 0x34, 0x33, 0x3B
};
// --- libraries ---
void wait(int cycles);
void write(int addr,int data);
void read(int addr,int *data);
int transform(int data);
__attribute__((interrupt)) void handler()
{
    uint16_t keys_state = *(uint16_t*)DISPLAY_BASE;
    unsigned char key;
    int *p = (int *)(KEYBOARD_ADDR);
    key = *p;
    if (key == 0xF0) {
        f0_pending = 1;
        return; // 本次仅为前缀，不更新状态，等待下次中断
    }
    int *q = (int *)0xE0000000;
    *q = key;

    int bit_idx = -1;
    for (int i = 0; i < 14; i++) {
        if (key == SCAN_MAP[i]) {
            bit_idx = i;
            break;
        }
    }

    if (bit_idx != -1) {
        if (f0_pending) {
            // 释放事件：清零对应位 (即“删掉”)
            keys_state &= ~(1U << bit_idx);
        } else {
            // 按下事件：置位对应位 (即“按位或”)
            keys_state |= (1U << bit_idx);
        }
    }
    f0_pending = 0;

    update_keys(key_state);
}
__attribute__((noinline))void wait(int cycles){while(cycles--);}
/**
 * @brief 更新14个音符的按键状态
 * @param keys_mask 14位掩码，1=按下(显示黑色), 0=未按下
 * 
 * 使用示例:
 *   // 按下C4+E4+G4 (C大三和弦)
 *   update_keys((1<<NOTE_C4) | (1<<NOTE_E4) | (1<<NOTE_G4));
 *   
 *   // 按下全部白键
 *   update_keys((1<<NOTE_C4)|(1<<NOTE_D4)|(1<<NOTE_E4)|
 *               (1<<NOTE_F4)|(1<<NOTE_G4)|(1<<NOTE_A4)|(1<<NOTE_B4));
 *   
 *   // 全部释放
 *   update_keys(0);
 */
void update_keys(uint16_t keys_mask) {
    // ★ 关键: 直接写入0xC0000000，低14位数据通过addr_bus[13:0]传递
    // MIO_BUS会自动: 
    //   1. 译码产生 vram_we = mem_w && (addr[31:28]==4'hC)
    //   2. 传递 addr_bus[13:0] 到 vram_addr
    *(volatile uint32_t*)VGA_ADDR = (uint32_t)(keys_mask & 0x3FFF);
    // 写入后下一帧VGA(40ms@25Hz)自动刷新显示
}

/**
 * @brief 读取当前按键状态的低2位(调试用)
 * @return key_state[1:0]
 */
uint8_t read_keys_low2(void) {
    volatile uint32_t val = *(volatile uint32_t*)VGA_ADDR;
    return (uint8_t)(val & 0x3);  // MIO_BUS返回{30'b0, vram_dout}
}
void write(int addr,int data)
{
    int *p=(int *)addr;
    *p=data;
}
void read(int addr,int *data)
{
    int *p=(int *)addr;
    *data=*p;
}
// --- the driver of PIANO ---
#define FRAME_POINTER 0x00000008
#define FRAME_ADDR 0x00000010 // 16*4 bytes for 16 frames, 0x10~0x4f
#define MAPPING_ADDR 0x00000100 // 64*4 bytes for 21 keys, 0x100~0x1ff
int transform(int data)
{
    unsigned int ret=0;
    if(data==0xf0)
        return 0x0d000721;
    read(MAPPING_ADDR+(data<<2),&ret);
    return ret;
}
void displayAC()
{
    unsigned int temp,low,high,p;
    read(FRAME_POINTER,&p);
    read(FRAME_ADDR+(p<<2),&temp);
    write(DISPLAY_ADDR,temp);
    low=temp&0xff;
    high=(temp>>8)&0xffffff;
    temp=(low<<24)|high;
    write(FRAME_ADDR+(p<<2),temp);
    write(FRAME_POINTER,(p+1)&0xf);
    wait(500000);
}
void initialize()
{
    // initialize the display frame
    unsigned int frame[16];
    frame[ 0]=0xFFFFFFFF;
    frame[ 1]=0xFFFFEFFF;
    frame[ 2]=0xFFFFCFFF;
    frame[ 3]=0xFFFFCEFF;
    frame[ 4]=0xFFFFCCFF;
    frame[ 5]=0xFFFF8CFF;
    frame[ 6]=0xFFFF88FF;
    frame[ 7]=0xFFFF88FE;
    frame[ 8]=0xFFFF88DE;
    frame[ 9]=0xFFFF88CE;
    frame[10]=0xFFFF88C6;
    frame[11]=0xFFFFFFFF;
    frame[12]=0xFFFF88C6;
    frame[13]=0xFFFFFFFF;
    frame[14]=0xFFFF88C6;
    frame[15]=0x7f7f7f7f;
    for(int i=0;i<16;++i)
        write(FRAME_ADDR+(i<<2),frame[i]);
    // initialize the mapping table from the key to the audio frequency
    // C3~B3
    // initialize the display control variable
    write(FRAME_POINTER,0);
    // clear the display
    write(DISPLAY_ADDR,-1);
}
void main()
{
    unsigned int temp=0;
    initialize();
    begin:
    // update_keys((1<<NOTE_C4) | (1<<NOTE_E4) | (1<<NOTE_G4));
    // wait(5000000);
    // update_keys(0);
    // wait(5000000);
    // update_keys((1<<NOTE_CS4) | (1<<NOTE_F4) | (1<<NOTE_GS4));
    //displayAC();

    goto begin;
}
#pragma GCC pop_options
// --- the end of the file ---
/*
    8-segs display:
        +-0-+
        5   1
        +-6-+
        4   2
        +-3-+-7
*/