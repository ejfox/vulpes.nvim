#!/usr/bin/env python3
"""
Vulpes 2027 — palette derivation script.

All syntax colors are computed from OKLCH parameters defined below.
Edit the parameters, run the script, copy the output into palette.lua.

OKLCH: L (lightness 0–1), C (chroma 0–0.37), H (hue angle 0–360°)
Perceptually uniform — equal steps in L/C look equal to the eye.
"""

import math


# ── OKLCH ↔ sRGB conversion ───────────────────────────────────────────────────

def srgb_to_linear(c):
    if c <= 0.04045:
        return c / 12.92
    return ((c + 0.055) / 1.055) ** 2.4

def linear_to_srgb(c):
    if c <= 0.0031308:
        return 12.92 * c
    return 1.055 * (c ** (1 / 2.4)) - 0.055

def oklch_to_oklab(L, C, H):
    h = math.radians(H)
    return L, C * math.cos(h), C * math.sin(h)

def oklab_to_linear_srgb(L, a, b):
    l_ = (L + 0.3963377774 * a + 0.2158037573 * b) ** 3
    m_ = (L - 0.1055613458 * a - 0.0638541728 * b) ** 3
    s_ = (L - 0.0894841775 * a - 1.2914855480 * b) ** 3
    r =  4.0767416621 * l_ - 3.3077115913 * m_ + 0.2309699292 * s_
    g = -1.2684380046 * l_ + 2.6097574011 * m_ - 0.3413193965 * s_
    b_ = -0.0041960863 * l_ - 0.7034186147 * m_ + 1.7076147010 * s_
    return r, g, b_

def is_in_srgb(L, C, H):
    lab = oklch_to_oklab(L, C, H)
    r, g, b = oklab_to_linear_srgb(*lab)
    return all(-0.0001 <= x <= 1.0001 for x in [r, g, b])

def oklch_to_hex(L, C, H):
    """Convert OKLCH to hex. Reduces chroma if out of sRGB gamut."""
    # Binary search for maximum in-gamut chroma at this L and H
    if not is_in_srgb(L, C, H):
        lo, hi = 0.0, C
        for _ in range(20):
            mid = (lo + hi) / 2
            if is_in_srgb(L, mid, H):
                lo = mid
            else:
                hi = mid
        C = lo

    lab = oklch_to_oklab(L, C, H)
    r, g, b = oklab_to_linear_srgb(*lab)
    r = max(0.0, min(1.0, linear_to_srgb(r)))
    g = max(0.0, min(1.0, linear_to_srgb(g)))
    b = max(0.0, min(1.0, linear_to_srgb(b)))
    return '#{:02x}{:02x}{:02x}'.format(round(r * 255), round(g * 255), round(b * 255))

def hex_to_oklch(hex_str):
    """Utility: inspect any existing hex color."""
    h = hex_str.lstrip('#')
    r, g, b = int(h[0:2],16)/255, int(h[2:4],16)/255, int(h[4:6],16)/255
    r, g, b = srgb_to_linear(r), srgb_to_linear(g), srgb_to_linear(b)
    l_ = (0.4122214708*r + 0.5363325363*g + 0.0514459929*b) ** (1/3)
    m_ = (0.2119034982*r + 0.6806995451*g + 0.1073969566*b) ** (1/3)
    s_ = (0.0883024619*r + 0.2817188376*g + 0.6299787005*b) ** (1/3)
    L  = 0.2104542553*l_ + 0.7936177850*m_ - 0.0040720468*s_
    a  = 1.9779984951*l_ - 2.4285922050*m_ + 0.4505937099*s_
    bv = 0.0259040371*l_ + 0.7827717662*m_ - 0.8086757660*s_
    C  = math.sqrt(a*a + bv*bv)
    H  = math.degrees(math.atan2(bv, a)) % 360
    return L, C, H


# ── Physical hue anchors ──────────────────────────────────────────────────────
# Each H is derived from the measured OKLCH of an existing anchor color,
# or from the physical spectral emission of the hardware reference.
#
# H_PINK    = 341.1°  ← #ff1aca (keyword) measured above
# H_AMBER   = 65.0°   ← slightly redder than warning gold (73.3°); Nixie neon runs hotter
# H_VFD     = 176.0°  ← ZnO:Zn phosphor ~505nm, mapped into OKLCH cyan region
# H_TEAL    = 202.3°  ← #6eedf7 (comment) measured above — FIXED, never change

