# vulpes.nvim

A cyberpunk neon colorscheme for Neovim, inspired by the glow of city lights and the cunning of foxes.

![vulpes.nvim](https://user-images.placeholder/vulpes-screenshot.png)

## Features

- **True color support** - Designed for modern terminals with 24-bit color
- **Dark & Light variants** - Full theme for both backgrounds
- **100+ highlight groups** - Comprehensive coverage for syntax, LSP, and plugins
- **Treesitter support** - Rich semantic highlighting
- **Terminal extras** - Matching configs for Ghostty, Kitty, Alacritty, WezTerm, tmux, and more
- **Plugin integrations** - Telescope, Snacks.nvim, nvim-cmp, GitSigns, Lualine, and many more
- **Highly configurable** - Customize transparency, italics, cursor color, and more

## Requirements

- Neovim 0.8+ (0.9+ recommended for full Treesitter support)
- `termguicolors` enabled
- A terminal with true color support

## Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "ejfox/vulpes.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme("vulpes")
  end,
}
```

### [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  "ejfox/vulpes.nvim",
  config = function()
    vim.cmd.colorscheme("vulpes")
  end
}
```

### [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'ejfox/vulpes.nvim'

" After plug#end()
colorscheme vulpes
```

## Usage

```lua
-- Dark theme (default)
vim.cmd.colorscheme("vulpes")

-- Light theme
vim.cmd.colorscheme("vulpes-light")
```

## Configuration

Configure before loading the colorscheme:

```lua
-- Using setup function (recommended)
require("vulpes").setup({
  transparent = false,        -- Use transparent background
  italic_comments = true,     -- Italicize comments
  italic_keywords = false,    -- Italicize keywords (if, for, while)
  bold_functions = false,     -- Bold function names
  cursor_color = "base",      -- "base" (pink) or "white"
  undercurl = true,           -- Use undercurl for spelling (requires terminal support)
  terminal_colors = true,     -- Apply vulpes colors to :terminal
})

vim.cmd.colorscheme("vulpes")
```

Or using vim.g variables:

```lua
vim.g.vulpes_transparent = true
vim.g.vulpes_italic_comments = false
vim.cmd.colorscheme("vulpes")
```

### Configuration Options

| Option | Default | Description |
|--------|---------|-------------|
| `transparent` | `false` | Use transparent background |
| `italic_comments` | `true` | Italicize comments |
| `italic_keywords` | `false` | Italicize keywords |
| `bold_functions` | `false` | Bold function names |
| `cursor_color` | `"base"` | Cursor color: `"base"` (pink) or `"white"` |
| `underline_search` | `false` | Underline search matches |
| `undercurl` | `true` | Use undercurl for spelling errors |
| `terminal_colors` | `true` | Set terminal ANSI colors |

## Lualine

Vulpes includes a matching Lualine theme:

```lua
require("lualine").setup({
  options = {
    theme = "vulpes",
  },
})
```

## Terminal Extras

Matching colorschemes for your terminal and tools are in the `extras/` directory:

| App | File | Installation |
|-----|------|--------------|
| Ghostty | `vulpes-ghostty.conf` | Copy to `~/.config/ghostty/themes/` |
| Kitty | `vulpes-kitty.conf` | Include in `kitty.conf` |
| Alacritty | `vulpes-alacritty.toml` | Import in `alacritty.toml` |
| WezTerm | `vulpes-wezterm.lua` | Place in `~/.config/wezterm/colors/` |
| tmux | `vulpes.tmux` | Source in `tmux.conf` |
| fzf | `vulpes-fzf.sh` | Source in shell rc |
| lazygit | `vulpes-lazygit.yml` | Copy theme to `config.yml` |
| bat | `vulpes-bat.tmTheme` | Add to bat themes, run `bat cache --build` |
| Yazi | `vulpes-yazi.toml` | Copy to `~/.config/yazi/theme.toml` |

## Color Palette

### Dark Theme

| Color | Hex | Usage |
|-------|-----|-------|
| Background | `#000000` | Editor background |
| Foreground | `#f2cfdf` | Default text |
| Base/Accent | `#e60067` | Primary accent (the vulpes pink) |
| Comment | `#6eedf7` | Comments (teal - signature look) |
| Keyword | `#ff1aca` | Language keywords |
| String | `#f5f5f5` | String literals |
| Function | `#ffffff` | Function names |
| Type | `#ff24ab` | Type names |
| Error | `#a0f7fc` | Errors (inverted teal for visibility) |
| Warning | `#ffaa00` | Warnings |

## Plugin Support

Vulpes includes highlight groups for:

- **LSP** - Diagnostics, semantic tokens, document highlights
- **Treesitter** - Full semantic highlighting
- **Telescope.nvim** - Fuzzy finder
- **Snacks.nvim** - Picker, indent guides, explorer
- **nvim-cmp** - Completion menu
- **GitSigns** - Git gutter signs
- **Which-key** - Keybinding hints
- **BufferLine** - Tab/buffer line
- **Neo-tree** - File explorer
- **Lazy.nvim** - Plugin manager UI
- **Mason** - LSP installer UI
- **Noice** - UI enhancements
- **nvim-notify** - Notifications

## Accessing the Palette

You can access vulpes colors in your own config:

```lua
local palette = require("vulpes.palette")

-- Get current variant's colors
local colors = palette.get()
print(colors.base)  -- "#e60067"

-- Get specific variant
local dark = palette.dark
local light = palette.light
```

## Philosophy

Vulpes is designed around a few core principles:

1. **Readability first** - High contrast where it matters, subtle elsewhere
2. **Semantic color** - Colors convey meaning, not just decoration
3. **Terminal-native** - Born in the terminal, designed for the glow
4. **Minimal distraction** - The code is the star, the theme is the stage

## Credits

Vulpes is part of the [vulpes-theme-lab](https://github.com/ejfox/vulpes-theme-lab) ecosystem.

## License

MIT License - see [LICENSE](LICENSE) for details.
