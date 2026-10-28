-- Ink · colorscheme de Neovim, en los grises de tu dotfile.
--
-- Opciones (en lua/config/options.lua, antes de cargar el tema):
--   vim.g.ink_semantic = true     -- tonos apagados solo en diagnósticos y git (por defecto: solo grises)
--   vim.g.ink_transparent = true  -- fondo transparente (se ve el de foot)
-- Comando en caliente: :InkSemantic
local M = {}
local palette = require("ink.palette")

M.opts = { semantic = false, transparent = false }

function M.setup(opts)
  M.opts = vim.tbl_deep_extend("force", M.opts, opts or {})
end

local function groups(o)
  local c = palette.c
  local s = o.semantic and palette.hues or palette.grays
  local bg = o.transparent and "NONE" or c.bg
  local side = o.transparent and "NONE" or c.bg_dark

  return {
    ---------------------------------------------------------------- Interfaz
    Normal = { fg = c.fg, bg = bg },
    NormalNC = { fg = c.fg, bg = bg },
    NormalFloat = { fg = c.fg, bg = c.bg_float },
    NormalSB = { fg = c.fg, bg = side },
    FloatBorder = { fg = c.bg_sel, bg = c.bg_float },
    FloatTitle = { fg = c.white, bg = c.bg_float, bold = true },
    FloatFooter = { fg = c.comment, bg = c.bg_float },

    Cursor = { fg = c.bg, bg = c.fg_bright },
    lCursor = { link = "Cursor" },
    CursorIM = { link = "Cursor" },
    TermCursor = { link = "Cursor" },
    TermCursorNC = { bg = c.border_hl },
    CursorLine = { bg = c.bg_hl },
    CursorColumn = { link = "CursorLine" },
    ColorColumn = { bg = c.bg_hl },

    LineNr = { fg = c.border_hl },
    LineNrAbove = { link = "LineNr" },
    LineNrBelow = { link = "LineNr" },
    CursorLineNr = { fg = c.white, bold = true },
    SignColumn = { fg = c.border_hl, bg = "NONE" },
    FoldColumn = { fg = c.border_hl },
    Folded = { fg = c.punct, bg = c.bg_hl },

    Visual = { bg = c.bg_sel },
    VisualNOS = { link = "Visual" },
    Search = { fg = c.white, bg = c.border_hl },
    IncSearch = { fg = c.bg, bg = c.sel },
    CurSearch = { link = "IncSearch" },
    Substitute = { link = "IncSearch" },
    MatchParen = { fg = c.white, bg = c.bg_sel, bold = true },

    Pmenu = { fg = c.fg, bg = c.bg_float },
    PmenuSel = { fg = c.white, bg = c.bg_sel, bold = true },
    PmenuKind = { fg = c.bracket, bg = c.bg_float },
    PmenuKindSel = { fg = c.prop, bg = c.bg_sel },
    PmenuExtra = { fg = c.punct, bg = c.bg_float },
    PmenuExtraSel = { fg = c.oper, bg = c.bg_sel },
    PmenuSbar = { bg = c.bg_alt },
    PmenuThumb = { bg = c.border_hl },
    PmenuMatch = { fg = c.white, bg = c.bg_float, bold = true },
    PmenuMatchSel = { fg = c.white, bg = c.bg_sel, bold = true },
    WildMenu = { link = "PmenuSel" },

    StatusLine = { fg = c.prop, bg = side },
    StatusLineNC = { fg = c.comment, bg = side },
    StatusLineTerm = { link = "StatusLine" },
    StatusLineTermNC = { link = "StatusLineNC" },
    WinBar = { fg = c.prop, bg = "NONE" },
    WinBarNC = { fg = c.comment, bg = "NONE" },
    WinSeparator = { fg = c.border, bg = "NONE" },
    VertSplit = { link = "WinSeparator" },
    TabLine = { fg = c.comment, bg = side },
    TabLineSel = { fg = c.white, bg = bg, bold = true },
    TabLineFill = { bg = side },

    Whitespace = { fg = c.border },
    NonText = { fg = c.border },
    EndOfBuffer = { fg = c.bg },
    SpecialKey = { fg = c.border_hl },
    Conceal = { fg = c.punct },
    Directory = { fg = c.fg_bright, bold = true },
    Title = { fg = c.white, bold = true },
    Question = { fg = c.fg_bright },
    MoreMsg = { fg = c.oper },
    ModeMsg = { fg = c.prop, bold = true },
    WarningMsg = { fg = s.warn },
    ErrorMsg = { fg = s.error, bold = true },
    QuickFixLine = { bg = c.bg_alt, bold = true },
    Underlined = { underline = true },
    Ignore = { fg = c.comment },
    Todo = { fg = c.white, bg = c.bg_sel, bold = true },
    Error = { fg = s.error, underline = true },
    Bold = { bold = true },
    Italic = { italic = true },

    SpellBad = { undercurl = true, sp = s.error },
    SpellCap = { undercurl = true, sp = s.info },
    SpellLocal = { undercurl = true, sp = s.hint },
    SpellRare = { undercurl = true, sp = s.hint },

    -- Diff
    DiffAdd = { bg = s.add_bg },
    DiffChange = { bg = s.change_bg },
    DiffDelete = { fg = s.delete, bg = s.delete_bg },
    DiffText = { bg = s.text_bg, bold = true },
    Added = { fg = s.add },
    Changed = { fg = s.change },
    Removed = { fg = s.delete },
    diffAdded = { fg = s.add },
    diffRemoved = { fg = s.delete },
    diffChanged = { fg = s.change },
    diffFile = { fg = c.white, bold = true },
    diffLine = { fg = c.punct },

    ------------------------------------------------------- Sintaxis clásica
    Comment = { fg = c.comment, italic = true },
    Constant = { fg = c.const },
    String = { fg = c.oper },
    Character = { fg = c.oper },
    Number = { fg = c.const },
    Boolean = { fg = c.const, bold = true },
    Float = { link = "Number" },
    Identifier = { fg = c.fg },
    Function = { fg = c.fg_bright },
    Statement = { fg = c.white },
    Keyword = { fg = c.white, italic = true },
    Conditional = { link = "Keyword" },
    Repeat = { link = "Keyword" },
    Label = { link = "Keyword" },
    Exception = { link = "Keyword" },
    Operator = { fg = c.oper },
    PreProc = { fg = c.prop },
    Include = { link = "PreProc" },
    Define = { link = "PreProc" },
    Macro = { link = "PreProc" },
    PreCondit = { link = "PreProc" },
    Type = { fg = c.type },
    StorageClass = { link = "Type" },
    Structure = { link = "Type" },
    Typedef = { link = "Type" },
    Special = { fg = c.prop },
    SpecialChar = { link = "Special" },
    Tag = { fg = c.white },
    Delimiter = { fg = c.punct },
    SpecialComment = { fg = c.punct, italic = true },
    Debug = { fg = c.prop },

    ------------------------------------------------------------ Treesitter
    ["@variable"] = { fg = c.fg },
    ["@variable.builtin"] = { fg = c.white, italic = true },
    ["@variable.parameter"] = { fg = c.param },
    ["@variable.parameter.builtin"] = { fg = c.param, italic = true },
    ["@variable.member"] = { fg = c.prop },
    ["@constant"] = { link = "Constant" },
    ["@constant.builtin"] = { fg = c.const, bold = true },
    ["@constant.macro"] = { link = "Macro" },
    ["@module"] = { fg = c.type },
    ["@module.builtin"] = { fg = c.type, italic = true },
    ["@label"] = { link = "Label" },

    ["@string"] = { link = "String" },
    ["@string.documentation"] = { fg = c.punct, italic = true },
    ["@string.regexp"] = { fg = c.prop },
    ["@string.escape"] = { fg = c.white, bold = true },
    ["@string.special"] = { fg = c.prop },
    ["@string.special.symbol"] = { fg = c.prop },
    ["@string.special.url"] = { fg = c.oper, underline = true },
    ["@character"] = { link = "Character" },
    ["@character.special"] = { link = "SpecialChar" },
    ["@boolean"] = { link = "Boolean" },
    ["@number"] = { link = "Number" },
    ["@number.float"] = { link = "Number" },

    ["@type"] = { link = "Type" },
    ["@type.builtin"] = { fg = c.type, italic = true },
    ["@type.definition"] = { fg = c.type, bold = true },
    ["@attribute"] = { fg = c.prop },
    ["@attribute.builtin"] = { fg = c.prop, italic = true },
    ["@property"] = { fg = c.prop },

    ["@function"] = { fg = c.white, bold = true },
    ["@function.call"] = { fg = c.fg_bright },
    ["@function.builtin"] = { fg = c.white },
    ["@function.macro"] = { link = "Macro" },
    ["@function.method"] = { fg = c.white, bold = true },
    ["@function.method.call"] = { fg = c.fg_bright },
    ["@constructor"] = { fg = c.type, bold = true },
    ["@operator"] = { link = "Operator" },

    ["@keyword"] = { link = "Keyword" },
    ["@keyword.function"] = { link = "Keyword" },
    ["@keyword.operator"] = { fg = c.white, italic = true },
    ["@keyword.import"] = { link = "PreProc" },
    ["@keyword.return"] = { fg = c.white, italic = true, bold = true },
    ["@keyword.conditional"] = { link = "Keyword" },
    ["@keyword.repeat"] = { link = "Keyword" },
    ["@keyword.exception"] = { link = "Keyword" },
    ["@keyword.directive"] = { link = "PreProc" },

    ["@punctuation.delimiter"] = { link = "Delimiter" },
    ["@punctuation.bracket"] = { fg = c.bracket },
    ["@punctuation.special"] = { fg = c.oper },

    ["@comment"] = { link = "Comment" },
    ["@comment.documentation"] = { fg = c.punct, italic = true },
    ["@comment.error"] = { fg = s.error, bold = true },
    ["@comment.warning"] = { fg = s.warn, bold = true },
    ["@comment.todo"] = { fg = c.white, bg = c.bg_sel, bold = true },
    ["@comment.note"] = { fg = s.info, bold = true },

    ["@markup.strong"] = { bold = true },
    ["@markup.italic"] = { italic = true },
    ["@markup.strikethrough"] = { strikethrough = true },
    ["@markup.underline"] = { underline = true },
    ["@markup.heading"] = { fg = c.white, bold = true },
    ["@markup.heading.1"] = { fg = c.white, bold = true },
    ["@markup.heading.2"] = { fg = c.fg_bright, bold = true },
    ["@markup.heading.3"] = { fg = c.fg, bold = true },
    ["@markup.heading.4"] = { fg = c.type, bold = true },
    ["@markup.heading.5"] = { fg = c.prop, bold = true },
    ["@markup.heading.6"] = { fg = c.oper, bold = true },
    ["@markup.quote"] = { fg = c.oper, italic = true },
    ["@markup.math"] = { fg = c.prop },
    ["@markup.link"] = { fg = c.punct },
    ["@markup.link.label"] = { fg = c.prop },
    ["@markup.link.url"] = { fg = c.oper, underline = true },
    ["@markup.raw"] = { fg = c.param, bg = c.bg_hl },
    ["@markup.raw.block"] = { fg = c.param },
    ["@markup.list"] = { fg = c.oper },
    ["@markup.list.checked"] = { fg = c.const },
    ["@markup.list.unchecked"] = { fg = c.punct },

    ["@diff.plus"] = { fg = s.add },
    ["@diff.minus"] = { fg = s.delete },
    ["@diff.delta"] = { fg = s.change },

    ["@tag"] = { fg = c.white },
    ["@tag.builtin"] = { fg = c.white, italic = true },
    ["@tag.attribute"] = { fg = c.prop },
    ["@tag.delimiter"] = { fg = c.punct },

    ["@lsp.mod.deprecated"] = { strikethrough = true },

    ------------------------------------------------- LSP y diagnósticos
    DiagnosticError = { fg = s.error },
    DiagnosticWarn = { fg = s.warn },
    DiagnosticInfo = { fg = s.info },
    DiagnosticHint = { fg = s.hint },
    DiagnosticOk = { fg = s.ok },
    DiagnosticVirtualTextError = { fg = s.error, bg = c.bg_hl },
    DiagnosticVirtualTextWarn = { fg = s.warn, bg = c.bg_hl },
    DiagnosticVirtualTextInfo = { fg = s.info, bg = c.bg_hl },
    DiagnosticVirtualTextHint = { fg = s.hint, bg = c.bg_hl },
    DiagnosticVirtualTextOk = { fg = s.ok, bg = c.bg_hl },
    -- Sin color, la gravedad se distingue por el tipo de subrayado
    DiagnosticUnderlineError = { undercurl = true, sp = s.error },
    DiagnosticUnderlineWarn = { underdashed = true, sp = s.warn },
    DiagnosticUnderlineInfo = { underdotted = true, sp = s.info },
    DiagnosticUnderlineHint = { underdotted = true, sp = s.hint },
    DiagnosticUnderlineOk = { underline = true, sp = s.ok },
    DiagnosticUnnecessary = { fg = c.comment },
    DiagnosticDeprecated = { strikethrough = true, sp = s.warn },

    LspReferenceText = { bg = c.bg_alt },
    LspReferenceRead = { bg = c.bg_alt },
    LspReferenceWrite = { bg = c.bg_alt, underline = true },
    LspInlayHint = { fg = c.comment, italic = true },
    LspCodeLens = { fg = c.comment },
    LspCodeLensSeparator = { fg = c.border_hl },
    LspSignatureActiveParameter = { bold = true, underline = true },

    ----------------------------------------------------------------- Git
    GitSignsAdd = { fg = s.add },
    GitSignsChange = { fg = s.change },
    GitSignsDelete = { fg = s.delete },
    GitSignsTopdelete = { link = "GitSignsDelete" },
    GitSignsChangedelete = { link = "GitSignsChange" },
    GitSignsUntracked = { fg = c.oper },
    GitSignsCurrentLineBlame = { fg = c.comment, italic = true },

    ------------------------------------------------- Plugins de LazyVim
    -- snacks.nvim
    SnacksIndent = { fg = c.bg_alt },
    SnacksIndentScope = { fg = c.border_hl },
    SnacksPickerListCursorLine = { bg = c.bg_sel },
    SnacksPickerPreviewCursorLine = { bg = c.bg_alt },
    SnacksPickerMatch = { fg = c.white, bold = true },
    SnacksPickerDir = { fg = c.oper },
    SnacksPickerTree = { fg = c.border_hl },
    SnacksDashboardHeader = { fg = c.fg_bright },
    SnacksDashboardKey = { fg = c.white, bold = true },
    SnacksDashboardDesc = { fg = c.oper },
    SnacksDashboardIcon = { fg = c.oper },
    SnacksDashboardFooter = { fg = c.comment, italic = true },
    SnacksDashboardDir = { fg = c.comment },
    SnacksDashboardFile = { fg = c.prop },
    SnacksDashboardSpecial = { fg = c.type },

    -- blink.cmp (la selección es oscura para no pisar los colores de cada elemento)
    BlinkCmpMenu = { link = "Pmenu" },
    BlinkCmpMenuBorder = { link = "FloatBorder" },
    BlinkCmpMenuSelection = { bg = c.bg_sel, bold = true },
    BlinkCmpScrollBarThumb = { link = "PmenuThumb" },
    BlinkCmpScrollBarGutter = { link = "PmenuSbar" },
    BlinkCmpLabel = { fg = c.fg },
    BlinkCmpLabelDeprecated = { fg = c.comment, strikethrough = true },
    BlinkCmpLabelMatch = { fg = c.white, bold = true },
    BlinkCmpLabelDetail = { fg = c.punct },
    BlinkCmpLabelDescription = { fg = c.punct },
    BlinkCmpKind = { fg = c.bracket },
    BlinkCmpSource = { fg = c.punct },
    BlinkCmpGhostText = { fg = c.comment },
    BlinkCmpDoc = { link = "NormalFloat" },
    BlinkCmpDocBorder = { link = "FloatBorder" },
    BlinkCmpSignatureHelp = { link = "NormalFloat" },
    BlinkCmpSignatureHelpBorder = { link = "FloatBorder" },

    -- which-key
    WhichKey = { fg = c.fg_bright },
    WhichKeyGroup = { fg = c.oper },
    WhichKeyDesc = { fg = c.fg },
    WhichKeySeparator = { fg = c.comment },
    WhichKeyValue = { fg = c.punct },
    WhichKeyBorder = { link = "FloatBorder" },

    -- flash
    FlashLabel = { fg = c.bg, bg = c.sel, bold = true },
    FlashMatch = { fg = c.fg_bright, bg = c.bg_sel },
    FlashCurrent = { fg = c.white, bg = c.border_hl },
    FlashBackdrop = { fg = c.border_hl },

    -- noice
    NoiceCmdlineIcon = { fg = c.oper },
    NoiceCmdlinePopupBorder = { fg = c.bg_sel },
    NoiceConfirmBorder = { fg = c.bg_sel },
    NoicePopupmenuMatch = { fg = c.white, bold = true },

    -- trouble
    TroubleNormal = { link = "NormalSB" },
    TroubleNormalNC = { link = "NormalSB" },

    -- mini.icons: los «colores» de los iconos salen de la paleta ANSI de foot
    MiniIconsAzure = { fg = palette.ansi[13] },
    MiniIconsBlue = { fg = palette.ansi[5] },
    MiniIconsCyan = { fg = palette.ansi[7] },
    MiniIconsGreen = { fg = palette.ansi[3] },
    MiniIconsGrey = { fg = palette.ansi[9] },
    MiniIconsOrange = { fg = palette.ansi[4] },
    MiniIconsPurple = { fg = palette.ansi[6] },
    MiniIconsRed = { fg = palette.ansi[2] },
    MiniIconsYellow = { fg = palette.ansi[8] },

    -- treesitter-context
    TreesitterContext = { bg = c.bg_hl },
    TreesitterContextLineNumber = { fg = c.punct, bg = c.bg_hl },
    TreesitterContextBottom = { underline = true, sp = c.border },

    -- render-markdown
    RenderMarkdownH1 = { fg = c.white, bold = true },
    RenderMarkdownH2 = { fg = c.fg_bright, bold = true },
    RenderMarkdownH3 = { fg = c.fg, bold = true },
    RenderMarkdownH4 = { fg = c.type, bold = true },
    RenderMarkdownH5 = { fg = c.prop, bold = true },
    RenderMarkdownH6 = { fg = c.oper, bold = true },
    RenderMarkdownH1Bg = { bg = c.bg_alt },
    RenderMarkdownH2Bg = { bg = c.bg_hl },
    RenderMarkdownH3Bg = { bg = c.bg_hl },
    RenderMarkdownH4Bg = { bg = c.bg_hl },
    RenderMarkdownH5Bg = { bg = c.bg_hl },
    RenderMarkdownH6Bg = { bg = c.bg_hl },
    RenderMarkdownCode = { bg = c.bg_float },
    RenderMarkdownCodeInline = { fg = c.param, bg = c.bg_alt },
    RenderMarkdownBullet = { fg = c.oper },
    RenderMarkdownQuote = { fg = c.punct },
    RenderMarkdownTableHead = { fg = c.white, bold = true },
    RenderMarkdownTableRow = { fg = c.punct },

    -- depuración y tests
    DapBreakpoint = { fg = c.white },
    DapBreakpointCondition = { fg = c.type },
    DapLogPoint = { fg = c.oper },
    DapStopped = { fg = c.white, bg = c.bg_sel },
    DapStoppedLine = { bg = c.bg_alt },
    NeotestPassed = { fg = s.ok },
    NeotestFailed = { fg = s.error },
    NeotestRunning = { fg = s.warn },
    NeotestSkipped = { fg = s.info },
    NeotestFocused = { bold = true, underline = true },

    -- oil
    OilDir = { fg = c.white, bold = true },
    OilDirIcon = { fg = c.oper },
    OilFile = { fg = c.fg },
    OilLink = { fg = c.oper },
    OilCreate = { fg = s.add },
    OilDelete = { fg = s.delete },
    OilMove = { fg = s.change },
    OilChange = { fg = s.change },

    -- lazy.nvim y mason
    LazyH1 = { fg = c.bg, bg = c.sel, bold = true },
    LazyButton = { fg = c.prop, bg = c.bg_alt },
    LazyButtonActive = { fg = c.white, bg = c.bg_sel, bold = true },
    LazySpecial = { fg = c.white },
    LazyProp = { fg = c.punct },
    LazyCommit = { fg = c.oper },
    MasonHeader = { fg = c.bg, bg = c.sel, bold = true },
    MasonHighlight = { fg = c.white },
    MasonHighlightBlock = { fg = c.bg, bg = c.sel },
    MasonHighlightBlockBold = { fg = c.bg, bg = c.sel, bold = true },
    MasonMuted = { fg = c.comment },
    MasonMutedBlock = { fg = c.prop, bg = c.bg_alt },
  }
end

function M.load()
  if vim.g.ink_semantic ~= nil then
    M.opts.semantic = vim.g.ink_semantic
  end
  if vim.g.ink_transparent ~= nil then
    M.opts.transparent = vim.g.ink_transparent
  end

  vim.cmd("highlight clear")
  if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
  end
  vim.o.termguicolors = true
  vim.o.background = "dark"
  vim.g.colors_name = "ink"

  -- :terminal, lazygit y compañía usan los mismos 16 colores que foot
  for i, color in ipairs(palette.ansi) do
    vim.g["terminal_color_" .. (i - 1)] = color
  end

  for name, spec in pairs(groups(M.opts)) do
    vim.api.nvim_set_hl(0, name, spec)
  end

  if not M.command_created then
    M.command_created = true
    vim.api.nvim_create_user_command("InkSemantic", function()
      vim.g.ink_semantic = not vim.g.ink_semantic
      vim.cmd.colorscheme("ink")
      vim.notify("Ink: tonos en diagnósticos/git " .. (vim.g.ink_semantic and "activados" or "desactivados"))
    end, { desc = "Ink: alternar tonos en diagnósticos y git" })
  end
end

return M
