#!/usr/bin/env python3
"""Genera los sonidos de interfaz (inspirados en el shamisen) en assets/sfx/*.wav.

Sintesis Karplus-Strong de cuerda pulsada en la escala hirajoshi (D, Eb, G, A, Bb).
Solo libreria estandar. Salida: WAV mono 16 bit 22.05 kHz (baja latencia, sin decodificar).
Uso: python3 tool/make_sfx.py
"""
import array, random, wave, os

SR = 22050
D3, D4, Eb4, G4, A4, Bb4 = 146.83, 293.66, 311.13, 392.00, 440.00, 466.16
D5, G5, A5, D6 = 587.33, 783.99, 880.00, 1174.66


def pluck(freq, dur, decay=0.997, bright=0.5):
    rnd = random.Random(int(freq * 10))
    n = max(2, int(SR / freq))
    buf = [rnd.uniform(-1, 1) for _ in range(n)]
    out = []
    for i in range(int(SR * dur)):
        a = buf[i % n]
        b = buf[(i + 1) % n]
        buf[i % n] = decay * (bright * a + (1 - bright) * b)
        out.append(a)
    return out


def mix(parts, total):
    mixed = [0.0] * int(SR * total)
    for start, samples, gain in parts:
        o = int(SR * start)
        for i, v in enumerate(samples):
            if o + i < len(mixed):
                mixed[o + i] += v * gain
    return mixed


def tremolo(s, rate=14, depth=0.25):
    import math
    return [v * (1 - depth + depth * math.sin(2 * math.pi * rate * i / SR)) for i, v in enumerate(s)]


def finish(s):
    peak = max(abs(v) for v in s) or 1
    s = [v / peak * 0.8 for v in s]
    fade = int(SR * 0.03)
    for i in range(fade):
        s[-1 - i] *= i / fade
    return s


CUES = {
    "tap": mix([(0, pluck(A4, 0.22, 0.990), 1)], 0.22),
    "correct": mix([(0, pluck(G4, 0.3, 0.995), 0.8), (0.14, pluck(D5, 0.31, 0.996), 1)], 0.45),
    "wrong": mix([(0, pluck(D3, 0.35, 0.985, 0.7), 1)], 0.35),
    "combo": mix([(0, pluck(D5, 0.5, 0.996), 0.8), (0.16, pluck(G5, 0.5, 0.996), 0.9),
                  (0.32, tremolo(pluck(A5, 0.48, 0.997)), 1)], 0.8),
    "goal": mix([(0, pluck(D4, 0.6, 0.997), 0.7), (0.15, pluck(G4, 0.6, 0.997), 0.75),
                 (0.30, pluck(A4, 0.6, 0.997), 0.8), (0.45, pluck(D5, 0.7, 0.997), 0.9),
                 (0.62, pluck(G5, 0.75, 0.998), 0.95), (0.80, pluck(D6, 0.6, 0.999), 1)], 1.4),
}

if __name__ == "__main__":
    out_dir = os.path.join(os.path.dirname(__file__), "..", "assets", "sfx")
    os.makedirs(out_dir, exist_ok=True)
    for name, samples in CUES.items():
        pcm = array.array("h", [int(v * 32767) for v in finish(samples)])
        dst = os.path.join(out_dir, name + ".wav")
        with wave.open(dst, "wb") as w:
            w.setnchannels(1); w.setsampwidth(2); w.setframerate(SR)
            w.writeframes(pcm.tobytes())
        print(name, len(samples) / SR, "s")
