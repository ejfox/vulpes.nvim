-- Vulpes - A cyberpunk neon colorscheme for Neovim
-- https://github.com/ejfox/vulpes.nvim
--
-- "The fox knows many things, but the hedgehog knows one big thing."
-- This theme knows one thing: how to make your code glow.

local M = {}

local palette = require("vulpes.palette")
local config = require("vulpes.config")

-- Apply highlight group
local function hi(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- Set terminal colors
local function set_terminal_colors(c)
  vim.g.terminal_color_0 = c.black
  vim.g.terminal_color_1 = c.red
  vim.g.terminal_color_2 = c.green
  vim.g.terminal_color_3 = c.yellow
  vim.g.terminal_color_4 = c.blue
  vim.g.terminal_color_5 = c.magenta
  vim.g.terminal_color_6 = c.cyan
  vim.g.terminal_color_7 = c.white
  vim.g.terminal_color_8 = c.bright_black
  vim.g.terminal_color_9 = c.bright_red
  vim.g.terminal_color_10 = c.bright_green
  vim.g.terminal_color_11 = c.bright_yellow
  vim.g.terminal_color_12 = c.bright_blue
  vim.g.terminal_color_13 = c.bright_magenta
  vim.g.terminal_color_14 = c.bright_cyan
  vim.g.terminal_color_15 = c.bright_white
end

-- Core editor highlights
local function set_editor_highlights(c, cfg)
  local bg = cfg.transparent and "NONE" or c.bg
  local bg_alt = cfg.transparent and "NONE" or c.bg_alt

  -- Editor UI
  hi("Normal", { fg = c.fg, bg = bg })
  hi("NormalFloat", { fg = c.fg, bg = c.bg_float })
  hi("NormalNC", { fg = c.fg, bg = bg })
  hi("FloatBorder", { fg = c.border, bg = c.bg_float })
  hi("FloatTitle", { fg = c.base, bg = c.bg_float, bold = true })

  -- Cursor
  local cursor_bg = cfg.cursor_color == "white" and c.fg or c.cursor
  hi("Cursor", { fg = c.bg, bg = cursor_bg })
  hi("lCursor", { link = "Cursor" })
  hi("CursorIM", { link = "Cursor" })
  hi("TermCursor", { link = "Cursor" })
  hi("TermCursorNC", { fg = c.bg, bg = c.comment })

  -- Cursor line/column
  hi("CursorLine", { bg = c.bg_cursorline })
  hi("CursorColumn", { bg = c.bg_cursorline })
  hi("CursorLineNr", { fg = c.base, bold = true })
  hi("LineNr", { fg = c.linenr })
  hi("LineNrAbove", { fg = c.linenr })
  hi("LineNrBelow", { fg = c.linenr })

  -- Sign column
  hi("SignColumn", { bg = bg })
  hi("SignColumnSB", { link = "SignColumn" })
  hi("FoldColumn", { fg = c.comment, bg = bg })
  hi("Folded", { fg = c.comment, bg = bg_alt })
  hi("ColorColumn", { bg = bg_alt })

  -- Search & Selection
  local search_style = cfg.underline_search and { underline = true } or {}
  hi("Visual", { fg = c.selection_fg, bg = c.selection, bold = true })
  hi("VisualNOS", { fg = c.selection_fg, bg = c.selection })
  hi("Search", vim.tbl_extend("force", { fg = c.bg, bg = c.warning }, search_style))
  hi("IncSearch", { fg = c.selection_fg, bg = c.bg_search, bold = true })
  hi("CurSearch", { fg = c.selection_fg, bg = c.bg_search, bold = true })
  hi("Substitute", { fg = c.bg, bg = c.error })

  -- Popup menu
  hi("Pmenu", { fg = c.fg, bg = c.bg_popup })
  hi("PmenuSel", { fg = c.selection_fg, bg = c.bg_search, bold = true })
  hi("PmenuSbar", { bg = c.bg_popup })
  hi("PmenuThumb", { bg = c.base })
  hi("PmenuKind", { fg = c.type, bg = c.bg_popup })
  hi("PmenuKindSel", { fg = c.bg, bg = c.type })
  hi("PmenuExtra", { fg = c.comment, bg = c.bg_popup })
  hi("PmenuExtraSel", { fg = c.bg, bg = c.comment })

  -- Status line
  hi("StatusLine", { fg = c.fg, bg = bg_alt })
  hi("StatusLineNC", { fg = c.comment, bg = bg })
  hi("WinBar", { fg = c.fg, bg = bg })
  hi("WinBarNC", { fg = c.comment, bg = bg })

  -- Tab line
  hi("TabLine", { fg = c.linenr, bg = bg })
  hi("TabLineFill", { bg = bg })
  hi("TabLineSel", { fg = c.base, bg = bg_alt, bold = true })

  -- Window separators
  hi("VertSplit", { fg = c.bg_alt })
  hi("WinSeparator", { fg = c.bg_alt })

  -- Messages
  hi("Title", { fg = c.base, bold = true })
  hi("Directory", { fg = c.fg_dim })
  hi("Question", { fg = c.success })
  hi("MoreMsg", { fg = c.success })
  hi("ModeMsg", { fg = c.base })
  hi("WarningMsg", { fg = c.warning })
  hi("ErrorMsg", { fg = c.error })

  -- Misc UI
  hi("Conceal", { fg = c.comment })
  hi("NonText", { fg = c.fg_dark })
  hi("SpecialKey", { fg = c.fg_dark })
  hi("Whitespace", { fg = c.fg_dark })
  hi("EndOfBuffer", { fg = bg })
  hi("MatchParen", { fg = c.warning, bold = true })

  -- Spelling
  local spell_style = cfg.undercurl and "undercurl" or "underline"
  hi("SpellBad", { sp = c.error, [spell_style] = true })
  hi("SpellCap", { sp = c.warning, [spell_style] = true })
  hi("SpellLocal", { sp = c.info, [spell_style] = true })
  hi("SpellRare", { sp = c.hint, [spell_style] = true })
end

-- Syntax highlighting
local function set_syntax_highlights(c, cfg)
  local italic = cfg.italic_comments
  local kw_italic = cfg.italic_keywords
  local fn_bold = cfg.bold_functions

  -- Comments
  hi("Comment", { fg = c.comment, italic = italic })
  hi("SpecialComment", { fg = c.comment, italic = italic })

  -- Constants
  hi("Constant", { fg = c.constant })
  hi("String", { fg = c.string })
  hi("Character", { fg = c.string })
  hi("Number", { fg = c.number })
  hi("Boolean", { fg = c.boolean })
  hi("Float", { fg = c.number })

  -- Identifiers
  hi("Identifier", { fg = c.variable })
  hi("Function", { fg = c.func, bold = fn_bold })

  -- Statements
  hi("Statement", { fg = c.keyword, italic = kw_italic })
  hi("Conditional", { fg = c.keyword, italic = kw_italic })
  hi("Repeat", { fg = c.keyword, italic = kw_italic })
  hi("Label", { fg = c.keyword })
  hi("Operator", { fg = c.operator })
  hi("Keyword", { fg = c.keyword, italic = kw_italic })
  hi("Exception", { fg = c.error })

  -- Preprocessor
  hi("PreProc", { fg = c.base })
  hi("Include", { fg = c.keyword, italic = kw_italic })
  hi("Define", { fg = c.keyword })
  hi("Macro", { fg = c.macro })
  hi("PreCondit", { fg = c.keyword })

  -- Types
  hi("Type", { fg = c.type })
  hi("StorageClass", { fg = c.keyword, italic = kw_italic })
  hi("Structure", { fg = c.type })
  hi("Typedef", { fg = c.type })

  -- Special
  hi("Special", { fg = c.base })
  hi("SpecialChar", { fg = c.base })
  hi("Tag", { fg = c.tag })
  hi("Delimiter", { fg = c.punctuation })
  hi("Debug", { fg = c.warning })

  -- Text styles
  hi("Underlined", { underline = true })
  hi("Bold", { bold = true })
  hi("Italic", { italic = true })

  -- Misc
  hi("Ignore", { fg = c.comment })
  hi("Error", { fg = c.error })
  hi("Todo", { fg = c.bg, bg = c.warning, bold = true })
end

-- Diagnostics
local function set_diagnostic_highlights(c)
  -- Base diagnostics
  hi("DiagnosticError", { fg = c.error })
  hi("DiagnosticWarn", { fg = c.warning })
  hi("DiagnosticInfo", { fg = c.info })
  hi("DiagnosticHint", { fg = c.hint })
  hi("DiagnosticOk", { fg = c.success })

  -- Virtual text
  hi("DiagnosticVirtualTextError", { fg = c.error, bg = "NONE" })
  hi("DiagnosticVirtualTextWarn", { fg = c.warning, bg = "NONE" })
  hi("DiagnosticVirtualTextInfo", { fg = c.info, bg = "NONE" })
  hi("DiagnosticVirtualTextHint", { fg = c.hint, bg = "NONE" })

  -- Underlines
  hi("DiagnosticUnderlineError", { sp = c.error, undercurl = true })
  hi("DiagnosticUnderlineWarn", { sp = c.warning, underline = true })
  hi("DiagnosticUnderlineInfo", { sp = c.info, underline = true })
  hi("DiagnosticUnderlineHint", { sp = c.hint, underline = true })

  -- Floating windows
  hi("DiagnosticFloatingError", { fg = c.error, bg = c.bg_float })
  hi("DiagnosticFloatingWarn", { fg = c.warning, bg = c.bg_float })
  hi("DiagnosticFloatingInfo", { fg = c.info, bg = c.bg_float })
  hi("DiagnosticFloatingHint", { fg = c.hint, bg = c.bg_float })

  -- Sign column
  hi("DiagnosticSignError", { fg = c.error, bg = "NONE" })
  hi("DiagnosticSignWarn", { fg = c.warning, bg = "NONE" })
  hi("DiagnosticSignInfo", { fg = c.info, bg = "NONE" })
  hi("DiagnosticSignHint", { fg = c.hint, bg = "NONE" })
end

-- LSP semantic tokens
local function set_lsp_highlights(c)
  hi("@lsp.type.class", { link = "Type" })
  hi("@lsp.type.decorator", { link = "Function" })
  hi("@lsp.type.enum", { link = "Type" })
  hi("@lsp.type.enumMember", { link = "Constant" })
  hi("@lsp.type.function", { link = "Function" })
  hi("@lsp.type.interface", { link = "Type" })
  hi("@lsp.type.macro", { link = "Macro" })
  hi("@lsp.type.method", { link = "Function" })
  hi("@lsp.type.namespace", { fg = c.namespace })
  hi("@lsp.type.parameter", { fg = c.parameter })
  hi("@lsp.type.property", { fg = c.property })
  hi("@lsp.type.struct", { link = "Type" })
  hi("@lsp.type.type", { link = "Type" })
  hi("@lsp.type.typeParameter", { link = "Type" })
  hi("@lsp.type.variable", { link = "@variable" })
end

-- Treesitter highlights
local function set_treesitter_highlights(c, cfg)
  local italic = cfg.italic_comments
  local kw_italic = cfg.italic_keywords

  -- Comments
  hi("@comment", { link = "Comment" })
  hi("@comment.documentation", { fg = c.comment, italic = italic })
  hi("@comment.error", { fg = c.error })
  hi("@comment.warning", { fg = c.warning })
  hi("@comment.todo", { fg = c.bg, bg = c.warning })
  hi("@comment.note", { fg = c.info })

  -- Constants
  hi("@constant", { link = "Constant" })
  hi("@constant.builtin", { fg = c.constant })
  hi("@constant.macro", { link = "Macro" })

  -- Strings
  hi("@string", { link = "String" })
  hi("@string.documentation", { fg = c.string })
  hi("@string.regex", { fg = c.warning })
  hi("@string.escape", { fg = c.base })
  hi("@string.special", { fg = c.base })
  hi("@string.special.symbol", { fg = c.constant })
  hi("@string.special.url", { fg = c.info, underline = true })

  -- Characters & Numbers
  hi("@character", { link = "Character" })
  hi("@character.special", { link = "SpecialChar" })
  hi("@number", { link = "Number" })
  hi("@number.float", { link = "Float" })
  hi("@boolean", { link = "Boolean" })

  -- Functions
  hi("@function", { link = "Function" })
  hi("@function.builtin", { fg = c.builtin })
  hi("@function.call", { fg = c.func })
  hi("@function.macro", { link = "Macro" })
  hi("@function.method", { fg = c.func })
  hi("@function.method.call", { fg = c.func })
  hi("@constructor", { fg = c.type })

  -- Keywords
  hi("@keyword", { fg = c.keyword, italic = kw_italic })
  hi("@keyword.conditional", { fg = c.keyword, italic = kw_italic })
  hi("@keyword.repeat", { fg = c.keyword, italic = kw_italic })
  hi("@keyword.return", { fg = c.keyword, italic = kw_italic })
  hi("@keyword.function", { fg = c.keyword, italic = kw_italic })
  hi("@keyword.operator", { fg = c.operator })
  hi("@keyword.import", { fg = c.keyword, italic = kw_italic })
  hi("@keyword.exception", { fg = c.error })
  hi("@keyword.directive", { link = "PreProc" })
  hi("@keyword.directive.define", { link = "Define" })

  -- Operators & Variables
  hi("@operator", { link = "Operator" })
  hi("@variable", { fg = c.variable })
  hi("@variable.builtin", { fg = c.builtin })
  hi("@variable.parameter", { fg = c.parameter })
  hi("@variable.parameter.builtin", { fg = c.builtin })
  hi("@variable.member", { fg = c.property })

  -- Types
  hi("@type", { link = "Type" })
  hi("@type.builtin", { fg = c.builtin })
  hi("@type.definition", { link = "Typedef" })
  hi("@type.qualifier", { fg = c.keyword, italic = kw_italic })

  -- Attributes & Properties
  hi("@attribute", { fg = c.base })
  hi("@attribute.builtin", { fg = c.builtin })
  hi("@property", { fg = c.property })
  hi("@field", { fg = c.property })

  -- Modules & Namespaces
  hi("@module", { fg = c.namespace })
  hi("@module.builtin", { fg = c.builtin })
  hi("@label", { link = "Label" })

  -- Punctuation
  hi("@punctuation.delimiter", { fg = c.punctuation })
  hi("@punctuation.bracket", { fg = c.punctuation })
  hi("@punctuation.special", { fg = c.punctuation })

  -- Tags (HTML/XML/JSX)
  hi("@tag", { fg = c.tag })
  hi("@tag.builtin", { fg = c.builtin })
  hi("@tag.attribute", { fg = c.property })
  hi("@tag.delimiter", { fg = c.punctuation })

  -- Markup
  hi("@markup.strong", { bold = true })
  hi("@markup.italic", { italic = true })
  hi("@markup.strikethrough", { strikethrough = true })
  hi("@markup.underline", { underline = true })
  hi("@markup.heading", { fg = c.heading, bold = true })
  hi("@markup.heading.1", { fg = c.heading, bold = true })
  hi("@markup.heading.2", { fg = c.heading, bold = true })
  hi("@markup.heading.3", { fg = c.heading, bold = true })
  hi("@markup.heading.4", { fg = c.heading })
  hi("@markup.heading.5", { fg = c.heading })
  hi("@markup.heading.6", { fg = c.heading })
  hi("@markup.quote", { fg = c.comment, italic = true })
  hi("@markup.math", { fg = c.number })
  hi("@markup.link", { fg = c.info, underline = true })
  hi("@markup.link.label", { fg = c.string })
  hi("@markup.link.url", { fg = c.info, underline = true })
  hi("@markup.raw", { fg = c.string })
  hi("@markup.raw.block", { fg = c.string })
  hi("@markup.list", { fg = c.base })
  hi("@markup.list.checked", { fg = c.success })
  hi("@markup.list.unchecked", { fg = c.comment })

  -- Diff
  hi("@diff.plus", { fg = c.git_add })
  hi("@diff.minus", { fg = c.git_delete })
  hi("@diff.delta", { fg = c.git_change })
end

-- Git integration
local function set_git_highlights(c)
  hi("DiffAdd", { fg = c.git_add })
  hi("DiffChange", { fg = c.git_change })
  hi("DiffDelete", { fg = c.git_delete })
  hi("DiffText", { fg = c.info, bg = c.bg_alt })

  -- GitSigns
  hi("GitSignsAdd", { fg = c.git_add })
  hi("GitSignsChange", { fg = c.git_change })
  hi("GitSignsDelete", { fg = c.git_delete })
  hi("GitSignsAddNr", { fg = c.git_add })
  hi("GitSignsChangeNr", { fg = c.git_change })
  hi("GitSignsDeleteNr", { fg = c.git_delete })
  hi("GitSignsAddLn", { bg = c.git_add, fg = c.bg })
  hi("GitSignsChangeLn", { bg = c.git_change, fg = c.bg })
  hi("GitSignsDeleteLn", { bg = c.git_delete, fg = c.bg })
  hi("GitSignsCurrentLineBlame", { fg = c.comment })
end

-- Plugin highlights
local function set_plugin_highlights(c, cfg)
  -- Telescope
  if config.plugin_enabled("telescope") then
    hi("TelescopeBorder", { fg = c.border, bg = c.bg_float })
    hi("TelescopeNormal", { fg = c.fg, bg = c.bg_float })
    hi("TelescopePromptNormal", { fg = c.fg, bg = c.bg_float })
    hi("TelescopeResultsNormal", { fg = c.fg, bg = c.bg_float })
    hi("TelescopePreviewNormal", { fg = c.fg, bg = c.bg_float })
    hi("TelescopeSelection", { fg = c.bg, bg = c.base })
    hi("TelescopeSelectionCaret", { fg = c.base })
    hi("TelescopeMatching", { fg = c.warning })
    hi("TelescopePromptPrefix", { fg = c.base })
  end

  -- Snacks.nvim
  if config.plugin_enabled("snacks") then
    hi("SnacksPickerDir", { fg = c.fg_dim })
    hi("SnacksPickerPathHidden", { fg = c.linenr })
    hi("SnacksPickerPathIgnored", { fg = c.linenr })
    hi("SnacksPickerMatch", { fg = c.warning })
    hi("SnacksPickerPrompt", { fg = c.base })
    hi("SnacksIndent", { fg = c.linenr })
    hi("SnacksIndentScope", { fg = c.linenr })
  end

  -- nvim-cmp
  if config.plugin_enabled("cmp") then
    hi("CmpItemAbbrDeprecated", { fg = c.comment, strikethrough = true })
    hi("CmpItemAbbrMatch", { fg = c.base })
    hi("CmpItemAbbrMatchFuzzy", { fg = c.base })
    hi("CmpItemKindVariable", { fg = c.variable })
    hi("CmpItemKindInterface", { fg = c.type })
    hi("CmpItemKindText", { fg = c.fg })
    hi("CmpItemKindFunction", { fg = c.func })
    hi("CmpItemKindMethod", { fg = c.func })
    hi("CmpItemKindKeyword", { fg = c.keyword })
    hi("CmpItemKindProperty", { fg = c.variable })
    hi("CmpItemKindUnit", { fg = c.number })
    hi("CmpItemKindClass", { fg = c.type })
    hi("CmpItemKindModule", { fg = c.type })
    hi("CmpItemKindConstant", { fg = c.constant })
    hi("CmpItemKindEnum", { fg = c.type })
    hi("CmpItemKindStruct", { fg = c.type })
    hi("CmpItemKindEvent", { fg = c.base })
    hi("CmpItemKindOperator", { fg = c.operator })
    hi("CmpItemKindTypeParameter", { fg = c.type })
  end

  -- Which-key
  if config.plugin_enabled("which_key") then
    hi("WhichKey", { fg = c.base })
    hi("WhichKeyGroup", { fg = c.keyword })
    hi("WhichKeyDesc", { fg = c.fg })
    hi("WhichKeySeparator", { fg = c.comment })
    hi("WhichKeyFloat", { bg = c.bg_float })
    hi("WhichKeyValue", { fg = c.string })
  end

  -- BufferLine
  if config.plugin_enabled("bufferline") then
    hi("BufferLineBufferSelected", { fg = c.base, bg = c.bg_alt, bold = true })
    hi("BufferLineIndicatorSelected", { fg = c.base })
    hi("BufferLineBuffer", { fg = c.linenr, bg = "NONE" })
    hi("BufferLineBackground", { fg = c.linenr, bg = "NONE" })
    hi("BufferLineFill", { bg = "NONE" })
    hi("BufferLineTab", { fg = c.linenr, bg = "NONE" })
    hi("BufferLineTabSelected", { fg = c.base, bg = c.bg_alt, bold = true })
    hi("BufferLineModified", { fg = c.base })
    hi("BufferLineModifiedSelected", { fg = c.base, bold = true })
    hi("BufferLineSeparator", { fg = c.bg, bg = "NONE" })
    hi("BufferLineSeparatorSelected", { fg = c.bg, bg = "NONE" })
  end

  -- Dashboard
  if config.plugin_enabled("dashboard") then
    hi("DashboardHeader", { fg = c.base })
    hi("DashboardCenter", { fg = c.keyword })
    hi("DashboardShortcut", { fg = c.warning })
    hi("DashboardFooter", { fg = c.comment })
  end

  -- Lazy.nvim
  if config.plugin_enabled("lazy") then
    hi("LazyH1", { fg = c.base, bold = true })
    hi("LazyButton", { fg = c.fg, bg = c.bg_alt })
    hi("LazyButtonActive", { fg = c.bg, bg = c.base })
    hi("LazySpecial", { fg = c.info })
  end

  -- Mason
  if config.plugin_enabled("mason") then
    hi("MasonHeader", { fg = c.bg, bg = c.base, bold = true })
    hi("MasonHighlight", { fg = c.base })
    hi("MasonHighlightBlock", { fg = c.bg, bg = c.base })
    hi("MasonHighlightBlockBold", { fg = c.bg, bg = c.base, bold = true })
  end

  -- Noice
  if config.plugin_enabled("noice") then
    hi("NoiceCmdlinePopupBorder", { fg = c.border })
    hi("NoiceCmdlineIcon", { fg = c.base })
  end

  -- Notify
  if config.plugin_enabled("notify") then
    hi("NotifyERRORBorder", { fg = c.error })
    hi("NotifyWARNBorder", { fg = c.warning })
    hi("NotifyINFOBorder", { fg = c.info })
    hi("NotifyDEBUGBorder", { fg = c.comment })
    hi("NotifyTRACEBorder", { fg = c.hint })
    hi("NotifyERRORIcon", { fg = c.error })
    hi("NotifyWARNIcon", { fg = c.warning })
    hi("NotifyINFOIcon", { fg = c.info })
    hi("NotifyDEBUGIcon", { fg = c.comment })
    hi("NotifyTRACEIcon", { fg = c.hint })
    hi("NotifyERRORTitle", { fg = c.error })
    hi("NotifyWARNTitle", { fg = c.warning })
    hi("NotifyINFOTitle", { fg = c.info })
    hi("NotifyDEBUGTitle", { fg = c.comment })
    hi("NotifyTRACETitle", { fg = c.hint })
  end

  -- Neo-tree
  if config.plugin_enabled("neo_tree") then
    hi("NeoTreeNormal", { fg = c.fg, bg = c.bg })
    hi("NeoTreeNormalNC", { fg = c.fg, bg = c.bg })
    hi("NeoTreeDirectoryIcon", { fg = c.base })
    hi("NeoTreeDirectoryName", { fg = c.fg })
    hi("NeoTreeRootName", { fg = c.base, bold = true })
    hi("NeoTreeGitAdded", { fg = c.git_add })
    hi("NeoTreeGitConflict", { fg = c.error })
    hi("NeoTreeGitDeleted", { fg = c.git_delete })
    hi("NeoTreeGitModified", { fg = c.git_change })
    hi("NeoTreeGitUntracked", { fg = c.comment })
    hi("NeoTreeIndentMarker", { fg = c.linenr })
  end
end

-- Setup function
function M.setup(opts)
  opts = opts or {}

  -- Apply user options to vim.g
  for key, value in pairs(opts) do
    vim.g["vulpes_" .. key] = value
  end
end

-- Load the colorscheme
function M.load(opts)
  -- Clear existing highlights
  vim.cmd("hi clear")
  if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
  end

  -- Set colorscheme name
  vim.g.colors_name = "vulpes"

  -- Get variant (dark/light)
  local variant = opts and opts.variant or vim.o.background
  if variant ~= "light" then
    vim.o.background = "dark"
    variant = "dark"
  end

  -- Get palette and config
  local c = palette.get(variant)
  local cfg = config.all()

  -- Apply all highlights
  set_editor_highlights(c, cfg)
  set_syntax_highlights(c, cfg)
  set_diagnostic_highlights(c)
  set_lsp_highlights(c)
  set_treesitter_highlights(c, cfg)
  set_git_highlights(c)
  set_plugin_highlights(c, cfg)

  -- Terminal colors
  if cfg.terminal_colors then
    set_terminal_colors(c)
  end
end

-- Expose palette for other plugins
M.palette = palette
M.config = config

return M
