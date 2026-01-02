-- Vulpes Configuration
-- User-configurable options via vim.g.vulpes_*

local M = {}

-- Default configuration
M.defaults = {
  -- Use transparent background
  transparent = false,

  -- Enable italic comments
  italic_comments = true,

  -- Enable italic keywords (if, for, while, etc.)
  italic_keywords = false,

  -- Enable bold functions
  bold_functions = false,

  -- Cursor color: "base" (pink) or "white"
  cursor_color = "base",

  -- Underline matching text during search
  underline_search = false,

  -- Use undercurl for spelling errors (requires terminal support)
  undercurl = true,

  -- Float window style: "normal" or "bordered"
  float_style = "bordered",

  -- Terminal colors: apply vulpes ANSI colors to :terminal
  terminal_colors = true,

  -- Plugin integrations to load (set false to disable)
  plugins = {
    telescope = true,
    snacks = true,
    cmp = true,
    gitsigns = true,
    lsp = true,
    treesitter = true,
    which_key = true,
    bufferline = true,
    dashboard = true,
    lazy = true,
    mason = true,
    noice = true,
    notify = true,
    neo_tree = true,
  },
}

-- Get configuration value
function M.get(key)
  local user_config = vim.g["vulpes_" .. key]
  if user_config ~= nil then
    return user_config
  end
  return M.defaults[key]
end

-- Get all configuration
function M.all()
  local config = vim.deepcopy(M.defaults)
  for key, _ in pairs(config) do
    local user_val = vim.g["vulpes_" .. key]
    if user_val ~= nil then
      config[key] = user_val
    end
  end
  return config
end

-- Check if a plugin integration is enabled
function M.plugin_enabled(name)
  local user_plugins = vim.g.vulpes_plugins
  if user_plugins and user_plugins[name] ~= nil then
    return user_plugins[name]
  end
  return M.defaults.plugins[name]
end

return M
