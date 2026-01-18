-- Vulpes Color Palette
-- A cyberpunk neon theme with monthly color variants
-- https://github.com/ejfox/vulpes.nvim

local M = {}

-- The core vulpes palette (reddishnovember - the OG)
M.dark = {
  -- Backgrounds
  bg = "#000000",
  bg_alt = "#0d0d0d",
  bg_float = "#0d0d0d",
  bg_popup = "#121212",
  bg_visual = "#6b1a3d",
  bg_search = "#5c0030",
  bg_cursorline = "#2a1520",

  -- Foregrounds
  fg = "#f2cfdf",
  fg_dim = "#c490a8",
  fg_dark = "#735865",

  -- Core accent (the signature vulpes pink)
  base = "#e60067",
  base_bright = "#ff277d",

  -- Semantic colors
  error = "#a0f7fc", -- Bright teal (inverted for pop)
  warning = "#ffaa00",
  success = "#ffffff",
  info = "#ff0095",
  hint = "#ff4d9d",

  -- Syntax colors
  comment = "#6eedf7", -- Teal comments (signature vulpes look)
  keyword = "#ff1aca",
  string = "#f5f5f5",
  number = "#ff33c5",
  boolean = "#ff1043",
  func = "#ffffff",
  constant = "#ff1043",
  type = "#ff24ab",
  variable = "#ff0a89",
  operator = "#f92c7a",
  builtin = "#f82956",
  parameter = "#ff057e",
  property = "#ff0a91",
  namespace = "#f8326e",
  macro = "#f92a9c",
  tag = "#f82e64",
  punctuation = "#f82470",
  heading = "#ff2453",

  -- UI elements
  selection = "#6b1a3d",
  selection_fg = "#ffffff",
  cursor = "#e60067",
  linenr = "#735865",
  border = "#e60067",

  -- Git/Diff (HCL-harmonized with vulpes base hue ~340°)
  git_add = "#b4d455",      -- Warm chartreuse (Hue ~85°)
  git_change = "#ffaa00",
  git_delete = "#c44569",   -- Dusty rose-burgundy (Hue ~350°)
  diff_text = "#e8b4c8",    -- Soft pink for changed text

  -- Terminal colors (ANSI)
  black = "#0d0d0d",
  red = "#ff001e",
  green = "#ffffff",
  yellow = "#ffaa00",
  blue = "#ff0095",
  magenta = "#ff24ab",
  cyan = "#6eedf7",
  white = "#f2cfdf",
  bright_black = "#735865",
  bright_red = "#ff2e2e",
  bright_green = "#ffffff",
  bright_yellow = "#ffcc00",
  bright_blue = "#ff2daf",
  bright_magenta = "#ff40c7",
  bright_cyan = "#a0f7fc",
  bright_white = "#ffffff",
}

-- Light variant
M.light = {
  -- Backgrounds
  bg = "#fefefe",
  bg_alt = "#f5f0f2",
  bg_float = "#f5f0f2",
  bg_popup = "#ebe5e8",
  bg_visual = "#ffd6e8",
  bg_search = "#ffe0ed",
  bg_cursorline = "#fff0f5",

  -- Foregrounds
  fg = "#1a0a10",
  fg_dim = "#4a3040",
  fg_dark = "#6b5060",

  -- Core accent
  base = "#c50058",
  base_bright = "#e60067",

  -- Semantic colors
  error = "#008b8f",
  warning = "#b87700",
  success = "#006600",
  info = "#c50058",
  hint = "#d84d8a",

  -- Syntax colors
  comment = "#008b8f",
  keyword = "#c50058",
  string = "#1a0a10",
  number = "#b8007a",
  boolean = "#c50040",
  func = "#1a0a10",
  constant = "#c50040",
  type = "#a80070",
  variable = "#c50070",
  operator = "#d02060",
  builtin = "#c52050",
  parameter = "#c50065",
  property = "#c50075",
  namespace = "#c52058",
  macro = "#c52080",
  tag = "#c52050",
  punctuation = "#c52060",
  heading = "#c52045",

  -- UI elements
  selection = "#ffd6e8",
  selection_fg = "#1a0a10",
  cursor = "#c50058",
  linenr = "#a08090",
  border = "#c50058",

  -- Git/Diff (HCL-harmonized with vulpes base hue ~340°, for light bg)
  git_add = "#5a7a20",      -- Dark chartreuse (Hue ~85°)
  git_change = "#b87700",
  git_delete = "#9e3050",   -- Dark dusty rose (Hue ~350°)
  diff_text = "#8a4060",    -- Muted rose for changed text

  -- Terminal colors (ANSI)
  black = "#1a0a10",
  red = "#cc0000",
  green = "#006600",
  yellow = "#b87700",
  blue = "#c50058",
  magenta = "#a80070",
  cyan = "#008b8f",
  white = "#f5f0f2",
  bright_black = "#6b5060",
  bright_red = "#e50000",
  bright_green = "#008800",
  bright_yellow = "#d99000",
  bright_blue = "#e60067",
  bright_magenta = "#c5008a",
  bright_cyan = "#00a0a5",
  bright_white = "#fefefe",
}

-- Get palette based on background
function M.get(variant)
  variant = variant or (vim.o.background == "light" and "light" or "dark")
  return M[variant] or M.dark
end

return M
