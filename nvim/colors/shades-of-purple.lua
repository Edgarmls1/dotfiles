vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then vim.cmd("syntax reset") end
vim.g.colors_name = "shades-of-purple"
vim.opt.background = "dark"
vim.o.termguicolors = true

local hl = vim.api.nvim_set_hl
local transparent = true

local c = {
    bg              = "#2D2B55",
    bg_dark         = "#1E1E3F",
    bg_darker       = "#1F1F41",
    bg_lighter      = "#28284E",
    fg              = "#FFFFFF",
    fg_dark         = "#A599E9",
    fg_darker       = "#CEC5FF",

    purple          = "#B362FF",
    purple_bright   = "#AD70FC",
    purple_dark     = "#5D37F0",
    purple_lighter  = "#FB94FF",

    yellow          = "#FAD000",
    yellow_light    = "#FFEE80",

    orange          = "#FF9D00",
    orange_light    = "#FFB454",
    orange_dark     = "#FF7200",

    green           = "#3AD900",
    green_light     = "#A5FF90",
    green_bright    = "#92FC79",
    green_dark      = "#35AD68",

    cyan            = "#9EFFFF",
    cyan_light      = "#80FCFF",
    cyan_dark       = "#80FFBB",

    red             = "#EC3A37",
    red_light       = "#F16E6B",

    pink            = "#FF628C",
    pink_bright     = "#FF2C70",

    blue            = "#7857FE",
    blue_bright     = "#6943FF",

    border              = "#1E1E3F",
    border_highlight    = "#25254B",
    selection           = "#4D4570",
    selection_inactive  = "#3A3A5A",
    search              = "#4D4570",

    line_highlight      = "#1F1F41",
    line_number         = "#A599E9",
    cursor              = "#FAD000",
    whitespace          = "#6B6B9F",
    indent_guide        = "#A599E9",
    indent_guide_active = "#A599E9",

    error   = "#EC3A37",
    warning = "#FAD000",
    info    = "#9EFFFF",
    hint    = "#A599E9",
}

if transparent then
    local none = { bg = "NONE" }
    hl(0, "Normal",       { fg = c.fg,      bg = "NONE" })
    hl(0, "NormalNC",     { fg = c.fg_dark, bg = "NONE" })
    hl(0, "NormalFloat",  { fg = c.fg,      bg = "NONE" })
    hl(0, "SignColumn",   none)
    hl(0, "FoldColumn",   none)
    hl(0, "Folded",       { fg = c.fg_dark, bg = "NONE" })
    hl(0, "StatusLine",   { fg = c.fg_dark, bg = "NONE" })
    hl(0, "TabLineFill",  none)
    hl(0, "CursorLine",   none)
    hl(0, "CursorColumn", none)
    hl(0, "WinBar",       { fg = c.fg,      bg = "NONE" })
else
    hl(0, "Normal",       { fg = c.fg,      bg = c.bg })
    hl(0, "NormalFloat",  { fg = c.fg,      bg = c.bg_dark })
    hl(0, "NormalNC",     { fg = c.fg,      bg = c.bg })
    hl(0, "SignColumn",   { fg = c.line_number, bg = c.bg_lighter })
    hl(0, "FoldColumn",   { fg = c.fg_dark, bg = c.bg })
    hl(0, "Folded",       { fg = c.fg_dark, bg = c.bg_darker })
    hl(0, "StatusLine",   { fg = c.fg_dark, bg = c.bg_dark })
    hl(0, "TabLineFill",  { bg = c.bg })
    hl(0, "CursorLine",   { bg = c.line_highlight })
    hl(0, "CursorColumn", { bg = c.line_highlight })
    hl(0, "WinBar",       { fg = c.fg,      bg = c.bg_dark })
end

hl(0, "ColorColumn",   { bg = c.line_highlight })

hl(0, "Cursor",        { fg = c.bg,     bg = c.cursor })
hl(0, "CursorLineNr",  { fg = c.yellow, bg = c.line_highlight, bold = true })
hl(0, "LineNr",        { fg = c.line_number })

hl(0, "Visual",        { fg = c.fg, bg = c.selection })
hl(0, "VisualNOS",     { fg = c.fg, bg = c.selection })

hl(0, "Search",        { fg = c.yellow, bg = c.search })
hl(0, "IncSearch",     { fg = c.yellow, bg = c.search, bold = true })
hl(0, "CurSearch",     { fg = c.yellow, bg = c.search, bold = true })

hl(0, "VertSplit",     { fg = c.border })
hl(0, "WinSeparator",  { fg = c.border })

