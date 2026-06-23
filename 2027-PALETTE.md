# Vulpes 2027 — Design Document

## Scope

This update touches every file in the theme. In order:

```
lua/vulpes/palette.lua          ← source of truth, everything derives from here
lua/vulpes/init.lua             ← highlight group assignments (audit for semantic consistency)
lua/lualine/themes/vulpes.lua   ← mode indicator colors
extras/vulpes-kitty.conf
extras/vulpes-alacritty.toml
extras/vulpes-ghostty.conf
extras/vulpes-wezterm.lua
extras/vulpes.tmux
extras/vulpes-fzf.sh
extras/vulpes-lazygit.yml
extras/vulpes-yazi.toml
extras/vulpes-bat.tmTheme
extras/shaders/                 ← no changes needed
colors/vulpes.vim               ← regenerate from palette
colors/vulpes-light.vim         ← regenerate from palette
```

---

## Problem: No Semantic Layer

The current theme has no intermediate token layer. Hex values go straight from palette
into highlight groups. The result: 13 syntax groups share a 40° hue arc (320–355°) because
they were all set to "pink, slightly different" without a organizing principle.

The fix is a three-layer stack:

```
Layer 1: Physical colors    — named by their hardware origin
Layer 2: Semantic tokens    — named by what they MEAN in the interface
Layer 3: Surface assignments — highlight groups, terminal slots, plugin colors
```

When you change a physical color, every surface that uses its semantic token updates.

---

## Layer 1: Physical Colors (raw palette)

Each color is grounded in a real hardware phenomenon from the cyberpunk brief.

### Dark mode

```
VOID           #000000   background — the absence of phosphor
ALMOST_VOID    #0d0d0d   slight glow off the glass
SURFACE        #121212   raised surface (popups, floats)
DEEP_SELECTION #6b1a3d   selected text background

FG_BRIGHT      #f2cfdf   foreground — pinkish white, warm CRT white
FG_MID         #c490a8   dim foreground
FG_DARK        #735865   very dim — near-invisible text

VULPES_PINK    #e60067   brand — the hot cathode signature color
VULPES_HOT     #ff1aca   high-energy keyword pink (above brand)
VULPES_BRIGHT  #ff277d   bright variant of brand

NIXIE_AMBER    #ff8c00   Nixie tube digit fill (neon gas, 585-703nm)
AVIATION_GOLD  #f0a000   instrument panel backlighting
WARNING_GOLD   #ffaa00   caution/warning (existing, harmonizes with amber)

VFD_CYAN       #00d4b0   ZnO:Zn vacuum fluorescent phosphor (505nm)
VFD_DIM        #00a890   dim VFD — same hue, 2/3 brightness
PHOSPHOR_TEAL  #6eedf7   P31 radar phosphor (525nm, existing comment color)

SIGNAL_WHITE   #f5f5f5   near-white — high readability
PURE_WHITE     #ffffff   maximum contrast

DIM_PINK       #ff6eb4   half-brightness VULPES_HOT
MID_PINK       #e87ab0   between DIM_PINK and VULPES_HOT
FAINT_PINK     #d4609a   low-energy pink — subordinate identifiers
RECESSIVE_ROSE #c44080   dim rose — recessive operators

PHOSPHOR_RED   #ff001e   ANSI red / error-adjacent
DANGER_RED     #a0f7fc   diagnostic error (INVERTED to teal — max contrast on black)
```

### Light mode (parallel set, darkened for white bg)

```
LIGHT_BG       #fefefe
LIGHT_SURFACE  #f5f0f2
LIGHT_POPUP    #ebe5e8

LIGHT_FG       #1a0a10
LIGHT_FG_MID   #4a3040
LIGHT_FG_DARK  #6b5060

LIGHT_BASE     #c50058   darkened VULPES_PINK for white bg
LIGHT_HOT      #c50058   same — not enough room to split

LIGHT_AMBER    #c06800   dark Nixie amber
LIGHT_GOLD     #9a7000   dark aviation gold

LIGHT_CYAN     #007a70   dark VFD cyan
LIGHT_CYAN_DIM #006070   dim version

LIGHT_TEAL     #008b8f   dark phosphor teal (existing comment)

LIGHT_PINK_MID #b04080   muted rose for identifiers
LIGHT_PINK_LOW #7a3060   subordinate identifiers
LIGHT_RECESSIVE #903060  dim rose operators
```

---

## Layer 2: Semantic Tokens

These are the names used in palette.lua. Physical colors map into them here.
Nothing downstream should reference a raw hex — only a semantic token.

### Syntax semantics (the big change)

The current system has one axis: "how pink is it?"
The 2027 system has two axes: **hue** (what kind of thing) × **brightness** (how important).

