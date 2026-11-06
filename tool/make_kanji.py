#!/usr/bin/env python3
"""Genera los datos del modulo Kanji (grado 1) a partir de KANJIDIC2 y KanjiVG.

Uso (necesita red una sola vez, solo en desarrollo):
    python3 tool/make_kanji.py

Escribe:
    lib/core/data/seed_kanji.dart        kanji y detalles
    lib/core/data/seed_kanji_words.dart  vocabulario (si existe tool/kanji_words.txt)
    assets/kanji/strokes.json            trazos en el formato de assets/kana/strokes.json
La app nunca usa la red.
"""
import gzip
import json
import os
import re
import sys
import urllib.request
import xml.etree.ElementTree as ET

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CACHE = os.path.join(os.environ.get('TMPDIR', '/tmp'), 'petrufc_kanji_cache')
GRADE = 1
KANJIDIC = 'http://www.edrdg.org/kanjidic/kanjidic2.xml.gz'
KVG = 'https://raw.githubusercontent.com/KanjiVG/kanjivg/master/kanji/%s.svg'

# Significado principal cuando el primero de KANJIDIC2 se repite o confunde (idioma -> kanji -> texto).
MEANING_FIX = {
    'en': {'校': 'school', '中': 'middle', '空': 'sky', '川': 'river', '文': 'writing', '出': 'go out',
           '先': 'previous', '月': 'moon', '円': 'yen', '天': 'heaven', '貝': 'shell', '力': 'strength'},
    'es': {'女': 'mujer', '男': 'hombre', '村': 'aldea', '川': 'río', '足': 'pie', '車': 'auto',
           '月': 'luna', '円': 'yen', '中': 'dentro', '先': 'anterior', '文': 'escritura',
           '子': 'niño', '力': 'fuerza', '見': 'ver'},
}

# Lectura principal (hiragana) cuando la primera kun de KANJIDIC2 no es la mas natural para estudiar.
MAIN_FIX = {
    '一': 'いち', '二': 'に', '三': 'さん', '四': 'よん', '五': 'ご', '六': 'ろく', '八': 'はち', '九': 'きゅう',
    '十': 'じゅう', '百': 'ひゃく', '千': 'せん', '円': 'えん', '学': 'がく', '気': 'き', '校': 'こう',
    '字': 'じ', '天': 'てん', '文': 'ぶん', '本': 'ほん', '大': 'おおきい', '王': 'おう', '生': 'せい',
}


def fetch(url, name):
    os.makedirs(CACHE, exist_ok=True)
    path = os.path.join(CACHE, name)
    if not os.path.exists(path):
        with urllib.request.urlopen(url, timeout=60) as r, open(path, 'wb') as f:
            f.write(r.read())
    return path


# ---------- kana y romaji ----------
_H = ('あいうえお かきくけこ さしすせそ たちつてと なにぬねの はひふへほ まみむめも や ゆ よ らりるれろ わ を ん '
      'がぎぐげご ざじずぜぞ だぢづでど ばびぶべぼ ぱぴぷぺぽ').replace(' ', '')
_R = ('a i u e o ka ki ku ke ko sa shi su se so ta chi tsu te to na ni nu ne no ha hi fu he ho '
      'ma mi mu me mo ya yu yo ra ri ru re ro wa o n ga gi gu ge go za ji zu ze zo da ji zu de do '
      'ba bi bu be bo pa pi pu pe po').split()
_ROM = dict(zip(_H.replace('ゃ', ''), _R))
_ROM.update({'ぁ': 'a'})
_COMBO = {'ゃ': 'a', 'ゅ': 'u', 'ょ': 'o'}
_SMALL_VOWEL = {'ぁ': 'a', 'ぃ': 'i', 'ぅ': 'u', 'ぇ': 'e', 'ぉ': 'o'}


def to_hira(s):
    return ''.join(chr(ord(c) - 0x60) if 'ァ' <= c <= 'ヶ' else c for c in s)


def romaji(h):
    out = []
    i = 0
    double = False
    while i < len(h):
        c = h[i]
        if c == 'っ':
            double = True
            i += 1
            continue
        if c == 'ー':
            out.append(out[-1][-1] if out else '')
            i += 1
            continue
        r = _ROM[c]
        if i + 1 < len(h) and h[i + 1] in _COMBO:
            base = r[:-1]
            r = {'shi': 'sh', 'chi': 'ch', 'ji': 'j'}.get(r, base + 'y')
            r += _COMBO[h[i + 1]]
            i += 1
        if double:
            r = r[0] + r
            double = False
        out.append(r)
        i += 1
    return ''.join(out)


