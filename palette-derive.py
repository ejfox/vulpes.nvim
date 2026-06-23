#!/usr/bin/env python3
"""
Vulpes — palette derivation. ONE PHOSPHOR.

Follows cyberpunk-design-brief.md (~/code/cyberpunk-design-brief.md), Section I:

  Rule 1: "One dominant emission color per surface, per context, per screen.
           Do not layer multiple neons."
  Rule 2: "Void is always absolute. Background is #000000."
  Rule 3: "Opacity variants, not new colors. If you need hierarchy within a
           color, use opacity (100%, 60%, 30%, 8%) — same hue, different
           luminance. The phosphor glows brightest at the center and fades
           toward the edges."

A code editor is the brief's TERMINAL archetype: "all one color on black."
So vulpes is monochrome. Its chosen phosphor is the VULPES PINK (the fox is
the one thing the brief does not supply; everything else obeys it). Every
syntax token is that ONE pink at a different INTENSITY — literally the phosphor
composited over void at a given opacity. Hierarchy is luminance, never hue.

This replaces the multi-hue 2027 clusters, which violated Rule 1 (layered
neons) and Rule 3 (encoded importance as hue instead of opacity).

Edit the intensities, run, paste into palette.lua.
"""

import math


# ── sRGB ↔ linear ────────────────────────────────────────────────────────────

def s2l(c): c /= 255.0; return c/12.92 if c <= 0.04045 else ((c+0.055)/1.055)**2.4
def l2s(c):
    c = max(0.0, min(1.0, c))
    return 12.92*c if c <= 0.0031308 else 1.055*c**(1/2.4) - 0.055

def hx2rgb(h): h = h.lstrip('#'); return tuple(int(h[i:i+2], 16) for i in (0, 2, 4))
def rgb2hx(r, g, b): return '#{:02x}{:02x}{:02x}'.format(round(r), round(g), round(b))

def over(fg_hex, bg_hex, alpha):
    """Composite fg over bg at `alpha`, in LINEAR light (physically correct).
    On void this is exactly 'the phosphor at `alpha` intensity' — constant hue,
    luminance scales with alpha. That is Rule 3."""
    fg = [s2l(c) for c in hx2rgb(fg_hex)]
    bg = [s2l(c) for c in hx2rgb(bg_hex)]
    out = [f*alpha + b*(1-alpha) for f, b in zip(fg, bg)]
    return rgb2hx(*[l2s(c)*255 for c in out])

# OKLCH inspector — used only to PROVE the ramp holds one hue.
def oklch(hx):
    r, g, b = (s2l(c) for c in hx2rgb(hx))
    l = (0.4122214708*r+0.5363325363*g+0.0514459929*b)**(1/3)
    m = (0.2119034982*r+0.6806995451*g+0.1073969566*b)**(1/3)
    s = (0.0883024619*r+0.2817188376*g+0.6299787005*b)**(1/3)
    L = 0.2104542553*l+0.7936177850*m-0.0040720468*s
    A = 1.9779984951*l-2.4285922050*m+0.4505937099*s
    B = 0.0259040371*l+0.7827717662*m-0.8086757660*s
    return L, math.hypot(A, B), math.degrees(math.atan2(B, A)) % 360

def oklch_to_hex(L, C, H):
    def conv(L, C, H):
        a = C*math.cos(math.radians(H)); b = C*math.sin(math.radians(H))
        l = (L+0.3963377774*a+0.2158037573*b)**3
        m = (L-0.1055613458*a-0.0638541728*b)**3
        s = (L-0.0894841775*a-1.2914855480*b)**3
        return (4.0767416621*l-3.3077115913*m+0.2309699292*s,
                -1.2684380046*l+2.6097574011*m-0.3413193965*s,
                -0.0041960863*l-0.7034186147*m+1.7076147010*s)
    lo, hi = 0.0, C
    for _ in range(24):
        mid = (lo+hi)/2
        if all(-0.001 <= x <= 1.001 for x in conv(L, mid, H)): lo = mid
        else: hi = mid
    return rgb2hx(*[l2s(max(0, min(1, x)))*255 for x in conv(L, lo, H)])