hl(0, "StatusLineNC",  { fg = c.fg_dark, bg = c.bg_dark })

hl(0, "TabLine",       { fg = c.fg_dark, bg = c.bg })
hl(0, "TabLineSel",    { fg = c.fg,      bg = c.bg_dark })

hl(0, "Pmenu",         { fg = c.fg_dark, bg = c.bg_darker })
hl(0, "PmenuSel",      { fg = c.fg,      bg = c.bg })
hl(0, "PmenuSbar",     { bg = c.bg_darker })
hl(0, "PmenuThumb",    { bg = c.fg_dark })

hl(0, "ErrorMsg",      { fg = c.error })
hl(0, "WarningMsg",    { fg = c.warning })
hl(0, "ModeMsg",       { fg = c.fg })
hl(0, "MoreMsg",       { fg = c.cyan })
hl(0, "Question",      { fg = c.cyan })

hl(0, "DiffAdd",       { bg = "#1a3a1a" })
hl(0, "DiffChange",    { bg = "#3a3a1a" })
hl(0, "DiffDelete",    { bg = "#3a1a1a", fg = c.red })
hl(0, "DiffText",      { bg = "#3a3a1a" })

hl(0, "SpellBad",      { sp = c.error,   undercurl = true })
hl(0, "SpellCap",      { sp = c.warning, undercurl = true })
hl(0, "SpellLocal",    { sp = c.info,    undercurl = true })
hl(0, "SpellRare",     { sp = c.hint,    undercurl = true })

hl(0, "Whitespace",    { fg = c.whitespace })
hl(0, "NonText",       { fg = c.whitespace })
hl(0, "SpecialKey",    { fg = c.whitespace })

hl(0, "Comment",       { fg = c.purple,       italic = true })

hl(0, "Constant",      { fg = c.pink })
hl(0, "String",        { fg = c.green_light })
hl(0, "Character",     { fg = c.green_bright })
hl(0, "Number",        { fg = c.pink })
hl(0, "Boolean",       { fg = c.pink })
hl(0, "Float",         { fg = c.pink })

hl(0, "Identifier",    { fg = c.cyan })
hl(0, "Function",      { fg = c.yellow })

hl(0, "Statement",     { fg = c.orange, italic = true })
hl(0, "Conditional",   { fg = c.orange, italic = true })
hl(0, "Repeat",        { fg = c.orange, italic = true })
hl(0, "Label",         { fg = c.orange })
hl(0, "Operator",      { fg = c.orange })
hl(0, "Keyword",       { fg = c.orange, italic = true })
hl(0, "Exception",     { fg = c.orange, italic = true })

hl(0, "PreProc",       { fg = c.yellow })
hl(0, "Include",       { fg = c.orange })
hl(0, "Define",        { fg = c.orange })
hl(0, "Macro",         { fg = c.yellow })
hl(0, "PreCondit",     { fg = c.orange })

hl(0, "Type",          { fg = c.cyan })
hl(0, "StorageClass",  { fg = c.purple_lighter, italic = true })
hl(0, "Structure",     { fg = c.cyan })
hl(0, "Typedef",       { fg = c.cyan })

hl(0, "Special",       { fg = c.yellow_light })
hl(0, "SpecialChar",   { fg = c.yellow_light })
hl(0, "Tag",           { fg = c.cyan })
hl(0, "Delimiter",     { fg = c.fg })
hl(0, "SpecialComment",{ fg = c.purple, italic = true })
hl(0, "Debug",         { fg = c.red })

hl(0, "Underlined",    { underline = true })
hl(0, "Ignore",        { fg = c.fg_dark })
hl(0, "Error",         { fg = c.error })
hl(0, "Todo",          { fg = c.yellow, bg = c.bg, bold = true })

hl(0, "@variable",                { fg = c.fg })
hl(0, "@variable.builtin",        { fg = c.purple_lighter, italic = true })
hl(0, "@variable.parameter",      { fg = c.cyan })
hl(0, "@variable.member",         { fg = c.yellow_light })

hl(0, "@constant",                { fg = c.pink })
hl(0, "@constant.builtin",        { fg = c.pink })
hl(0, "@constant.macro",          { fg = c.pink })

hl(0, "@module",                  { fg = c.cyan })
hl(0, "@label",                   { fg = c.orange })

hl(0, "@string",                  { fg = c.green_light })
hl(0, "@string.escape",           { fg = c.yellow_light })
hl(0, "@string.regexp",           { fg = c.purple_lighter })
hl(0, "@string.special",          { fg = c.green_bright })

