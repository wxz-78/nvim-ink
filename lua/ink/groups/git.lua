-- Ink · grupos de resaltado: Git.
return function(ctx)
  local c, s = ctx.c, ctx.s

  return {
    GitSignsAdd = { fg = s.add },
    GitSignsChange = { fg = s.change },
    GitSignsDelete = { fg = s.delete },
    GitSignsTopdelete = { link = "GitSignsDelete" },
    GitSignsChangedelete = { link = "GitSignsChange" },
    GitSignsUntracked = { fg = c.oper },
    GitSignsCurrentLineBlame = { fg = c.comment, italic = true },
  }
end