```
HUES:
  PINK  (330°)  = control flow, language structure
  AMBER (38°)   = literal values — numbers you READ
  CYAN  (175°)  = type system — structure you REASON about
  WHITE (—)     = content — strings and functions you EXECUTE

BRIGHTNESS within each hue:
  FULL    = primary use of that hue (keyword, type, number)
  MID     = secondary (parameter, builtin, constant)
  DIM     = subordinate (property, operator, namespace)
  GHOST   = recessive/structural (punctuation, delimiter)
```

Mapping:

```
semantic token   physical color     hue    brightness   role
─────────────────────────────────────────────────────────────────────
comment          PHOSPHOR_TEAL      185°   full         orthogonal to all syntax — intentional
keyword          VULPES_HOT         330°   full         control flow — the PINK signature
tag              VULPES_HOT         330°   full         HTML/JSX tags = structural keywords
heading          VULPES_HOT         330°   full         doc structure = structural keywords
func             PURE_WHITE          —     max          hot path — max contrast
string           SIGNAL_WHITE        —     high         content — high contrast
number           NIXIE_AMBER        38°    full         literal digits
boolean          AVIATION_GOLD      38°    mid          literal true/false (dimmer than number)
constant         AVIATION_GOLD      38°    mid          named literals (= boolean)
macro            NIXIE_AMBER        38°    full         macros aree code-generating values
type             VFD_CYAN           175°   full         the type system is its own world
builtin          VFD_CYAN           175°   full         builtins are type-adjacent
namespace        VFD_DIM            175°   dim          structural, subordinate to type
variable         DIM_PINK           330°   mid          everywhere — needs to recede
parameter        MID_PINK           330°   mid+         slightly above variable
property         FAINT_PINK         330°   low          subordinate member access
operator         RECESSIVE_ROSE     330°   ghost        reads as punctuation
punctuation      FG_DARK             —     ghost        nearly invisible structure
```

### Semantic colors (UI, diagnostics)

```
semantic token   physical color     rationale
──────────────────────────────────────────────────────
base             VULPES_PINK        brand signature — borders, cursor, active UI
base_bright      VULPES_BRIGHT      hover/active variant of brand
error            DANGER_RED         INVERTED to teal — max pop on black bg
warning          WARNING_GOLD       amber-adjacent, reads as caution
success          PURE_WHITE         success = clarity = white
info             VULPES_PINK        info messages use brand color
hint             DIM_PINK           hints are subtle
```

---

## Layer 3: Surface Assignments

### palette.lua changes (dark)

```lua
-- KEEP (these already work):
comment    = PHOSPHOR_TEAL  "#6eedf7"  -- the one existing hue break
keyword    = VULPES_HOT     "#ff1aca"  -- brand pink, control flow
func       = PURE_WHITE     "#ffffff"  -- hot path
string     = SIGNAL_WHITE   "#f5f5f5"  -- content
-- all backgrounds, UI colors, git colors stay the same

-- CHANGE (from monopink to hue clusters):
number     = NIXIE_AMBER    "#ff8c00"  -- was "#ff33c5"
boolean    = AVIATION_GOLD  "#f0a000"  -- was "#ff1043"
constant   = AVIATION_GOLD  "#f0a000"  -- was "#ff1043"
macro      = NIXIE_AMBER    "#ff8c00"  -- was "#f92a9c"
type       = VFD_CYAN       "#00d4b0"  -- was "#ff24ab"
builtin    = VFD_CYAN       "#00d4b0"  -- was "#f82956"
namespace  = VFD_DIM        "#00a890"  -- was "#f8326e"
variable   = DIM_PINK       "#ff6eb4"  -- was "#ff0a89"
parameter  = MID_PINK       "#e87ab0"  -- was "#ff057e"
property   = FAINT_PINK     "#d4609a"  -- was "#ff0a91"
operator   = RECESSIVE_ROSE "#c44080"  -- was "#f92c7a"
punctuation = FG_DARK       "#735865"  -- was "#f82470"
tag        = VULPES_HOT     "#ff1aca"  -- was "#f82e64" (now explicitly == keyword)
heading    = VULPES_HOT     "#ff1aca"  -- was "#ff2453" (now explicitly == keyword)
```

### init.lua — audit required

The following groups in init.lua need to be double-checked for semantic consistency
after the palette change. They don't need hex edits (they reference palette tokens)
but the token meanings have shifted so the *intent* needs checking:

```
PreProc → c.base           Was: "preprocessor = brand pink" — still ok? or should it be amber?
Include → c.keyword        Ok — imports are control flow
Define  → c.keyword        Ok — defines are control flow
Exception → c.error        Ok — exceptions are danger
Special → c.base           Was: "special = brand pink" — review case by case
SpecialChar → c.base       Was: "special chars = brand pink" — ok, escape sequences pop
PmenuKind → c.type         ← GOOD: completion item kinds use type color (cyan)
PmenuKindSel → c.type      ← GOOD
@string.regex → c.warning  ← GOOD: regex uses warning gold — regex is weird/powerful
@string.escape → c.base    ← review: escape sequences = brand pink or amber?
@attribute → c.base        ← review: decorators/attributes = brand pink or cyan?
@markup.list → c.base      ← review: list bullets = brand pink? or dim?
```

### lualine — mode indicators

Current mode → color mapping and proposed update:

```
mode       current token    current color   proposed change
──────────────────────────────────────────────────────────
NORMAL     base             #e60067 pink    KEEP — brand = home
INSERT     success          #ffffff white   → VFD_CYAN #00d4b0  (INSERT = typing new structure)
VISUAL     warning          #ffaa00 gold    KEEP — amber = selection, value
REPLACE    error            #a0f7fc teal    KEEP — replace = danger
COMMAND    info             #ff0095 pink    → VULPES_HOT #ff1aca (command = high-energy)
INACTIVE   fg_dim/comment   dim             KEEP
```

INSERT → cyan rationale: you're entering new type definitions, new structure, new content.
Cyan = structural. It's also maximally distinct from NORMAL (pink) and VISUAL (gold).

### Terminal ANSI colors

The ANSI palette is used by shell, ls, grep, etc. — not just nvim syntax.
Proposed changes are minimal to avoid breaking shell expectations.

```
slot   name           current          proposed         rationale
───────────────────────────────────────────────────────────────────────────
0      black          #0d0d0d          KEEP
1      red            #ff001e          KEEP             system red, error
2      green          #ffffff          KEEP             vulpes green = white (intentional)
3      yellow         #ffaa00          → #ff8c00        pull yellow into Nixie amber cluster
4      blue           #ff0095          KEEP             blue → pink mapping (intentional)
5      magenta        #ff24ab          KEEP
6      cyan           #6eedf7          KEEP             phosphor teal stays iconic
7      white          #f2cfdf          KEEP
8      bright_black   #735865          KEEP
9      bright_red     #ff2e2e          KEEP
10     bright_green   #ffffff          KEEP
11     bright_yellow  #ffcc00          → #ff8c00        harmonize with new yellow
12     bright_blue    #ff2daf          KEEP
13     bright_magenta #ff40c7          KEEP
14     bright_cyan    #a0f7fc          → #00d4b0        VFD cyan as bright cyan
15     bright_white   #ffffff          KEEP
```

Only 3 changes. `yellow`/`bright_yellow` pull into amber. `bright_cyan` becomes VFD cyan
instead of the washed-out `#a0f7fc`.

### External configs — what changes

All external configs (kitty, alacritty, ghostty, wezterm, tmux, fzf) derive their
colors from the ANSI palette + a few UI colors (bg, fg, base, border, selection).

Since UI colors and most ANSI slots are unchanged, the delta is small:

```
file                    changes needed
────────────────────────────────────────────────────────────────────
vulpes-kitty.conf       color3, color11, color14 (3 slots)
vulpes-alacritty.toml   yellow, bright_yellow, bright_cyan (3 slots)
vulpes-ghostty.conf     palette 3, 11, 14 (3 slots)
vulpes-wezterm.lua      ansi[3], brights[3], brights[6] (3 slots)
vulpes.tmux             NO CHANGE (uses bg, base, warning — all kept)
vulpes-fzf.sh           NO CHANGE (uses base, bg, warning — all kept)
vulpes-lazygit.yml      NO CHANGE (uses base, border, warning — all kept)
vulpes-yazi.toml        NO CHANGE (uses base, warning, bg — all kept)
```

### bat.tmTheme — syntax token changes

bat uses TextMate scopes. Changes needed for the new syntax clusters:

```
scope                              current          proposed
────────────────────────────────────────────────────────────
constant.numeric                   #ff33c5          #ff8c00
constant.numeric.float             #ff33c5          #ff8c00
constant.language (true/false)     #ff1043          #f0a000
constant.other                     #ff1043          #f0a000
storage.type                       #ff24ab          #00d4b0
entity.name.type                   #ff24ab          #00d4b0
entity.name.class                  #ff24ab          #00d4b0
support.type                       #f82956          #00d4b0
support.class                      #f82956          #00d4b0
variable                           #ff0a89          #ff6eb4
variable.parameter                 (add)            #e87ab0
entity.name.function (if present)  check            keep white
```

---

## Design Decisions (closed)

1. **`@string.escape`** → AMBER (`#ff8c00`). `\n` is the numerical value 10 in a string
   costume — a literal value embedded in content. Not structural, not keyword.