hl(0, "@character",               { fg = c.green_bright })
hl(0, "@number",                  { fg = c.pink })
hl(0, "@boolean",                 { fg = c.pink })
hl(0, "@float",                   { fg = c.pink })

hl(0, "@function",                { fg = c.yellow })
hl(0, "@function.builtin",        { fg = c.orange })
hl(0, "@function.macro",          { fg = c.yellow })
hl(0, "@function.method",         { fg = c.yellow })

hl(0, "@constructor",             { fg = c.cyan })
hl(0, "@operator",                { fg = c.orange })

hl(0, "@keyword",                 { fg = c.orange, italic = true })
hl(0, "@keyword.function",        { fg = c.purple_lighter, italic = true })
hl(0, "@keyword.operator",        { fg = c.orange, italic = true })
hl(0, "@keyword.return",          { fg = c.orange, italic = true })
hl(0, "@keyword.conditional",     { fg = c.orange, italic = true })
hl(0, "@keyword.repeat",          { fg = c.orange, italic = true })
hl(0, "@keyword.import",          { fg = c.orange, italic = true })
hl(0, "@keyword.exception",       { fg = c.orange, italic = true })

hl(0, "@type",                    { fg = c.cyan })
hl(0, "@type.builtin",            { fg = c.purple_lighter, italic = true })
hl(0, "@type.qualifier",          { fg = c.orange, italic = true })

hl(0, "@attribute",               { fg = c.yellow, italic = true })
hl(0, "@property",                { fg = c.yellow_light })

hl(0, "@comment",                 { fg = c.purple, italic = true })
hl(0, "@comment.documentation",   { fg = c.purple, italic = true })

hl(0, "@punctuation.delimiter",   { fg = c.fg })
hl(0, "@punctuation.bracket",     { fg = c.fg })
hl(0, "@punctuation.special",     { fg = c.yellow_light })

hl(0, "@tag",                     { fg = c.cyan })
hl(0, "@tag.attribute",           { fg = c.yellow })
hl(0, "@tag.delimiter",           { fg = c.cyan })

hl(0, "@markup.strong",           { bold = true })
hl(0, "@markup.italic",           { italic = true })
hl(0, "@markup.underline",        { underline = true })
hl(0, "@markup.strike",           { strikethrough = true })
hl(0, "@markup.heading",          { fg = c.yellow, bold = true })
hl(0, "@markup.link",             { fg = c.purple, underline = true })
hl(0, "@markup.link.url",         { fg = c.fg_dark })
hl(0, "@markup.raw",              { fg = c.cyan })
hl(0, "@markup.list",             { fg = c.yellow })
hl(0, "@markup.quote",            { fg = c.fg_dark, italic = true })

hl(0, "@lsp.type.class",          { fg = c.cyan })
hl(0, "@lsp.type.decorator",      { fg = c.yellow })
hl(0, "@lsp.type.enum",           { fg = c.cyan })
hl(0, "@lsp.type.enumMember",     { fg = c.pink })
hl(0, "@lsp.type.function",       { fg = c.yellow })
hl(0, "@lsp.type.interface",      { fg = c.cyan })
hl(0, "@lsp.type.macro",          { fg = c.yellow })
hl(0, "@lsp.type.method",         { fg = c.yellow })
hl(0, "@lsp.type.namespace",      { fg = c.cyan })
hl(0, "@lsp.type.parameter",      { fg = c.cyan })
hl(0, "@lsp.type.property",       { fg = c.yellow_light })
hl(0, "@lsp.type.struct",         { fg = c.cyan })
hl(0, "@lsp.type.type",           { fg = c.cyan })
hl(0, "@lsp.type.typeParameter",  { fg = c.cyan })
hl(0, "@lsp.type.variable",       { fg = c.fg })

hl(0, "DiagnosticError",               { fg = c.error })
hl(0, "DiagnosticWarn",                { fg = c.warning })
hl(0, "DiagnosticInfo",                { fg = c.info })
hl(0, "DiagnosticHint",                { fg = c.hint })
hl(0, "DiagnosticUnderlineError",      { sp = c.error,   undercurl = true })
hl(0, "DiagnosticUnderlineWarn",       { sp = c.warning, undercurl = true })
hl(0, "DiagnosticUnderlineInfo",       { sp = c.info,    undercurl = true })
hl(0, "DiagnosticUnderlineHint",       { sp = c.hint,    undercurl = true })
hl(0, "DiagnosticVirtualTextError",    { fg = c.error })
hl(0, "DiagnosticVirtualTextWarn",     { fg = c.warning })
hl(0, "DiagnosticVirtualTextInfo",     { fg = c.info })
hl(0, "DiagnosticVirtualTextHint",     { fg = c.hint })