# ---------- KANJIDIC2 ----------
def load_kanji():
    path = fetch(KANJIDIC, 'kanjidic2.xml.gz')
    root = ET.fromstring(gzip.open(path).read())
    res = []
    for ch in root.iter('character'):
        misc = ch.find('misc')
        g = misc.find('grade')
        if g is None or int(g.text) != GRADE:
            continue
        lit = ch.find('literal').text
        on, kun, en, es = [], [], [], []
        rm = ch.find('reading_meaning')
        for grp in rm.iter('rmgroup'):
            for r in grp.findall('reading'):
                if r.get('r_type') == 'ja_on':
                    on.append(r.text)
                elif r.get('r_type') == 'ja_kun':
                    kun.append(r.text)
            for m in grp.findall('meaning'):
                lang = m.get('m_lang')
                if lang is None:
                    en.append(m.text)
                elif lang == 'es':
                    es.append(m.text)
        res.append({
            'c': lit,
            'strokes': int(misc.find('stroke_count').text),
            'on': on, 'kun': kun, 'en': en, 'es': es,
        })
    return res


def clean_kun(k):
    return k.replace('.', '').replace('-', '')


def main_reading(k):
    fix = MAIN_FIX.get(k['c'])
    if fix:
        valid = {clean_kun(x) for x in k['kun']} | {to_hira(clean_kun(x)) for x in k['on']}
        if fix not in valid:
            raise SystemExit('lectura principal %s no es valida para %s' % (fix, k['c']))
        return fix
    if k['kun']:
        return clean_kun(k['kun'][0])
    return to_hira(k['on'][0])


# ---------- KanjiVG ----------
_TOK = re.compile(r'([MmCcSsLlHhVvZz])|(-?\d*\.?\d+(?:e-?\d+)?)')


def num(v):
    s = ('%.2f' % v).rstrip('0').rstrip('.')
    return '0' if s in ('-0', '') else s


def normalize(d):
    """Convierte cualquier comando de KanjiVG a M (absoluto) y c (relativo), el formato de la app."""
    toks = [(a or b) for a, b in _TOK.findall(d)]
    i = 0
    cmd = None
    x = y = sx = sy = 0.0
    last_c2 = None  # segundo punto de control absoluto del ultimo bezier (para S)
    out = []
    while i < len(toks):
        if re.fullmatch(r'[A-Za-z]', toks[i]):
            cmd = toks[i]
            i += 1
            if cmd in 'Zz':
                continue
        n = {'M': 2, 'm': 2, 'L': 2, 'l': 2, 'H': 1, 'h': 1, 'V': 1, 'v': 1,
             'C': 6, 'c': 6, 'S': 4, 's': 4}[cmd]
        a = [float(t) for t in toks[i:i + n]]
        i += n
        if cmd in 'Mm':
            nx, ny = (a[0], a[1]) if cmd == 'M' else (x + a[0], y + a[1])
            out.append('M%s,%s' % (num(nx), num(ny)))
            x, y = nx, ny
            sx, sy = x, y
            cmd = 'L' if cmd == 'M' else 'l'
            last_c2 = None
            continue
        if cmd in 'Ll':
            nx, ny = (a[0], a[1]) if cmd == 'L' else (x + a[0], y + a[1])
            c1, c2 = (x + (nx - x) / 3, y + (ny - y) / 3), (x + 2 * (nx - x) / 3, y + 2 * (ny - y) / 3)
        elif cmd in 'Hh':
            nx, ny = (a[0] if cmd == 'H' else x + a[0]), y
            c1, c2 = (x + (nx - x) / 3, y), (x + 2 * (nx - x) / 3, y)
        elif cmd in 'Vv':
            nx, ny = x, (a[0] if cmd == 'V' else y + a[0])
            c1, c2 = (x, y + (ny - y) / 3), (x, y + 2 * (ny - y) / 3)
        elif cmd in 'Cc':
            o = (0, 0) if cmd == 'C' else (x, y)
            c1 = (o[0] + a[0], o[1] + a[1])
            c2 = (o[0] + a[2], o[1] + a[3])
            nx, ny = o[0] + a[4], o[1] + a[5]
        else:  # S, s
            o = (0, 0) if cmd == 'S' else (x, y)
            c1 = (2 * x - last_c2[0], 2 * y - last_c2[1]) if last_c2 else (x, y)
            c2 = (o[0] + a[0], o[1] + a[1])
            nx, ny = o[0] + a[2], o[1] + a[3]
        out.append('c%s,%s,%s,%s,%s,%s' % (
            num(c1[0] - x), num(c1[1] - y), num(c2[0] - x), num(c2[1] - y), num(nx - x), num(ny - y)))
        last_c2 = c2
        x, y = nx, ny
    # une los c consecutivos como en strokes.json de kana ("c a,b,c,d,e,f c ..." se deja tal cual)
    return ''.join(out)


def load_strokes(ch):
    name = '%05x' % ord(ch)
    svg = open(fetch(KVG % name, 'kvg_%s.svg' % name), encoding='utf-8').read()
    paths = re.findall(r'<path id="kvg:%s-s\d+"[^>]*? d="([^"]+)"' % name, svg)
    nums = re.findall(r'<text transform="matrix\(1 0 0 1 ([\d.]+) ([\d.]+)\)">\d+</text>', svg)
    return ([normalize(p) for p in paths],
            [[float(a), float(b)] for a, b in nums])


# ---------- salida ----------
def dq(s):
    return "'" + s.replace('\\', '\\\\').replace("'", "\\'").replace('$', '\\$') + "'"


