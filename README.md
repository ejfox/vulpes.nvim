# vulpes.nvim

A cyberpunk neon single-color(ish) scheme for Neovim (and many other TUIs) that tries to find a balance between vibes and utility.

<img width="1800" height="1131" alt="screenshot 2025-12-24 at 3 28 57 PM" src="https://github.com/user-attachments/assets/77a9fb8e-33d0-4562-83cb-0f8cc11b1499" />

<img width="1800" height="1169" alt="screenshot 2025-12-22 at 11 30 20 PM" src="https://github.com/user-attachments/assets/d8c588f0-c75d-4d2f-bf21-0837ac536ece" />

## Includes

```
Neovim         Terminals       TUI Apps        Bonus
──────         ─────────       ────────        ─────
◆ 100+ hlgroups   ◆ Ghostty       ◆ tmux          ◆ MapLibre
◆ Treesitter      ◆ Kitty         ◆ lazygit
◆ LSP             ◆ Alacritty     ◆ Yazi
◆ Lualine         ◆ WezTerm       ◆ fzf
◆ 15+ plugins                     ◆ bat
```

## Requirements

- Neovim 0.8+
- `termguicolors` enabled
- True color terminal

## Install

```lua
-- lazy.nvim
{
  "ejfox/vulpes.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme("vulpes")
  end,
}
```

```lua
-- packer
use { "ejfox/vulpes.nvim" }
```

```vim
" vim-plug
Plug 'ejfox/vulpes.nvim'
colorscheme vulpes
```

## Config

```lua
require("vulpes").setup({
  transparent = false,
  italic_comments = true,
  italic_keywords = false,
  bold_functions = false,
  cursor_color = "base",  -- "base" (pink) or "white"
  undercurl = true,
  terminal_colors = true,
})

vim.cmd.colorscheme("vulpes")
```

Or via `vim.g`:

```lua
vim.g.vulpes_transparent = true
vim.cmd.colorscheme("vulpes")
```

| Option | Default | |
|--------|---------|---|
| `transparent` | `false` | transparent bg |
| `italic_comments` | `true` | |
| `italic_keywords` | `false` | |
| `bold_functions` | `false` | |
| `cursor_color` | `"base"` | `"base"` or `"white"` |
| `undercurl` | `true` | spelling errors |
| `terminal_colors` | `true` | ANSI colors in :terminal |

## Lualine

```lua
require("lualine").setup({
  options = { theme = "vulpes" },
})
```

## Extras

All in `extras/`:

### Terminals

| | File | Install |
|-|------|---------|
| Ghostty | `vulpes-ghostty.conf` | `cp extras/vulpes-ghostty.conf ~/.config/ghostty/themes/vulpes` |
| Kitty | `vulpes-kitty.conf` | `include themes/vulpes.conf` in kitty.conf |
| Alacritty | `vulpes-alacritty.toml` | import in alacritty.toml |
| WezTerm | `vulpes-wezterm.lua` | `cp extras/vulpes-wezterm.lua ~/.config/wezterm/colors/` |

### TUIs

| | File | Install |
|-|------|---------|
| tmux | `vulpes.tmux` | `source-file ~/.config/tmux/vulpes.tmux` |
| Yazi | `vulpes-yazi.toml` | `cp extras/vulpes-yazi.toml ~/.config/yazi/theme.toml` |
| lazygit | `vulpes-lazygit.yml` | merge into `~/.config/lazygit/config.yml` |
| fzf | `vulpes-fzf.sh` | source in shell rc |
| bat | `vulpes-bat.tmTheme` | copy to bat themes, `bat cache --build` |

### Bonus

| | File | Notes |
|-|------|-------|
| MapLibre | `vulpes-maplibre.json` | cyberpunk map style, replace `{key}` with Maptiler API key |

## Palette

### Dark

