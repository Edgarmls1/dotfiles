vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then vim.cmd("syntax reset") end
vim.g.colors_name = "oldTerm"
vim.opt.background = "dark"

local hl = vim.api.nvim_set_hl

local c = {
    bg       = "#0D0D0D",
    bg2      = "#111111",
    bg3      = "#161616",
    fg       = "#409343",
    bright   = "#66FF44",
    mid      = "#22CC00",
    dim      = "#1A7A00",
    muted    = "#33FF00",
    cursor   = "#33FF00",
    error    = "#FF3333",
    warn     = "#FFAA00",
    info     = "#00FFAA",
    variable = "#CCFFCC",

    fg_dim   = "#666655",

    green    = "#409343",
    green_d  = "#1A5500",

    todo     = "#FFD700",
    cyan     = "#00CCCC",
    imports  = "#CC44FF",
    bool     = "#4488FF",
    numbers  = "#FF8800",
    teal     = "#00BBAA",
    white    = "#FFFFFF",

    lavender = "#AAAAEE",
    sand     = "#BBAA88",
}

hl(0, "Normal", { fg = c.fg, bg = c.bg })
hl(0, "NormalFloat", { fg = c.fg, bg = c.bg2 })
hl(0, "NormalNC", { fg = c.dim, bg = c.bg })

hl(0, "Cursor", { fg = c.bg, bg = c.cursor })
hl(0, "CursorLine", { bg = c.green_d })
hl(0, "CursorColumn", { bg = "#33FF00" })
hl(0, "Visual", { bg = c.fg_dim })
hl(0, "VisualNOS", { bg = c.fg_dim })

hl(0, "LineNr", { fg = c.dim })
hl(0, "CursorLineNr", { fg = c.bright, bold = true })
hl(0, "SignColumn", { fg = c.dim, bg = c.bg })
hl(0, "FoldColumn", { fg = c.dim, bg = c.bg })
hl(0, "Folded", { fg = c.dim, bg = c.bg2 })

hl(0, "StatusLine", { fg = c.fg, bg = c.bg2 })
hl(0, "StatusLineNC", { fg = c.dim, bg = c.bg2 })
hl(0, "WinBar", { fg = c.fg, bg = c.bg2 })

hl(0, "Search", { fg = c.bg, bg = c.bright })
hl(0, "IncSearch", { fg = c.bg, bg = c.cursor, bold = true })
hl(0, "CurSearch", { fg = c.bg, bg = c.cursor })

hl(0, "Pmenu", { fg = c.fg, bg = c.bg2 })
hl(0, "PmenuSel", { fg = c.bg, bg = c.mid })
hl(0, "PmenuSbar", { bg = c.bg2 })
hl(0, "PmenuThumb", { bg = c.dim })

hl(0, "ErrorMsg", { fg = c.error })
hl(0, "WarningMsg", { fg = c.warn })
hl(0, "ModeMsg", { fg = c.bright, bold = true })
hl(0, "MoreMsg", { fg = c.mid })

hl(0, "DiagnosticError", { fg = c.error })
hl(0, "DiagnosticWarn", { fg = c.warn })
hl(0, "DiagnosticInfo", { fg = c.info })
hl(0, "DiagnosticHint", { fg = c.dim })
hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = c.error })

hl(0, "VertSplit", { fg = c.dim })
hl(0, "WinSeparator", { fg = c.dim })
hl(0, "TabLine", { fg = c.dim, bg = c.bg2 })
hl(0, "TabLineSel", { fg = c.fg, bg = c.bg, bold = true })
hl(0, "TabLineFill", { bg = c.bg2 })

hl(0, "DiffAdd", { bg = "#003300" })
hl(0, "DiffChange", { bg = "#002200" })
hl(0, "DiffDelete", { bg = "#1a0000", fg = c.error })
hl(0, "DiffText", { bg = "#004400" })

hl(0, "Comment", { fg = c.fg_dim, italic = true })
hl(0, "Constant", { fg = c.magenta })
hl(0, "String", { fg = c.mid })
hl(0, "Character", { fg = c.mid })
hl(0, "Number", { fg = c.numbers })
hl(0, "Boolean", { fg = c.bool, italic = true, bold = true })
hl(0, "Float", { fg = c.numbers })

hl(0, "Identifier", { fg = c.variable })
hl(0, "Function", { fg = c.bright, bold = true })

hl(0, "Statement", { fg = c.fg, bold = true })
hl(0, "Keyword", { fg = c.fg, bold = true })
hl(0, "Conditional", { fg = c.fg, bold = true })
hl(0, "Repeat", { fg = c.fg, bold = true })
hl(0, "Label", { fg = c.fg })
hl(0, "Operator", { fg = c.mid })
hl(0, "Exception", { fg = c.error, bold = true })

hl(0, "PreProc", { fg = c.imports })
hl(0, "Include", { fg = c.imports })
hl(0, "Define", { fg = c.imports })
hl(0, "Macro", { fg = c.imports })

hl(0, "Type", { fg = c.lavender })
hl(0, "StorageClass", { fg = c.lavender })
hl(0, "Structure", { fg = c.lavender })
hl(0, "Typedef", { fg = c.lavender })

hl(0, "Special", { fg = c.info })
hl(0, "SpecialChar", { fg = c.info })
hl(0, "Delimiter", { fg = c.dim })

hl(0, "Underlined", { underline = true })
hl(0, "Error", { fg = c.error, bold = true })
hl(0, "Todo", { fg = c.bg, bg = c.warn, bold = true })

hl(0, "@comment", { link = "Comment" })
hl(0, "@keyword", { link = "Keyword" })
hl(0, "@keyword.function", { fg = c.fg, bold = true })
hl(0, "@keyword.return", { fg = c.fg, bold = true })
hl(0, "@function", { link = "Function" })
hl(0, "@function.builtin", { fg = c.bright })
hl(0, "@method", { fg = c.bright })
hl(0, "@string", { link = "String" })
hl(0, "@number", { link = "Number" })
hl(0, "@boolean", { link = "Boolean" })
hl(0, "@type", { link = "Type" })
hl(0, "@type.builtin", { fg = c.mid })
hl(0, "@variable", { fg = c.variable })
hl(0, "@variable.builtin", { fg = c.fg, bold = true })
hl(0, "@parameter", { fg = c.variable })
hl(0, "@field", { fg = c.fg })
hl(0, "@property", { fg = c.fg })
hl(0, "@constructor", { fg = c.bright })
hl(0, "@operator", { fg = c.mid })
hl(0, "@punctuation", { fg = c.dim })
hl(0, "@tag", { fg = c.bright })
hl(0, "@tag.attribute", { fg = c.mid })
hl(0, "@namespace", { fg = c.fg })