def build():
    kanji = load_kanji()
    errors = []
    if len(kanji) != 80:
        errors.append('se esperaban 80 kanji de grado %d, hay %d' % (GRADE, len(kanji)))
    seen = {'en': {}, 'es': {}}
    rows = []
    strokes = {}
    for k in kanji:
        c = k['c']
        for lang in ('en', 'es'):
            fix = MEANING_FIX[lang].get(c)
            if fix:
                k[lang].insert(0, fix)
            if not k[lang]:
                errors.append('%s sin significado %s' % (c, lang))
                continue
            m = k[lang][0]
            if m in seen[lang]:
                errors.append('significado %s repetido (%s lo tiene %s y %s)' % (lang, m, seen[lang][m], c))
            seen[lang][m] = c
        if not (k['on'] or k['kun']):
            errors.append('%s sin lecturas' % c)
            continue
        p, n = load_strokes(c)
        if len(p) != k['strokes']:
            errors.append('%s: %d trazos en KanjiVG y %d en KANJIDIC2' % (c, len(p), k['strokes']))
        if len(n) != len(p):
            errors.append('%s: %d numeros y %d trazos' % (c, len(n), len(p)))
        strokes[c] = {'p': p, 'n': n}
        h = main_reading(k)
        rows.append((c, romaji(h), h, k['es'][0], k['en'][0], k['strokes'],
                     '、'.join(to_kata_on(k['on'])), '、'.join(k['kun'])))
    return rows, strokes, errors


def to_kata_on(on):
    return on  # KANJIDIC2 ya los entrega en katakana


def write_kanji(rows, strokes):
    lines = ["// GENERADO por tool/make_kanji.py (KANJIDIC2, EDRDG, CC BY-SA 4.0). No editar a mano.",
             "// kanji | romaji | lectura principal | espanol | ingles | trazos | on | kun",
             "const seedKanjiRows = <List<Object>>["]
    for r in rows:
        lines.append('  [' + ', '.join(str(v) if isinstance(v, int) else dq(v) for v in r) + '],')
    lines.append('];')
    with open(os.path.join(ROOT, 'lib/core/data/seed_kanji.dart'), 'w', encoding='utf-8') as f:
        f.write('\n'.join(lines) + '\n')
    os.makedirs(os.path.join(ROOT, 'assets/kanji'), exist_ok=True)
    with open(os.path.join(ROOT, 'assets/kanji/strokes.json'), 'w', encoding='utf-8') as f:
        json.dump(strokes, f, ensure_ascii=False, separators=(',', ':'))


SECTIONS = ['numbers', 'nature', 'body_people', 'school', 'time', 'animals_colors']


def write_words(kset):
    path = os.path.join(ROOT, 'tool/kanji_words.txt')
    if not os.path.exists(path):
        return []
    errors = []
    words = {s: [] for s in SECTIONS}
    seen = set()
    for n, line in enumerate(open(path, encoding='utf-8'), 1):
        line = line.rstrip('\n')
        if not line or line.startswith('#'):
            continue
        f = line.split('\t')
        if len(f) != 6 or not all(f):
            errors.append('palabras linea %d: se esperaban 6 campos' % n)
            continue
        sec, w, hira, rom, en, es = f
        if sec not in words:
            errors.append('palabras linea %d: seccion desconocida %s' % (n, sec))
            continue
        bad = [c for c in w if c not in kset]
        if bad:
            errors.append('palabra %s tiene caracteres fuera del grado 1: %s' % (w, ''.join(bad)))
        if w in seen:
            errors.append('palabra repetida: %s' % w)
        seen.add(w)
        if romaji(hira) != rom:
            errors.append('romaji de %s: %s != %s' % (w, rom, romaji(hira)))
        words[sec].append((w, hira, rom, en, es))
    for s, ws in words.items():
        if len(ws) < 8:
            errors.append('seccion %s con %d palabras (minimo 8)' % (s, len(ws)))
    lines = ["// GENERADO por tool/make_kanji.py desde tool/kanji_words.txt. No editar a mano.",
             "// seccion | palabra | hiragana | romaji | ingles | espanol",
             "const seedKanjiWordRows = <List<String>>["]
    for s in SECTIONS:
        for w, hira, rom, en, es in words[s]:
            lines.append('  [' + ', '.join(dq(v) for v in (s, w, hira, rom, en, es)) + '],')
    lines.append('];')
    with open(os.path.join(ROOT, 'lib/core/data/seed_kanji_words.dart'), 'w', encoding='utf-8') as f:
        f.write('\n'.join(lines) + '\n')
    return errors


def main():
    rows, strokes, errors = build()
    errors += write_words(set(strokes))
    if errors:
        print('ERRORES:')
        for e in errors:
            print(' -', e)
        sys.exit(1)
    write_kanji(rows, strokes)
    size = os.path.getsize(os.path.join(ROOT, 'assets/kanji/strokes.json'))
    print('OK: %d kanji, %d con trazos, strokes.json %d bytes' % (len(rows), len(strokes), size))


if __name__ == '__main__':
    main()