2. **`@attribute` / `@attribute.builtin`** → CYAN (`c.type`). Decorators annotate the type
   system (`#[derive(Debug)]`, `@Component`). Type-system annotation, not control flow.

3. **`type` vs `comment` distinction** — VFD (#00d4b0) is saturated/active. Phosphor teal
   (#6eedf7) is lighter/washed-out. Physically correct: afterglow IS a fading version of
   the strike. They read as family (same cyan region) but different states (on vs decaying).
   If they compete on screen, push type toward `#00c4d4` (bluer). Eyeball check on step 8.

4. **`boolean` contrast** — `#f0a000` on black. Needs screen check. If marginal, bump to
   `#f5a800`. Deferred to step 8.

5. **INSERT mode lualine** → VFD CYAN (`#00d4b0`). INSERT = entering new structure. Cyan
   is maximally distinct from NORMAL (pink) and VISUAL (gold).

6. **`color2` ANSI green** → KEEP WHITE. "Our green is white" is intentional vulpes
   provocation. Changing it makes the terminal look normal. The tension is the point.

7. **`macro`** → AMBER. Macros are code-generating values (Rust `vec![]`, `println!`).
   Value-producing → amber cluster.

8. **`italic_keywords` default** → FALSE. Neon signage is upright and structural. Keywords
   are directional — they tell the program where to go. Never italic.

9. **`italic_comments` default** → TRUE. Physically earned: P31 phosphor persistence is a
   whisper, the signal fading after the beam has moved on. Comments ARE the afterglow.

10. **Light mode** — this PR applies the parallel darkened semantic system. Schematic
    redesign (light mode as technical blueprint, not inverted dark) is a separate session.

## Typographic Conventions (from physics)

```
element      italic   bold    rationale
─────────────────────────────────────────────────────────────────────────────
comment      YES      no      P31 persistence — whisper, aside, afterglow
keyword      NO       no      neon signage — upright, directional, structural
function     no       YES     the lamp — brightest point, maximum weight
type         NO       no      VFD segment — crisp, clean, no decorative weight
number       NO       no      Nixie digit — physical 3D object, not italicized
boolean      NO       no      cockpit indicator light — on or off, no affect
string       no       no      content — let the near-white carry it
variable     no       no      everywhere — any extra weight compounds
parameter    MAYBE    no      footnote-like — context-dependent, positional
operator     no       no      structural punctuation — invisible when working
```

Default config changes:
  italic_comments  = true   (was false — now physically justified)
  italic_keywords  = false  (was true — physically incorrect)
  bold_functions   = true   (was false — the lamp should be the brightest)

---

## Light Mode Changes

Same semantic structure, darkened for white background. Parallel to dark changes.

```
palette.lua (light)

number     "#b8007a" → "#c06800"   dark Nixie amber
boolean    "#c50040" → "#9a7000"   dark aviation gold
constant   "#c50040" → "#9a7000"
macro      "#c52080" → "#c06800"   dark amber
type       "#a80070" → "#007a70"   dark VFD cyan
builtin    "#c52050" → "#007a70"
namespace  "#c52058" → "#006070"   dim dark cyan
variable   "#c50070" → "#b04080"   muted rose
parameter  "#c50065" → "#984070"
property   "#c50075" → "#7a3060"   subordinate rose
operator   "#d02060" → "#903060"   dim recessive rose
punctuation "#c52060" → "#a08090" (near linenr — existing)
tag        "#c52050" → "#c50058"   (= keyword, explicit)
heading    "#c52045" → "#c50058"   (= keyword, explicit)
```

---

## Implementation Checklist

```
[ ] Review answers to open design questions above
[ ] Update palette.lua dark (syntax tokens)
[ ] Update palette.lua light (syntax tokens)
[ ] Audit init.lua — check PreProc, Special, @attribute, @string.escape, @markup.list
[ ] Update lualine INSERT mode color (if going with cyan)
[ ] Update vulpes-kitty.conf (3 slots)
[ ] Update vulpes-alacritty.toml (3 slots)
[ ] Update vulpes-ghostty.conf (3 slots)
[ ] Update vulpes-wezterm.lua (3 slots)
[ ] Update vulpes-bat.tmTheme (8 scope changes)
[ ] Regenerate colors/vulpes.vim and colors/vulpes-light.vim
[ ] Screenshot: TypeScript file (type/interface/const/number heavy)
[ ] Screenshot: Rust file (type system, macros, lifetimes)
[ ] Screenshot: Lua file (the vulpes source itself)
[ ] Screenshot: Markdown doc (heading/string/comment/link mix)
[ ] Screenshot: terminal output (ls, grep — ANSI color check)
[ ] Check WCAG contrast on amber values at 14px weight
[ ] PR → main
[ ] Tag v2027.1
[ ] Update README with before/after screenshots
```
