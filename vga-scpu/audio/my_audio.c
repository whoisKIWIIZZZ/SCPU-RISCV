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
#define DISPLAY_ADDR        0xE0000000
#define KEYBOARD_ADDR       0xA0000000
#define AUDIOMAIN_ADDR      0xB0000000
#define AUDIOADSR_ADDR      0xB1000000
#define AUDIOFILTER_ADDR    0xB2000000
#define VGA_ADDR            0xC0000000
#define DISPLAY_BASE        0x000000C0
#define f0_pending          (*(volatile uint8_t *)0x00000080)
#define MAP_ADDR            0x00000084
#define SCAN_MAP_IN_MEM     ((volatile int*)0x00000084)

void wait(int cycles);
void write(int addr,int data);
void read(int addr,int *data);
int transform(int data);
void update_keys(uint16_t keys_mask);
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
        if (key == (unsigned char)SCAN_MAP_IN_MEM[i]){
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
    write(DISPLAY_BASE, keys_state);
    f0_pending = 0;
    write(AUDIOMAIN_ADDR, (int)keys_state);
    update_keys(keys_state);
}
void write(int addr,int data)
{
    int *p=(int *)addr;
    *p=data;
}
__attribute__((noinline))void wait(int cycles){while(cycles--);}

void update_keys(uint16_t keys_mask) {
    *(volatile uint32_t*)VGA_ADDR = (uint32_t)(keys_mask & 0x3FFF);
}

void init(){
    write(MAP_ADDR + (0 << 2), (int)0x1A);
    write(MAP_ADDR + (1 << 2), (int)0x22);
    write(MAP_ADDR + (2 << 2), (int)0x21);
    write(MAP_ADDR + (3 << 2), (int)0x2A);
    write(MAP_ADDR + (4 << 2), (int)0x32);
    write(MAP_ADDR + (5 << 2), (int)0x31);

    write(MAP_ADDR + (6 << 2), (int)0x3A);
    write(MAP_ADDR + (7 << 2), (int)0x1C);
    write(MAP_ADDR + (8 << 2), (int)0x1B);
    write(MAP_ADDR + (9 << 2), (int)0x23);
    write(MAP_ADDR + (10<< 2), (int)0x2B);
    write(MAP_ADDR + (11<< 2), (int)0x34);

    write(MAP_ADDR + (12<< 2), (int)0x33);
    write(MAP_ADDR + (13<< 2), (int)0x3B);
}
void main()
{
   init();
    write(AUDIOMAIN_ADDR, (int)0x9);
    begin:
    goto begin;
}
#pragma GCC pop_options