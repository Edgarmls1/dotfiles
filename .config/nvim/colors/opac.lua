vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then vim.cmd("syntax reset") end
vim.g.colors_name = "opac"
vim.opt.background = "dark"

local hl = vim.api.nvim_set_hl
local transparent = true

local c = {
    bg       = "#0D0D0D",
    bg2      = "#141414",
    bg3      = "#1C1C1C",
    bg4      = "#242424",

    fg       = "#C8C8C8",
    fg2      = "#A0A0A0",
    fg3      = "#787878",
    fg4      = "#505050",

    bright   = "#EEEEEE",
    mid      = "#909090",
    dim      = "#3C3C3C",
    muted    = "#606060",
    cursor   = "#D0D0D0",

    error    = "#B06868",
    warn     = "#C9A670",
    info     = "#7096B0",
    hint     = "#6F9898",

    comment  = "#5A6A78",
    string   = "#8AAB8A",
    number   = "#C2A878",
    bool     = "#C08A70",
    type     = "#7FB0B0",
    keyword  = "#A97BA0",
    func     = "#7C98C4",
    variable = "#C0C0C0",
    operator = "#888888",
    special  = "#B98AB0",
    imports  = "#8F8FC0",
    constant = "#CBB488",

    diff_add = "#1A2A1A",
    diff_chg = "#1A1A2A",
    diff_del = "#2A1A1A",
    diff_txt = "#1E2E1E",
}

if transparent then
    local clear = { bg = "NONE" }
    hl(0, "Normal",      { fg = c.fg,      bg = "NONE" })
    hl(0, "NormalNC",    { fg = c.fg3,     bg = "NONE" })
    hl(0, "NormalFloat", { fg = c.fg,      bg = "NONE" })
    hl(0, "SignColumn",  clear)
    hl(0, "FoldColumn",  clear)
    hl(0, "Folded",      { fg = c.fg4,     bg = "NONE" })
    hl(0, "StatusLine",  { fg = c.mid,     bg = "NONE" })
    hl(0, "TabLineFill", clear)
    hl(0, "CursorLine",  clear)
    hl(0, "WinBar",      { fg = c.fg,      bg = "NONE" })
else
    hl(0, "Normal",      { fg = c.fg,      bg = c.bg  })
    hl(0, "NormalFloat", { fg = c.fg,      bg = c.bg2 })
    hl(0, "NormalNC",    { fg = c.fg3,     bg = c.bg  })
    hl(0, "SignColumn",  { fg = c.fg4,     bg = c.bg  })
    hl(0, "FoldColumn",  { fg = c.fg4,     bg = c.bg  })
    hl(0, "Folded",      { fg = c.fg4,     bg = c.bg2 })
    hl(0, "StatusLine",  { fg = c.fg,      bg = c.bg2 })
    hl(0, "TabLineFill", { bg = c.bg2 })
    hl(0, "CursorLine",  { bg = c.bg3 })
    hl(0, "WinBar",      { fg = c.fg,      bg = c.bg2 })
end

hl(0, "Cursor",        { fg = c.bg,     bg = c.cursor })
hl(0, "CursorColumn",  { bg = c.bg3 })
hl(0, "Visual",        { bg = c.dim })
hl(0, "VisualNOS",     { bg = c.dim })

hl(0, "LineNr",        { fg = c.mid })
hl(0, "CursorLineNr",  { fg = c.mid, bold = true })

hl(0, "StatusLineNC",  { fg = c.fg4,    bg = c.bg2 })

hl(0, "Search",        { fg = c.bg,     bg = c.bright })
hl(0, "IncSearch",     { fg = c.bg,     bg = c.cursor, bold = true })
hl(0, "CurSearch",     { fg = c.bg,     bg = c.cursor })

hl(0, "Pmenu",         { fg = c.fg,     bg = c.bg2 })
hl(0, "PmenuSel",      { fg = c.bg,     bg = c.mid })
hl(0, "PmenuSbar",     { bg = c.bg2 })
hl(0, "PmenuThumb",    { bg = c.fg4 })

hl(0, "ErrorMsg",      { fg = c.error })
hl(0, "WarningMsg",    { fg = c.warn })
hl(0, "ModeMsg",       { fg = c.bright, bold = true })
hl(0, "MoreMsg",       { fg = c.mid })

