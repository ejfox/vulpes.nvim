-- Vulpes colorscheme for WezTerm
-- https://github.com/ejfox/vulpes.nvim
--
-- Installation:
--   Copy to ~/.config/wezterm/colors/vulpes.lua
--   In wezterm.lua:
--     config.color_scheme = 'vulpes'

return {
  foreground = "#f2cfdf",
  background = "#000000",

  cursor_fg = "#000000",
  cursor_bg = "#e60067",
  cursor_border = "#e60067",

  selection_fg = "#ffffff",
  selection_bg = "#6b1a3d",

  scrollbar_thumb = "#735865",
  split = "#0d0d0d",

  ansi = {
    "#0d0d0d", -- black
    "#ff001e", -- red
    "#ffffff", -- green
    "#ff8c00", -- yellow → Nixie amber
    "#ff0095", -- blue
    "#ff24ab", -- magenta
    "#6eedf7", -- cyan
    "#f2cfdf", -- white
  },

  brights = {
    "#735865", -- bright black
    "#ff2e2e", -- bright red
    "#ffffff", -- bright green
    "#ff8c00", -- bright yellow → Nixie amber
    "#ff2daf", -- bright blue
    "#ff40c7", -- bright magenta
    "#00d4b0", -- bright cyan → VFD cyan
    "#ffffff", -- bright white
  },

  tab_bar = {
    background = "#000000",
    active_tab = {
      bg_color = "#e60067",
      fg_color = "#000000",
    },
    inactive_tab = {
      bg_color = "#0d0d0d",
      fg_color = "#735865",
    },
    inactive_tab_hover = {
      bg_color = "#2a1520",
      fg_color = "#f2cfdf",
    },
    new_tab = {
      bg_color = "#0d0d0d",
      fg_color = "#735865",
    },
    new_tab_hover = {
      bg_color = "#e60067",
      fg_color = "#000000",
    },
  },
}
