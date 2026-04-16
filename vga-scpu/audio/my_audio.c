#pragma GCC push_options
#pragma GCC optimize("O0")
void main();
void song();
void Entry()
{
    asm("li\tsp,1024");
    main();
DeadLoop:
    goto DeadLoop;
}
#define SWITCH_ADDR                 0xf0000000
#define LED_ADDR                    0xf0000000
#define DISPLAY_ADDR                0xe0000000
#define KEYBOARD_ADDR               0xa0000000
#define AUDIO_ADDR                  0xb0000000
#define PS2_DATA_ADDR               0xF0000008
#define UNISON_ADDR                 0xD1000000
#define DETUNE_ADDR                 0xD2000000
#define UNISON_RAM                  0x00000060
#define DETUNE_RAM                  0x00000064
// --- libraries ---
void wait(int cycles);
void write(int addr, int data);
void read(int addr,int *data);
__attribute__((noinline)) void wait(int cycles){while (cycles--);}
void write(int addr, int data){int *p = (int *)addr;*p = data;}
void read(int addr,int *data){int *p=(int *)addr;*data=*p;}
void __attribute__((interrupt)) keyboard_interrupt() { 
    unsigned char key;
    unsigned int temp=1;
    read(UNISON_RAM,&temp);
    key = (unsigned char)(PS2_DATA_ADDR);
    if(key == 0x4e){
        if(temp>2){
            temp = (temp -1) & 0x1F;
            write(UNISON_RAM,temp);
            write(UNISON_ADDR,temp);
        }
    }


}
void song(){
        write(AUDIO_ADDR, 340524);
    wait(5000000);
    // Note: F#4 | Freq: 369.99Hz
    write(AUDIO_ADDR, 270274);
    wait(2500000);
    // Note: A4 | Freq: 440.00Hz
    write(AUDIO_ADDR, 227273);
    wait(5625000);
    // Note: E4 | Freq: 329.63Hz
    write(AUDIO_ADDR, 303373);
    wait(6875000);
    // Note: C#4 | Freq: 277.18Hz
    write(AUDIO_ADDR, 360773);
    wait(5000000);
    // Note: D4 | Freq: 293.66Hz
    write(AUDIO_ADDR, 340524);
    wait(15000000);
    // Note: D5 | Freq: 587.33Hz
    write(AUDIO_ADDR, 170262);
    wait(2500000);
    // Note: C#5 | Freq: 554.37Hz
    write(AUDIO_ADDR, 180386);
    wait(2500000);
    // Note: B4 | Freq: 493.88Hz
    write(AUDIO_ADDR, 202477);
    wait(2500000);
    // Note: A4 | Freq: 440.00Hz
    write(AUDIO_ADDR, 227273);
    wait(2500000);
    // Note: D4 | Freq: 293.66Hz
    write(AUDIO_ADDR, 340524);
    wait(4687500);
    // Rest
    write(AUDIO_ADDR, 0);
    wait(312500);
    // Note: F#4 | Freq: 369.99Hz
    write(AUDIO_ADDR, 270274);
    wait(3125000);
    // Note: A4 | Freq: 440.00Hz
    write(AUDIO_ADDR, 227273);
    wait(5625000);
    // Note: E4 | Freq: 329.63Hz
    write(AUDIO_ADDR, 303373);
    wait(6875000);
    // Note: C#5 | Freq: 554.37Hz
    write(AUDIO_ADDR, 180386);
    wait(16562500);
    // Note: D5 | Freq: 587.33Hz
    write(AUDIO_ADDR, 170262);
    wait(2500000);
    // Rest
    write(AUDIO_ADDR, 0);
    wait(2500000);
    // Note: A4 | Freq: 440.00Hz
    write(AUDIO_ADDR, 227273);
    wait(2500000);
    // Note: D5 | Freq: 587.33Hz
    write(AUDIO_ADDR, 170262);
    wait(2500000);
    // Note: C#5 | Freq: 554.37Hz
    write(AUDIO_ADDR, 180386);
    wait(2500000);
    // Note: F#4 | Freq: 369.99Hz
    write(AUDIO_ADDR, 270274);
    wait(2500000);
    // Note: C#5 | Freq: 554.37Hz
    write(AUDIO_ADDR, 180386);
    wait(5000000);
    // Note: D5 | Freq: 587.33Hz
    write(AUDIO_ADDR, 170262);
    wait(3125000);
    // Note: C#5 | Freq: 554.37Hz
    write(AUDIO_ADDR, 180386);
    wait(5625000);
    // Note: E4 | Freq: 329.63Hz
    write(AUDIO_ADDR, 303373);
    wait(6875000);
    // Note: F#4 | Freq: 369.99Hz
    write(AUDIO_ADDR, 270274);
    wait(7500000);
    // Note: A4 | Freq: 440.00Hz
    write(AUDIO_ADDR, 227273);
    wait(2500000);
    // Note: F#4 | Freq: 369.99Hz
    write(AUDIO_ADDR, 270274);
    wait(2500000);
    // Note: B4 | Freq: 493.88Hz
    write(AUDIO_ADDR, 202477);
    wait(2500000);
    // Note: A4 | Freq: 440.00Hz
    write(AUDIO_ADDR, 227273);
    wait(2500000);
    // Note: D4 | Freq: 293.66Hz
    write(AUDIO_ADDR, 340524);
    wait(2500000);
    // Note: C#4 | Freq: 277.18Hz
    write(AUDIO_ADDR, 360773);
    wait(5000000);
    // Note: F#4 | Freq: 369.99Hz
    write(AUDIO_ADDR, 270274);
    wait(2500000);
    // Note: A4 | Freq: 440.00Hz
    write(AUDIO_ADDR, 227273);
    wait(5625000);
    // Note: E4 | Freq: 329.63Hz
    write(AUDIO_ADDR, 303373);
    wait(6875000);
    // Note: F#4 | Freq: 369.99Hz
    write(AUDIO_ADDR, 270274);
    wait(5000000);
    // Note: A4 | Freq: 440.00Hz
    write(AUDIO_ADDR, 227273);
    wait(2500000);
    // Note: A4 | Freq: 440.00Hz
    write(AUDIO_ADDR, 227273);
    wait(4687500);
    // Note: E4 | Freq: 329.63Hz
    write(AUDIO_ADDR, 303373);
    wait(5000000);
    // Note: D4 | Freq: 293.66Hz
    write(AUDIO_ADDR, 340524);
    wait(2500000);
    // Note: E4 | Freq: 329.63Hz
    write(AUDIO_ADDR, 303373);
    wait(5000000);
    // Note: D4 | Freq: 293.66Hz
    write(AUDIO_ADDR, 340524);
    wait(5000000);
    // Note: F#4 | Freq: 369.99Hz
    write(AUDIO_ADDR, 270274);
    wait(2500000);
    // Note: A4 | Freq: 440.00Hz
    write(AUDIO_ADDR, 227273);
    wait(5625000);
    // Note: E4 | Freq: 329.63Hz
    write(AUDIO_ADDR, 303373);
    wait(4375000);
    // Note: D4 | Freq: 293.66Hz
    write(AUDIO_ADDR, 340524);
    wait(2500000);
    // Note: D5 | Freq: 587.33Hz
    write(AUDIO_ADDR, 170262);
    wait(2500000);
    // Note: C#5 | Freq: 554.37Hz
    write(AUDIO_ADDR, 180386);
    wait(2500000);
    // Note: B4 | Freq: 493.88Hz
    write(AUDIO_ADDR, 202477);
    wait(2500000);
    // Note: A4 | Freq: 440.00Hz
    write(AUDIO_ADDR, 227273);
    wait(2500000);
    // Note: E4 | Freq: 329.63Hz
    write(AUDIO_ADDR, 303373);
    wait(2500000);
    // Note: F#4 | Freq: 369.99Hz
    write(AUDIO_ADDR, 270274);
    wait(3750000);
    // Rest
    write(AUDIO_ADDR, 0);
    wait(1250000);
    // Note: F#4 | Freq: 369.99Hz
    write(AUDIO_ADDR, 270274);
    wait(2500000);
    // Note: D4 | Freq: 293.66Hz
    write(AUDIO_ADDR, 340524);
    wait(4687500);
    // Rest
    write(AUDIO_ADDR, 0);
    wait(312500);
    // Note: F#4 | Freq: 369.99Hz
    write(AUDIO_ADDR, 270274);
    wait(3125000);
    // Note: A4 | Freq: 440.00Hz
    write(AUDIO_ADDR, 227273);
    wait(5625000);
    // Note: F#4 | Freq: 369.99Hz
    write(AUDIO_ADDR, 270274);
    wait(15781250);
    // Note: E4 | Freq: 329.63Hz
    write(AUDIO_ADDR, 303373);
    wait(4375000);
    // Note: C#5 | Freq: 554.37Hz
    write(AUDIO_ADDR, 180386);
    wait(7812500);
    // Rest
    write(AUDIO_ADDR, 0);
    wait(312500);
    // Note: D5 | Freq: 587.33Hz
    write(AUDIO_ADDR, 170262);
    wait(2500000);
    // Note: C#5 | Freq: 554.37Hz
    write(AUDIO_ADDR, 180386);
    wait(2500000);
    // Note: A4 | Freq: 440.00Hz
    write(AUDIO_ADDR, 227273);
    wait(2500000);
    // Note: D5 | Freq: 587.33Hz
    write(AUDIO_ADDR, 170262);
    wait(2500000);
    // Note: E5 | Freq: 659.26Hz
    write(AUDIO_ADDR, 151686);
    wait(2500000);
    // Note: F#5 | Freq: 739.99Hz
    write(AUDIO_ADDR, 135137);
    wait(2500000);
    // Note: C#5 | Freq: 554.37Hz
    write(AUDIO_ADDR, 180386);
    wait(5000000);
    // Note: D5 | Freq: 587.33Hz
    write(AUDIO_ADDR, 170262);
    wait(3125000);
    // Note: F#4 | Freq: 369.99Hz
    write(AUDIO_ADDR, 270274);
    wait(5625000);
    // Note: A4 | Freq: 440.00Hz
    write(AUDIO_ADDR, 227273);
    wait(6875000);
    // Note: F#4 | Freq: 369.99Hz
    write(AUDIO_ADDR, 270274);
    wait(7500000);
    // Note: A4 | Freq: 440.00Hz
    write(AUDIO_ADDR, 227273);
    wait(2500000);
    // Note: F#4 | Freq: 369.99Hz
    write(AUDIO_ADDR, 270274);
    wait(2500000);
    // Note: B4 | Freq: 493.88Hz
    write(AUDIO_ADDR, 202477);
    wait(2500000);
    // Note: A4 | Freq: 440.00Hz
    write(AUDIO_ADDR, 227273);
    wait(2500000);
    // Note: D4 | Freq: 293.66Hz
    write(AUDIO_ADDR, 340524);
    wait(2500000);
    // Note: C#4 | Freq: 277.18Hz
    write(AUDIO_ADDR, 360773);
    wait(5416666);
    // Note: F#4 | Freq: 369.99Hz
    write(AUDIO_ADDR, 270274);
    wait(2500000);
    // Note: A4 | Freq: 440.00Hz
    write(AUDIO_ADDR, 227273);
    wait(5625000);
    // Note: E4 | Freq: 329.63Hz
    write(AUDIO_ADDR, 303373);
    wait(6875000);
    // Note: F#4 | Freq: 369.99Hz
    write(AUDIO_ADDR, 270274);
    wait(5000000);
    // Note: A4 | Freq: 440.00Hz
    write(AUDIO_ADDR, 227273);
    wait(1250000);
    // Rest
    write(AUDIO_ADDR, 0);
    wait(1250000);
    // Note: A4 | Freq: 440.00Hz
    write(AUDIO_ADDR, 227273);
    wait(2187500);
    // Rest
    write(AUDIO_ADDR, 0);
    wait(312500);
    // Note: B4 | Freq: 493.88Hz
    write(AUDIO_ADDR, 202477);
    wait(2500000);
    // Note: A4 | Freq: 440.00Hz
    write(AUDIO_ADDR, 227273);
    wait(2500000);
    // Note: E4 | Freq: 329.63Hz
    write(AUDIO_ADDR, 303373);
    wait(2500000);
    // Rest
    write(AUDIO_ADDR, 0);
    wait(2552083);
    // Note: D4 | Freq: 293.66Hz
    write(AUDIO_ADDR, 340524);
    wait(2500000);

}
void main()
{
    unsigned int temp = 0;
begin:
    song();
    goto begin;
}