hl(0, "DiagnosticError",          { fg = c.error })
hl(0, "DiagnosticWarn",           { fg = c.warn })
hl(0, "DiagnosticInfo",           { fg = c.info })
hl(0, "DiagnosticHint",           { fg = c.hint })
hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = c.error })
hl(0, "DiagnosticUnderlineWarn",  { undercurl = true, sp = c.warn })
hl(0, "DiagnosticUnderlineInfo",  { undercurl = true, sp = c.info })

hl(0, "VertSplit",     { fg = c.dim })
hl(0, "WinSeparator",  { fg = c.dim })
hl(0, "TabLine",       { fg = c.fg4,    bg = c.bg2 })
hl(0, "TabLineSel",    { fg = c.fg,     bg = c.bg,  bold = true })

hl(0, "DiffAdd",       { bg = c.diff_add })
hl(0, "DiffChange",    { bg = c.diff_chg })
hl(0, "DiffDelete",    { bg = c.diff_del, fg = c.error })
hl(0, "DiffText",      { bg = c.diff_txt })

hl(0, "Comment",       { fg = c.comment,  italic = true })
hl(0, "Constant",      { fg = c.constant })
hl(0, "String",        { fg = c.string })
hl(0, "Character",     { fg = c.string })
hl(0, "Number",        { fg = c.number })
hl(0, "Boolean",       { fg = c.bool,     italic = true, bold = true })
hl(0, "Float",         { fg = c.number })

hl(0, "Identifier",    { fg = c.variable })
hl(0, "Function",      { fg = c.func,     bold = true })

hl(0, "Statement",     { fg = c.keyword,  bold = true })
hl(0, "Keyword",       { fg = c.keyword,  bold = true })
hl(0, "Conditional",   { fg = c.keyword,  bold = true })
hl(0, "Repeat",        { fg = c.keyword,  bold = true })
hl(0, "Label",         { fg = c.fg })
hl(0, "Operator",      { fg = c.operator })
hl(0, "Exception",     { fg = c.error,    bold = true })

hl(0, "PreProc",       { fg = c.imports })
hl(0, "Include",       { fg = c.imports })
hl(0, "Define",        { fg = c.imports })
hl(0, "Macro",         { fg = c.imports })

hl(0, "Type",          { fg = c.type })
hl(0, "StorageClass",  { fg = c.type })
hl(0, "Structure",     { fg = c.type })
hl(0, "Typedef",       { fg = c.type })

hl(0, "Special",       { fg = c.special })
hl(0, "SpecialChar",   { fg = c.special })
hl(0, "Delimiter",     { fg = c.hint })

hl(0, "Underlined",    { underline = true })
hl(0, "Error",         { fg = c.error,    bold = true })
hl(0, "Todo",          { fg = c.bg,       bg = c.warn, bold = true })

hl(0, "@comment",             { link = "Comment" })
hl(0, "@keyword",             { link = "Keyword" })
hl(0, "@keyword.function",    { fg = c.keyword,  bold = true })
hl(0, "@keyword.return",      { fg = c.keyword,  bold = true })
hl(0, "@function",            { link = "Function" })
hl(0, "@function.builtin",    { fg = c.func })
hl(0, "@method",              { fg = c.func })
hl(0, "@string",              { link = "String" })
hl(0, "@number",              { link = "Number" })
hl(0, "@boolean",             { link = "Boolean" })
hl(0, "@type",                { link = "Type" })
hl(0, "@type.builtin",        { fg = c.mid })
hl(0, "@variable",            { fg = c.variable })
hl(0, "@variable.builtin",    { fg = c.fg,       bold = true })
hl(0, "@parameter",           { fg = c.variable })
hl(0, "@field",               { fg = c.fg })
hl(0, "@property",            { fg = c.fg })
hl(0, "@constructor",         { fg = c.func })
hl(0, "@operator",            { fg = c.operator })
hl(0, "@punctuation",         { fg = c.hint })
hl(0, "@tag",                 { fg = c.bright })
hl(0, "@tag.attribute",       { fg = c.mid })
hl(0, "@namespace",           { fg = c.fg })
