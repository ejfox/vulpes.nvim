# vulpes.nvim

Neon pink/teal colorscheme for Neovim + matching configs for terminal emulators and TUI apps.

<img width="1800" height="1131" alt="screenshot 2025-12-24 at 3 28 57 PM" src="https://github.com/user-attachments/assets/77a9fb8e-33d0-4562-83cb-0f8cc11b1499" />

<img width="1800" height="1169" alt="screenshot 2025-12-22 at 11 30 20 PM" src="https://github.com/user-attachments/assets/d8c588f0-c75d-4d2f-bf21-0837ac536ece" />

## Includes

```
Neovim         Terminals       TUI Apps
──────         ─────────       ────────
◆ 100+ hlgroups   ◆ Ghostty       ◆ tmux
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

## Palette

### Dark

| | | Hex | |
|-|-|-----|---|
| bg | <img src="https://img.shields.io/badge/-%20-000000?style=flat-square"/> | `#000000` | |
| fg | <img src="https://img.shields.io/badge/-%20-f2cfdf?style=flat-square"/> | `#f2cfdf` | |
| base | <img src="https://img.shields.io/badge/-%20-e60067?style=flat-square"/> | `#e60067` | accent pink |
| comment | <img src="https://img.shields.io/badge/-%20-6eedf7?style=flat-square"/> | `#6eedf7` | teal |
| keyword | <img src="https://img.shields.io/badge/-%20-ff1aca?style=flat-square"/> | `#ff1aca` | |
| string | <img src="https://img.shields.io/badge/-%20-f5f5f5?style=flat-square"/> | `#f5f5f5` | |
| func | <img src="https://img.shields.io/badge/-%20-ffffff?style=flat-square"/> | `#ffffff` | |
| type | <img src="https://img.shields.io/badge/-%20-ff24ab?style=flat-square"/> | `#ff24ab` | |
| number | <img src="https://img.shields.io/badge/-%20-ff33c5?style=flat-square"/> | `#ff33c5` | |
| boolean | <img src="https://img.shields.io/badge/-%20-ff1043?style=flat-square"/> | `#ff1043` | |
| variable | <img src="https://img.shields.io/badge/-%20-ff0a89?style=flat-square"/> | `#ff0a89` | |
| property | <img src="https://img.shields.io/badge/-%20-ff0a91?style=flat-square"/> | `#ff0a91` | |
| operator | <img src="https://img.shields.io/badge/-%20-f92c7a?style=flat-square"/> | `#f92c7a` | |
| error | <img src="https://img.shields.io/badge/-%20-a0f7fc?style=flat-square"/> | `#a0f7fc` | inverted teal |
| warning | <img src="https://img.shields.io/badge/-%20-ffaa00?style=flat-square"/> | `#ffaa00` | |

### ANSI

| | Normal | | Bright | |
|-|--------|-|--------|-|
| black | <img src="https://img.shields.io/badge/-%20-0d0d0d?style=flat-square"/> | `#0d0d0d` | <img src="https://img.shields.io/badge/-%20-735865?style=flat-square"/> | `#735865` |
| red | <img src="https://img.shields.io/badge/-%20-ff001e?style=flat-square"/> | `#ff001e` | <img src="https://img.shields.io/badge/-%20-ff2e2e?style=flat-square"/> | `#ff2e2e` |
| green | <img src="https://img.shields.io/badge/-%20-ffffff?style=flat-square"/> | `#ffffff` | <img src="https://img.shields.io/badge/-%20-ffffff?style=flat-square"/> | `#ffffff` |
| yellow | <img src="https://img.shields.io/badge/-%20-ffaa00?style=flat-square"/> | `#ffaa00` | <img src="https://img.shields.io/badge/-%20-ffcc00?style=flat-square"/> | `#ffcc00` |
| blue | <img src="https://img.shields.io/badge/-%20-ff0095?style=flat-square"/> | `#ff0095` | <img src="https://img.shields.io/badge/-%20-ff2daf?style=flat-square"/> | `#ff2daf` |
| magenta | <img src="https://img.shields.io/badge/-%20-ff24ab?style=flat-square"/> | `#ff24ab` | <img src="https://img.shields.io/badge/-%20-ff40c7?style=flat-square"/> | `#ff40c7` |
| cyan | <img src="https://img.shields.io/badge/-%20-6eedf7?style=flat-square"/> | `#6eedf7` | <img src="https://img.shields.io/badge/-%20-a0f7fc?style=flat-square"/> | `#a0f7fc` |
| white | <img src="https://img.shields.io/badge/-%20-f2cfdf?style=flat-square"/> | `#f2cfdf` | <img src="https://img.shields.io/badge/-%20-ffffff?style=flat-square"/> | `#ffffff` |

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