hl(0, "NvimTreeFolderIcon",         { fg = c.yellow })
hl(0, "NvimTreeFolderName",         { fg = c.fg_dark })
hl(0, "NvimTreeOpenedFolderName",   { fg = c.fg, bold = true })
hl(0, "NvimTreeRootFolder",         { fg = c.purple, bold = true })
hl(0, "NvimTreeGitDirty",           { fg = c.git_change })
hl(0, "NvimTreeGitNew",             { fg = c.git_add })
hl(0, "NvimTreeGitDeleted",         { fg = c.git_delete })
hl(0, "NvimTreeSpecialFile",        { fg = c.yellow })
hl(0, "NvimTreeIndentMarker",       { fg = c.indent_guide })

hl(0, "BufferLineFill",             { bg = c.bg })
hl(0, "BufferLineBackground",       { fg = c.fg_dark, bg = c.bg })
hl(0, "BufferLineBuffer",           { fg = c.fg_dark, bg = c.bg })
hl(0, "BufferLineBufferSelected",   { fg = c.fg,      bg = c.bg_dark, bold = true })
hl(0, "BufferLineBufferVisible",    { fg = c.fg_dark, bg = c.bg })
hl(0, "BufferLineTab",              { fg = c.fg_dark, bg = c.bg })
hl(0, "BufferLineTabSelected",      { fg = c.fg,      bg = c.bg_dark })
hl(0, "BufferLineModified",         { fg = c.git_change })
hl(0, "BufferLineModifiedSelected", { fg = c.git_change, bg = c.bg_dark })

hl(0, "LualineNormal",  { fg = c.fg,  bg = c.bg_dark })
hl(0, "LualineInsert",  { fg = c.bg,  bg = c.green })
hl(0, "LualineVisual",  { fg = c.bg,  bg = c.purple })
hl(0, "LualineReplace", { fg = c.bg,  bg = c.red })
hl(0, "LualineCommand", { fg = c.bg,  bg = c.yellow })

hl(0, "IblIndent", { fg = c.indent_guide })
hl(0, "IblScope",  { fg = c.indent_guide_active })

hl(0, "WhichKey",          { fg = c.yellow })
hl(0, "WhichKeyGroup",     { fg = c.cyan })
hl(0, "WhichKeyDesc",      { fg = c.fg })
hl(0, "WhichKeySeparator", { fg = c.fg_dark })
hl(0, "WhichKeyFloat",     { bg = c.bg_dark })

hl(0, "NoicePopup",              { bg = c.bg_dark })
hl(0, "NoicePopupBorder",        { fg = c.border })
hl(0, "NoiceCmdlinePopup",       { bg = c.bg_dark })
hl(0, "NoiceCmdlinePopupBorder", { fg = c.border })

hl(0, "FlashLabel",   { fg = c.bg,     bg = c.yellow, bold = true })
hl(0, "FlashMatch",   { fg = c.yellow })
hl(0, "FlashCurrent", { fg = c.orange })

hl(0, "DashboardShortCut", { fg = c.yellow })
hl(0, "DashboardHeader",   { fg = c.purple })
hl(0, "DashboardCenter",   { fg = c.cyan })
hl(0, "DashboardFooter",   { fg = c.fg_dark, italic = true })

hl(0, "TroubleText",   { fg = c.fg })
hl(0, "TroubleSource", { fg = c.fg_dark })
hl(0, "TroubleCode",   { fg = c.cyan })

hl(0, "NotifyERRORBorder", { fg = c.error })
hl(0, "NotifyWARNBorder",  { fg = c.warning })
hl(0, "NotifyINFOBorder",  { fg = c.info })
hl(0, "NotifyDEBUGBorder", { fg = c.hint })
hl(0, "NotifyTRACEBorder", { fg = c.purple })
hl(0, "NotifyERRORIcon",   { fg = c.error })
hl(0, "NotifyWARNIcon",    { fg = c.warning })
hl(0, "NotifyINFOIcon",    { fg = c.info })
hl(0, "NotifyDEBUGIcon",   { fg = c.hint })
hl(0, "NotifyTRACEIcon",   { fg = c.purple })
hl(0, "NotifyERRORTitle",  { fg = c.error })
hl(0, "NotifyWARNTitle",   { fg = c.warning })
hl(0, "NotifyINFOTitle",   { fg = c.info })
hl(0, "NotifyDEBUGTitle",  { fg = c.hint })
hl(0, "NotifyTRACETitle",  { fg = c.purple })
