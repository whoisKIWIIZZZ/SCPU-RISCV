#!/usr/bin/env python3
"""
MIDI → stand-alone midi.c for SCPU audio synth.

Usage:  python midi2song.py song.mid [BPM] [--step 5]

Output: midi.c  — a complete C file ready to compile into ROM.
        Based on my_audio.c template; the template itself is never touched.

The keyboard covers 21 white keys: C4–B6 mapped to bitmap bits 0–20.
"""

import sys, os, argparse, mido

# ── white-key mapping ──────────────────────────────────────────────
_SEMI_TO_WHITE = [0, -1, 1, -1, 2, 3, -1, 4, -1, 5, -1, 6]
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
TEMPLATE   = os.path.join(SCRIPT_DIR, "my_audio.c")
CPU_HZ     = 6_250_000          # Clk_CPU = 100MHz / 16  (SW2=1)


def midi_to_bit(note):
    octave, semi = note // 12, note % 12
    wp = _SEMI_TO_WHITE[semi]
    if wp < 0:
        return -1
    idx = (octave - 4) * 7 + wp
    return idx if 0 <= idx < 21 else -1


# ── MIDI → compressed (ms, bitmap) frames ──────────────────────────
def parse_midi(path, step_ms=10):
    mid = mido.MidiFile(path)
    tpb = mid.ticks_per_beat
    tempo = 500_000

    raw = []
    for track in mid.tracks:
        tick = 0
        for msg in track:
            tick += msg.time
            if msg.type == "set_tempo":
                tempo = msg.tempo
            elif msg.type == "note_on" and msg.velocity > 0:
                raw.append((tick, msg.note, 1))
            elif msg.type == "note_off" or (msg.type == "note_on" and msg.velocity == 0):
                raw.append((tick, msg.note, 0))
    raw.sort(key=lambda x: x[0])

    if not raw:
        return [(0, 0)]

    ms_per_tick = tempo / tpb / 1000.0
    total_ms = int(raw[-1][0] * ms_per_tick) + 2000

    frames, active, ei, t = [], set(), 0, 0
    while t < total_ms and ei < len(raw):
        while ei < len(raw) and raw[ei][0] * ms_per_tick <= t:
            _, note, on = raw[ei]
            bit = midi_to_bit(note)
            if bit >= 0:
                (active.add if on else active.discard)(bit)
            ei += 1
        frames.append(sum(1 << b for b in active))
        t += step_ms

    # compress: only emit changes
    comp = [(0, frames[0])]
    for i in range(1, len(frames)):
        if frames[i] != frames[i - 1]:
            comp.append((i * step_ms, frames[i]))
    if comp[-1][1] != 0:
        comp.append((comp[-1][0] + step_ms * 4, 0))
    return comp


# ── C inline body (Harvard arch: no global arrays) ─────────────────
def song_inline_body(frames, cpu_hz):
    lines = []
    prev_ms = 0
    for ms, bm in frames:
        delay_ms = ms - prev_ms
        prev_ms = ms
        cycles = max(int(delay_ms / 1000.0 * cpu_hz), 50)
        lines.append(f"    write(AUDIONOTE_ADDR, 0x{bm:08x});")
        lines.append(f"    update_keys(0x{bm:08x});")
        lines.append(f"    wait({cycles});  // +{delay_ms:>5}ms")
    return "\n".join(lines)


# ── main builder ───────────────────────────────────────────────────
def build_midi_c(frames, cpu_hz, song_name, template_path):
    with open(template_path, "r") as f:
        tmpl = f.read()

    SONG_LEN = len(frames)

    # ---- insertion A: after sd_flag define, add play_flag ----
    marker_a = "#define sd_flag             (*(volatile uint8_t *)0x000001B4)\n"
    insert_a = (
        marker_a +
        "\n"
        "#define FLAG_PLAY          0xA5\n"
        "#define play_flag          (*(volatile uint8_t *)0x000001B8)\n"
    )

    # ---- insertion B: in handler, add play trigger key before SD test case ----
    marker_b = "            // ---- SD test ----"
    insert_b = (
        "            // ---- song play trigger ----\n"
        "            case 0x29: // Space — play song\n"
        "                play_flag = FLAG_PLAY;\n"
        "                break;\n\n"
        "            " + marker_b
    )

    # ---- insertion C: after sd_test() closing brace, add inline song player ----
    marker_c = '        write(DISPLAY_ADDR,(errors<<16)|0xFA11); // "FAIL"+count\n}'
    song_arr = (
        f'        write(DISPLAY_ADDR,(errors<<16)|0xFA11); // "FAIL"+count\n'
        f"}}\n"
        f"\n"
        f"// =============================================================================\n"
        f"// Song player  (auto-generated, {SONG_LEN} events, Harvard-arch safe)\n"
        f"// =============================================================================\n"
        f"void play_song() {{\n"
        f"{song_inline_body(frames, cpu_hz)}\n"
        f"    write(AUDIONOTE_ADDR, 0);\n"
        f"}}\n"
    )

    # ---- insertion D: in main(), add play check inside the loop ----
    marker_d = "    loop:"
    insert_d = (
        "    loop:\n"
        "    if (play_flag == FLAG_PLAY) {\n"
        "        play_flag = 0;\n"
        "        play_song();\n"
        "    }\n"
    )

    # ---- insertion E: in init(), initialize play_flag ----
    marker_e = "    sd_flag = FLAG_NONE;\n    // --- push all registers ---"
    insert_e = "    sd_flag = FLAG_NONE;\n    play_flag = FLAG_NONE;\n    // --- push all registers ---"

    # ---- apply ----
    out = tmpl.replace(marker_a, insert_a, 1)
    out = out.replace(marker_b, insert_b, 1)
    out = out.replace(marker_c, song_arr, 1)
    out = out.replace(marker_d, insert_d, 1)
    out = out.replace(marker_e, insert_e, 1)

    return out


# ── CLI ─────────────────────────────────────────────────────────────
if __name__ == "__main__":
    p = argparse.ArgumentParser(description="MIDI → SCPU midi.c")
    p.add_argument("midi", help="Path to MIDI (.mid) file")
    p.add_argument("bpm", nargs="?", type=float, default=0,
                   help="BPM override (default: use MIDI tempo or 120)")
    p.add_argument("--step", type=int, default=10,
                   help="Quantisation step in ms (default 10)")
    p.add_argument("--name", default="song", help="C array name (default: song)")
    p.add_argument("--cpu-hz", type=int, default=CPU_HZ,
                   help=f"Clk_CPU frequency in Hz (default {CPU_HZ})")
    p.add_argument("--template", default=TEMPLATE,
                   help="Path to my_audio.c template")
    p.add_argument("-o", default="midi.c", help="Output C file (default: ./midi.c)")
    args = p.parse_args()

    frames = parse_midi(args.midi, step_ms=args.step)
    output = build_midi_c(frames, args.cpu_hz, args.name, args.template)

    outpath = os.path.join(os.getcwd(), args.o)
    with open(outpath, "w") as f:
        f.write(output)

    dur_s = frames[-1][0] / 1000.0 if frames else 0
    print(f"Wrote {outpath}  ({len(frames)} events, ~{dur_s:.1f}s, CPU_HZ={args.cpu_hz})")
