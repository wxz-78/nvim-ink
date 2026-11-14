-- Ink · grupos de resaltado: Sintaxis clásica.
return function(ctx)
  local c = ctx.c

  return {
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
  }
end
