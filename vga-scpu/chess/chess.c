#pragma GCC optimize("O0")
#include <stdint.h>

#define RAM_DATA_BASE   0x00000200 
#define BOARD_BASE      0xC0000000 
#define CNT_ADDR        0x00000300 
#define DISPLAY_ADDR    0xE0000000
#define PS2_DATA_ADDR (*(volatile unsigned int *)0xF0000008)
#define MOVE_CNT (*(volatile uint32_t *)CNT_ADDR)

void main();
void start(){
    asm("li\tsp,0x100"); // 初始化栈指针
    main();
    loop:goto loop; // 结束后原地打转)
}
typedef struct {
    uint32_t row;
    uint32_t col;
    uint32_t color;
} Move;

void write(int addr,int data)
{
    int *p=(int *)addr;
    *p=data;
}


static uint32_t total_moves = 0;

/**
 * @brief 将棋步手动存入 Data RAM
 * 这样反汇编后会产生一系列的存储指令，将立即数搬运到 RAM
 */
void store_move_to_ram(uint32_t index, uint32_t r, uint32_t c, uint32_t color) {
    Move *base = (Move *)RAM_DATA_BASE;
    base[index].row = r;
    base[index].col = c;
    base[index].color = color;
}

/**
 * @brief 核心绘图函数
 */
void set_piece(uint32_t row, uint32_t col, uint32_t color) {
  
    volatile uint32_t *pixel_ptr = (uint32_t *)(BOARD_BASE + (row * 19 + col) * 4);
    *pixel_ptr = color;
}

/**
 * @brief 中断服务程序 (ISR)
 * 每次中断执行一个 set piece 动作
 */
void __attribute__((interrupt)) timer_interrupt_handler() {
    if (MOVE_CNT < total_moves) {
        Move *base = (Move *)RAM_DATA_BASE;
        
        // 从 RAM 中取出当前计数器对应的棋步
        uint32_t r = base[MOVE_CNT].row;
        uint32_t c = base[MOVE_CNT].col;
        uint32_t color = base[MOVE_CNT].color;

        // 执行绘制
        set_piece(r, c, color);

        // 计数器自增
        MOVE_CNT = MOVE_CNT + 1;
    }
}

void __attribute__((interrupt)) keyboard_interrupt() { 
    unsigned char key;
    key = (unsigned char)(PS2_DATA_ADDR);
    write(DISPLAY_ADDR,(int)key);
    if(key == 0x29)//space
    {
        if (MOVE_CNT < total_moves) {
        Move *base = (Move *)RAM_DATA_BASE;
        
        // 从 RAM 中取出当前计数器对应的棋步
        uint32_t r = base[MOVE_CNT].row;
        uint32_t c = base[MOVE_CNT].col;
        uint32_t color = base[MOVE_CNT].color;

        // 执行绘制
        set_piece(r, c, color);
        int addr = (r<<4)|c;
        write(DISPLAY_ADDR,addr);

        // 计数器自增
        MOVE_CNT = MOVE_CNT + 1;
    }
    }

}
/**
 * @brief 程序入口
 */
void main() {
    // 1. 初始化计数器
    MOVE_CNT = 0;

    // 2. 模拟 .rodata 的行为：手动填充数据到 Data RAM
    // 这些代码在反汇编里会变成具体的指令，不再依赖加载器的段处理
    /*
    set_piece(3, 3, 1);
    set_piece(2, 2, 2);
    set_piece(2, 3, 1);
    set_piece(3, 2, 2);
    set_piece(4, 2, 1);
    set_piece(4, 1, 2);
    set_piece(5, 2, 1);
    set_piece(5, 1, 2);
    set_piece(6, 2, 1);
    set_piece(1, 3, 2);
    set_piece(1, 4, 1);
    set_piece(1, 2, 2);
    set_piece(2, 5, 1);
};
    */
    store_move_to_ram(0, 3, 3, 1); // [3,3,1]
    store_move_to_ram(1, 2, 2, 2); // [3,4,2]
    store_move_to_ram(2, 2, 3, 1); // [4,3,2]
    store_move_to_ram(3, 3, 2, 2); // [4,4,1]
    store_move_to_ram(4, 4, 2, 1); // [2,2,1]
    store_move_to_ram(5, 4,1,2); // [2,2,1]
    store_move_to_ram(6, 5,2,1); // [2,2,1]
    store_move_to_ram(7, 5,1,2); // [2,2,1]
    store_move_to_ram(8, 6,2,1); // [2,2,1]
    store_move_to_ram(9, 1,3,2); // [2,2,1]
    store_move_to_ram(10, 1, 4, 1); // [2,2,1]
    store_move_to_ram(11, 1, 2, 2); // [2,2,1]
    store_move_to_ram(12, 2, 5, 1); // [2,2,1]
    
    total_moves = 13; // 设置总步数

    // 4. 主循环空转，所有逻辑都在中断中异步执行
    while (1) {        
        __asm__ volatile ("nop"); 
    }

    return ;
}