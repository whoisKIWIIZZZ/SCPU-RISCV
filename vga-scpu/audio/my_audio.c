#pragma GCC push_options
#pragma GCC optimize("O0")
void main();
void Entry()
{
    asm("li\tsp,1024");
    main();
DeadLoop:
    goto DeadLoop;
}
#define SWITCH_ADDR 0xf0000000
#define LED_ADDR 0xf0000000
#define DISPLAY_ADDR 0xe0000000
#define KEYBOARD_ADDR 0xa0000000
#define AUDIO_ADDR 0xb0000000
// --- libraries ---
void wait(int cycles);
void write(int addr, int data);
__attribute__((noinline)) void wait(int cycles)
{
    while (cycles--)
        ;
}
void write(int addr, int data)
{
    int *p = (int *)addr;
    *p = data;
}

void main()
{
    unsigned int temp = 0;
begin:
    write(AUDIO_ADDR,340516);
    wait(5000000);
    write(AUDIO_ADDR,303371);
    wait(5000000);
    write(AUDIO_ADDR,340516);
    wait(5000000);
    write(AUDIO_ADDR,382210);
    wait(5000000);
    goto begin;
}