H_PINK  = 341.0
H_AMBER = 65.0
H_VFD   = 176.0
H_TEAL  = 202.3   # phosphor teal — pinned to existing comment color


# ── Brightness ladder: PINK cluster (330°) ───────────────────────────────────
# Same hue (341°) throughout. L and C decrease each tier.
# On a black background: L dominates perceived brightness.
# C controls saturation — lower C → more grey → reads as "quieter."
#
#  Role          L      C      rationale
#  keyword      0.679  0.284  measured from existing #ff1aca — keep exactly
#  parameter    0.620  0.200  between keyword and variable
#  variable     0.560  0.155  mid — everywhere, must recede
#  property     0.500  0.110  subordinate member access
#  operator     0.440  0.065  ghost — reads as punctuation
#  punctuation  → FG_DARK (near-neutral, defined in foreground section)

PINK = {
    'keyword':   (0.679, 0.284),   # pinned — measured from #ff1aca
    'parameter': (0.620, 0.200),
    'variable':  (0.560, 0.155),
    'property':  (0.500, 0.110),
    'operator':  (0.440, 0.065),
}

# ── Brightness ladder: AMBER cluster (65°) ───────────────────────────────────
# Numbers are the "loudest" literal (full Nixie glow).
# Booleans/constants are status lights — same hue, slightly dimmer.

AMBER = {
    'number':   (0.760, 0.175),   # Nixie tube amber — full digit glow
    'boolean':  (0.700, 0.145),   # Aviation gold — cockpit indicator, dimmer
    'constant': (0.700, 0.145),   # Named literals — same tier as boolean
    'macro':    (0.760, 0.175),   # Code-generating values — same tier as number
}

# ── Brightness ladder: VFD cyan cluster (176°) ───────────────────────────────
# Types are the live structural readout — full VFD brightness.
# Namespace is subordinate structural — dim VFD.

VFD = {
    'type':      (0.780, 0.150),  # VFD active segment
    'builtin':   (0.780, 0.150),  # Builtins are type-adjacent — same tier
    'namespace': (0.650, 0.095),  # Structural but subordinate — dim VFD
}

# ── Fixed / anchored colors ───────────────────────────────────────────────────
# These are either pinned to existing values or computed from their own logic.

FIXED_DARK = {
    # Phosphor teal — pinned. The one existing hue break. Never change.
    'comment':     '#6eedf7',  # OKLCH(0.878, 0.113, 202.3°)

    # White cluster — pure luminance, no hue
    'func':        '#ffffff',  # Pure white — the lamp
    'string':      '#f5f5f5',  # Near-white — content

    # Markup / doc — explicitly == keyword (structural signage)
    # (will be set to computed keyword value in output)

    # Punctuation — near-neutral, same hue family but ghost
    'punctuation': '#735865',  # FG_DARK — existing, keep (near-neutral)
}


# ── Light mode ────────────────────────────────────────────────────────────────
# Same hue clusters, adjusted for white background.
# Dark background needs high L to be visible; light background needs LOW L.
# We invert the lightness relationship: full-brightness → lower L on white bg.
#
# Anchors:
#   LIGHT_PINK  = 341°  (same hue)
#   LIGHT_AMBER = 65°   (same hue)
#   LIGHT_VFD   = 176°  (same hue)
#   LIGHT_TEAL  = 202.3° (same hue, existing #008b8f)
#
# On white bg: target L ~0.40–0.55 for syntax (darker = more contrast)
# Chroma can be higher at lower L (more gamut available in dark midtones)

PINK_LIGHT = {
    'keyword':   (0.440, 0.230),  # dark pink — control flow pops on white
    'parameter': (0.500, 0.170),
    'variable':  (0.540, 0.130),
    'property':  (0.580, 0.095),
    'operator':  (0.620, 0.055),
}

AMBER_LIGHT = {
    'number':   (0.480, 0.160),  # dark amber on white
    'boolean':  (0.520, 0.130),
    'constant': (0.520, 0.130),
    'macro':    (0.480, 0.160),
}

VFD_LIGHT = {
    'type':      (0.460, 0.130),  # dark VFD cyan on white
    'builtin':   (0.460, 0.130),
    'namespace': (0.520, 0.085),
}