# ── THE PHOSPHOR ─────────────────────────────────────────────────────────────
# Base hue: VFD / Ghost-in-the-Shell BLUE-GREEN (the brief's 505nm phosphor,
# #00d4b0). Not pink. This is the dominant emission color (Rule 1).
#
# Two-axis hierarchy:
#   INTENSITY (luminance + chroma) = how important   — the main signal
#   HUE_OFFSET (±4° around base)    = what kind        — subtle semantic cue
# Everything stays within an 8° arc, so it still reads as ONE color per Rule 1,
# but related things cluster and different things separate by a few degrees.
# Convention around the blue-green base: −offset = greener (terminal/command),
# +offset = bluer (structure/data, the GitS wireframe).

H_BASE = oklch('#00d4b0')[2]   # ≈176° — the VFD/ghost-shell blue-green

VOID  = '#000000'   # Rule 2 — absolute
PAPER = '#f6faf9'   # light bg — faint cool paper

INTENSITY = {  # how important (luminance/chroma tier)
    'func': 1.00, 'keyword': 0.90, 'tag': 0.90, 'heading': 0.90,
    'type': 0.80, 'builtin': 0.80, 'string': 0.74,
    'number': 0.68, 'macro': 0.68, 'boolean': 0.64, 'constant': 0.64,
    'variable': 0.56, 'parameter': 0.52, 'property': 0.46, 'namespace': 0.46,
    'operator': 0.40, 'comment': 0.36, 'punctuation': 0.28,
}
HUE_OFFSET = {k: 0 for k in INTENSITY}  # ONE COLOR. brief line 177: "Not through
# color — the system has one color." Rule 1: do not layer neons. Rule 3: opacity
# variants, not new colors. Hierarchy is luminance of ONE teal hue, full stop.
# (Token KIND is read by position/structure; importance is read by luminance.)
ORDER = list(INTENSITY.keys())

def build(L0, L1, C0, C1, bg_unused):
    # L,C scale with intensity (bright phosphor = high L & C; dim = low both).
    # Chroma kept high enough that the hue spread is actually visible.
    out = {}
    for k, a in INTENSITY.items():
        L = L0 + (L1 - L0) * a
        C = C0 + (C1 - C0) * a
        out[k] = oklch_to_hex(L, C, H_BASE + HUE_OFFSET[k])
    return out

# dark: bright blue-green on void. light: dark teal ink on paper (more important = darker).
dark  = build(0.55, 0.88, 0.115, 0.205, VOID)
light = build(0.66, 0.36, 0.095, 0.160, PAPER)


# ── Output ───────────────────────────────────────────────────────────────────

def emit(title, table, bg):
    print(f'-- {title} syntax — ONE teal phosphor, luminance hierarchy (per cyberpunk brief)')
    print(f'--   hue H={H_BASE:.0f}° (fixed)  ·  bg = {bg}  ·  importance = opacity/luminance only')
    for k in ORDER:
        L, C, H = oklch(table[k])
        print(f'  {k:<12}= "{table[k]}",  -- {int(INTENSITY[k]*100):>3}%  '
              f'OKLCH(L={L:.2f} C={C:.2f} H={H:5.1f}°)')
    print()

emit('DARK', dark, VOID)
emit('LIGHT', light, PAPER)

# Proof: hue stays within base±4°, luminance carries the main hierarchy.
print(f'proof — dark ramp: hue within {H_BASE:.0f}±4°, intensity carries hierarchy:')
print(f'{"token":<12}{"hex":>9}{"%":>6}{"off":>5}{"L":>7}{"C":>7}{"H":>8}')
print('-'*52)
for k in ORDER:
    L, C, H = oklch(dark[k])
    print(f'{k:<12}{dark[k]:>9}{int(INTENSITY[k]*100):>5}%{HUE_OFFSET[k]:>+5}{L:>7.2f}{C:>7.3f}{H:>7.1f}°')

import json
json.dump({'dark': dark, 'light': light, 'base_hue': H_BASE,
           'void': VOID, 'paper': PAPER}, open('/tmp/vulpes-new-palette.json', 'w'))
