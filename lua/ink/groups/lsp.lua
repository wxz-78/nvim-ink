-- Ink · grupos de resaltado: LSP y diagnósticos.
return function(ctx)
  local c, s, bg = ctx.c, ctx.s, ctx.bg

  return {
    DiagnosticError = { fg = s.error },
    DiagnosticWarn = { fg = s.warn },
    DiagnosticInfo = { fg = s.info },
    DiagnosticHint = { fg = s.hint },
    DiagnosticOk = { fg = s.ok },
    DiagnosticSignError = { link = "DiagnosticError" },
    DiagnosticSignWarn = { link = "DiagnosticWarn" },
    DiagnosticSignInfo = { link = "DiagnosticInfo" },
    DiagnosticSignHint = { link = "DiagnosticHint" },
    DiagnosticSignOk = { link = "DiagnosticOk" },
    DiagnosticFloatingError = { link = "DiagnosticError" },
    DiagnosticFloatingWarn = { link = "DiagnosticWarn" },
    DiagnosticFloatingInfo = { link = "DiagnosticInfo" },
    DiagnosticFloatingHint = { link = "DiagnosticHint" },
    DiagnosticFloatingOk = { link = "DiagnosticOk" },
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
    LspReferenceTarget = { bg = c.bg_alt, underline = true },
    LspInlayHint = { fg = c.comment, italic = true },
    LspCodeLens = { fg = c.comment },
    LspCodeLensSeparator = { fg = c.border_hl },
    LspSignatureActiveParameter = { bold = true, underline = true },
  }
end
