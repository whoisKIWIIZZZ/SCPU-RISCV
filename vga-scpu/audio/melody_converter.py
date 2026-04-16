import math

# 配置参数
AUDIO_ADDR = "AUDIO_ADDR"
SYSTEM_CLOCK = 1e8  # 100MHz
QUARTER_NOTE_WAIT = 5000000  # 一个四分音符的等待时间

def play_note(note_name, octave, duration_ratio):
    """
    note_name: 唱名 'Do', 'Re', 'Mi', 'Fa', 'Sol', 'La', 'Si' (或 'C', 'D'...)
    octave: 八度，如 3, 4, 5, 6
    duration_ratio: 持续时间，1.0 代表四分音符，0.5 代表八分音符，2.0 代表二分音符
    """
    # 唱名到半音的映射 (以 C 为基准)
    note_map = {
        'Do': 0, 'C': 0,
        'Re': 2, 'D': 2,
        'Mi': 4, 'E': 4,
        'Fa': 5, 'F': 5,
        'Sol': 7, 'G': 7,
        'La': 9, 'A': 9,
        'Si': 11, 'B': 11,
        'Rest': -1 # 休止符
    }
    
    if note_name == 'Rest':
        print(f"// Rest")
        print(f"write({AUDIO_ADDR}, 0); // 频率设为0或静音值")
        print(f"wait({int(QUARTER_NOTE_WAIT * duration_ratio)});")
        return

    # 计算 MIDI 编号: C0 是 12, C3 是 48
    # 公式: MIDI = (Octave + 1) * 12 + Note_Offset
    midi_code = (octave + 1) * 12 + note_map[note_name]
    
    # 计算频率: f = 440 * 2^((n-69)/12)
    freq = 440.0 * (2 ** ((midi_code - 69) / 12))
    
    # 计算硬件寄存器值
    val_to_write = round(SYSTEM_CLOCK / freq)
    wait_val = int(QUARTER_NOTE_WAIT * duration_ratio)
    
    # 输出指令
    print(f"// {note_name}{octave} | {duration_ratio} Quarter Note(s)")
    print(f"write({AUDIO_ADDR}, {val_to_write});")
    print(f"wait({wait_val});")

# --- 旋律编写示例 ---
def my_melody():
    # 示例：小星星片段 (C4 八度)
    # 格式: (唱名, 八度, 长度)
    'D',4,1.0
    'E'
    score = [
        ('Do', 4, 1.0), ('Do', 4, 1.0), ('Sol', 4, 1.0), ('Sol', 4, 1.0),
        ('La', 4, 1.0), ('La', 4, 1.0), ('Sol', 4, 2.0),
        ('Fa', 4, 1.0), ('Fa', 4, 1.0), ('Mi', 4, 1.0), ('Mi', 4, 1.0),
        ('Re', 4, 1.0), ('Re', 4, 1.0), ('Do', 4, 2.0),
    ]
    
    for note, octv, dur in score:
        play_note(note, octv, dur)

if __name__ == "__main__":
    my_melody()