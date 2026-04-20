#pragma GCC push_options
#pragma GCC optimize("O0")
#include <stdint.h>
#define AUDIO_ADDR 0xB0000000
#define PS2_DATA_ADDR               0xF0000008
volatile uint32_t* const audio_reg = (uint32_t*)AUDIO_ADDR;
#define FREQ_C4  11236
#define FREQ_E4  14157
#define FREQ_G4  16836
#define FREQ_B4  21212
#define FREQ_D5  25223
void main();
void Entry()
{
    asm("li\tsp,1024");
    main();
DeadLoop:
    goto DeadLoop;
}

//void read(int addr,int *data){int *p=(int *)addr;*data=*p;}
void __attribute__((interrupt)) keyboard_interrupt() { 
    unsigned char key;
    int *p = (int *)(PS2_DATA_ADDR);
    key = *p;
    int *q = (int *)0xE0000000;
    *q = key;
}
// 延迟函数（根据你的CPU频率调整循环次数）
// void delay(int count) {
//     while(count--) {
//         asm("nop");
//     }
// }

// void song() {
//     // 1. 设置 5 个音轨的频率
//     audio_reg[1] = FREQ_C4; // SLOT0_FREQ
//     audio_reg[3] = FREQ_E4; // SLOT1_FREQ
//     audio_reg[5] = FREQ_G4; // SLOT2_FREQ
//     audio_reg[7] = FREQ_B4; // SLOT3_FREQ
//     audio_reg[9] = FREQ_D5; // SLOT4_FREQ

//     // 2. 依次开启 Gate（产生琶音效果）或者同时开启（产生和弦效果）
//     // 这里以同时开启和弦为例
//     audio_reg[0] = 31; // SLOT0_GATE
//     audio_reg[2] = 31; // SLOT1_GATE
//     audio_reg[4] = 31; // SLOT2_GATE
//     audio_reg[6] = 31; // SLOT3_GATE
//     audio_reg[8] = 31; // SLOT4_GATE

//     // 3. 持续一段时间
//     delay(1000000);

//     // 4. 关闭所有 Gate（停止发声，进入 Release 阶段）
//     audio_reg[0] = 0;
//     audio_reg[2] = 0;
//     audio_reg[4] = 0;
//     audio_reg[6] = 0;
//     audio_reg[8] = 0;

//     // 5. 停顿一段时间
//     delay(500000);
// }

// 保持你的 main 结构不变

void main() {
    int *q = (int *)0xE0000000;
    *q = 0x87654321;
begin:
   // song();
    goto begin;
    asm(
        "jal zero, -4"
    );
    asm(
        "jal zero, -8"
    );
        asm(
        "jal zero, -12"
    );
}