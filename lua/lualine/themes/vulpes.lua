-- Lualine theme for Vulpes
-- https://github.com/ejfox/vulpes.nvim

local palette = require("vulpes.palette")

local function get_theme()
  local c = palette.get()

  return {
    normal = {
      a = { fg = c.bg, bg = c.base, gui = "bold" },
      b = { fg = c.fg, bg = c.bg_alt },
      c = { fg = c.fg_dim, bg = "NONE" },
    },
    insert = {
      a = { fg = c.bg, bg = c.success, gui = "bold" },
      b = { fg = c.fg, bg = c.bg_alt },
      c = { fg = c.fg_dim, bg = "NONE" },
    },
    visual = {
      a = { fg = c.bg, bg = c.warning, gui = "bold" },
      b = { fg = c.fg, bg = c.bg_alt },
      c = { fg = c.fg_dim, bg = "NONE" },
    },
    replace = {
      a = { fg = c.bg, bg = c.error, gui = "bold" },
      b = { fg = c.fg, bg = c.bg_alt },
      c = { fg = c.fg_dim, bg = "NONE" },
    },
    command = {
      a = { fg = c.bg, bg = c.info, gui = "bold" },
      b = { fg = c.fg, bg = c.bg_alt },
      c = { fg = c.fg_dim, bg = "NONE" },
    },
    inactive = {
      a = { fg = c.fg_dim, bg = c.bg_alt },
      b = { fg = c.fg_dim, bg = "NONE" },
      c = { fg = c.fg_dark, bg = "NONE" },
    },
  }
end

return get_theme()