FIXED_LIGHT = {
    'comment':     '#008b8f',  # existing dark phosphor teal — keep
    'func':        '#1a0a10',  # near-black — max contrast on white
    'string':      '#1a0a10',  # near-black — content
    'punctuation': '#a08090',  # near linenr — recessive on white
}


# ── Generate ──────────────────────────────────────────────────────────────────

def generate(clusters_h, fixed):
    """clusters_h: list of (cluster_dict, hue_angle). Returns name→hex dict."""
    out = dict(fixed)
    for cluster, H in clusters_h:
        for name, (L, C) in cluster.items():
            out[name] = oklch_to_hex(L, C, H)
    # tag and heading always == keyword
    out['tag']     = out['keyword']
    out['heading'] = out['keyword']
    return out

dark  = generate([(PINK, H_PINK), (AMBER, H_AMBER), (VFD, H_VFD)], FIXED_DARK)
light = generate([(PINK_LIGHT, H_PINK), (AMBER_LIGHT, H_AMBER), (VFD_LIGHT, H_VFD)], FIXED_LIGHT)


# ── Print output ─────────────────────────────────────────────────────────────

ORDER = [
    'comment', 'keyword', 'func', 'string',
    'number', 'boolean', 'constant', 'macro',
    'type', 'builtin', 'namespace',
    'variable', 'parameter', 'property',
    'operator', 'punctuation',
    'tag', 'heading',
]

COMMENTS_DARK = {
    'comment':     'P31 phosphor afterglow — fixed, never change',
    'keyword':     'Argon/neon pink — directional, H=341° OKLCH',
    'func':        'Pure white — max contrast, hot path',
    'string':      'Near-white — human-readable content',
    'number':      'Nixie amber — H=65°, full VU',
    'boolean':     'Aviation gold — H=65°, dim tier',
    'constant':    'Named literals — same tier as boolean',
    'macro':       'Code-generating value — same tier as number',
    'type':        'VFD cyan — H=176°, full brightness',
    'builtin':     'VFD cyan — type-adjacent, same tier',
    'namespace':   'VFD dim — H=176°, subordinate structural',
    'variable':    'Pink mid — H=341°, recedes on dark bg',
    'parameter':   'Pink hi-mid — between variable and keyword',
    'property':    'Pink lo-mid — subordinate member access',
    'operator':    'Pink ghost — reads as punctuation',
    'punctuation': 'Near-neutral — mounting hardware',
    'tag':         '== keyword — HTML/JSX tags are structural',
    'heading':     '== keyword — doc headings are structural',
}

print('-- dark mode syntax (generated by palette-derive.py)\n')
print('-- OKLCH cluster anchors:')
print(f'--   PINK  H=341.0°  (measured from #ff1aca keyword)')
print(f'--   AMBER H=65.0°   (Nixie neon, slightly redder than warning gold)')
print(f'--   VFD   H=176.0°  (ZnO:Zn phosphor ~505nm)')
print(f'--   TEAL  H=202.3°  (P31 radar phosphor, pinned to #6eedf7)\n')

for name in ORDER:
    h = dark[name]
    L, C, H = hex_to_oklch(h)
    cmt = COMMENTS_DARK.get(name, '')
    print(f'  {name:<12}= "{h}",  -- OKLCH({L:.3f}, {C:.3f}, {H:.1f}°)  {cmt}')

print('\n\n-- light mode syntax (generated by palette-derive.py)\n')
for name in ORDER:
    h = light[name]
    L, C, H = hex_to_oklch(h)
    print(f'  {name:<12}= "{h}",  -- OKLCH({L:.3f}, {C:.3f}, {H:.1f}°)')

print('\n\n-- cluster inspection table\n')
print(f'{"name":<14} {"dark":>10}  {"L":>6} {"C":>6} {"H":>7}    {"light":>10}  {"L":>6} {"C":>6} {"H":>7}')
print('-' * 85)
for name in ORDER:
    dh = dark[name]
    lh = light[name]
    dL, dC, dH = hex_to_oklch(dh)
    lL, lC, lH = hex_to_oklch(lh)
    print(f'{name:<14} {dh:>10}  {dL:>6.3f} {dC:>6.3f} {dH:>7.1f}°   {lh:>10}  {lL:>6.3f} {lC:>6.3f} {lH:>7.1f}°')