| | | Hex | |
|-|-|-----|---|
| bg | ![](https://img.shields.io/badge/bg-000000?style=flat-square&color=000000) | `#000000` | |
| fg | ![](https://img.shields.io/badge/fg-f2cfdf?style=flat-square&color=f2cfdf) | `#f2cfdf` | |
| base | ![](https://img.shields.io/badge/base-e60067?style=flat-square&color=e60067) | `#e60067` | accent pink |
| comment | ![](https://img.shields.io/badge/comment-6eedf7?style=flat-square&color=6eedf7) | `#6eedf7` | teal |
| keyword | ![](https://img.shields.io/badge/keyword-ff1aca?style=flat-square&color=ff1aca) | `#ff1aca` | |
| string | ![](https://img.shields.io/badge/string-f5f5f5?style=flat-square&color=f5f5f5) | `#f5f5f5` | |
| func | ![](https://img.shields.io/badge/func-ffffff?style=flat-square&color=ffffff) | `#ffffff` | |
| type | ![](https://img.shields.io/badge/type-ff24ab?style=flat-square&color=ff24ab) | `#ff24ab` | |
| number | ![](https://img.shields.io/badge/number-ff33c5?style=flat-square&color=ff33c5) | `#ff33c5` | |
| boolean | ![](https://img.shields.io/badge/boolean-ff1043?style=flat-square&color=ff1043) | `#ff1043` | |
| variable | ![](https://img.shields.io/badge/variable-ff0a89?style=flat-square&color=ff0a89) | `#ff0a89` | |
| property | ![](https://img.shields.io/badge/property-ff0a91?style=flat-square&color=ff0a91) | `#ff0a91` | |
| operator | ![](https://img.shields.io/badge/operator-f92c7a?style=flat-square&color=f92c7a) | `#f92c7a` | |
| error | ![](https://img.shields.io/badge/error-a0f7fc?style=flat-square&color=a0f7fc) | `#a0f7fc` | inverted teal |
| warning | ![](https://img.shields.io/badge/warning-ffaa00?style=flat-square&color=ffaa00) | `#ffaa00` | |

### ANSI

| | Normal | Bright |
|-|--------|--------|
| black | ![](https://img.shields.io/badge/0d0d0d-0d0d0d?style=flat-square&color=0d0d0d) `#0d0d0d` | ![](https://img.shields.io/badge/735865-735865?style=flat-square&color=735865) `#735865` |
| red | ![](https://img.shields.io/badge/ff001e-ff001e?style=flat-square&color=ff001e) `#ff001e` | ![](https://img.shields.io/badge/ff2e2e-ff2e2e?style=flat-square&color=ff2e2e) `#ff2e2e` |
| green | ![](https://img.shields.io/badge/ffffff-ffffff?style=flat-square&color=ffffff) `#ffffff` | ![](https://img.shields.io/badge/ffffff-ffffff?style=flat-square&color=ffffff) `#ffffff` |
| yellow | ![](https://img.shields.io/badge/ffaa00-ffaa00?style=flat-square&color=ffaa00) `#ffaa00` | ![](https://img.shields.io/badge/ffcc00-ffcc00?style=flat-square&color=ffcc00) `#ffcc00` |
| blue | ![](https://img.shields.io/badge/ff0095-ff0095?style=flat-square&color=ff0095) `#ff0095` | ![](https://img.shields.io/badge/ff2daf-ff2daf?style=flat-square&color=ff2daf) `#ff2daf` |
| magenta | ![](https://img.shields.io/badge/ff24ab-ff24ab?style=flat-square&color=ff24ab) `#ff24ab` | ![](https://img.shields.io/badge/ff40c7-ff40c7?style=flat-square&color=ff40c7) `#ff40c7` |
| cyan | ![](https://img.shields.io/badge/6eedf7-6eedf7?style=flat-square&color=6eedf7) `#6eedf7` | ![](https://img.shields.io/badge/a0f7fc-a0f7fc?style=flat-square&color=a0f7fc) `#a0f7fc` |
| white | ![](https://img.shields.io/badge/f2cfdf-f2cfdf?style=flat-square&color=f2cfdf) `#f2cfdf` | ![](https://img.shields.io/badge/ffffff-ffffff?style=flat-square&color=ffffff) `#ffffff` |

## Plugins

Highlight groups for: Telescope, Snacks.nvim, nvim-cmp, GitSigns, Which-key, BufferLine, Neo-tree, Lazy.nvim, Mason, Noice, nvim-notify

## API

```lua
local palette = require("vulpes.palette")
local colors = palette.get()     -- current variant
local dark = palette.dark        -- dark palette
local light = palette.light      -- light palette
```

## License

MIT
