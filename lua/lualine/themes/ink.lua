-- Ink · tema de lualine. Los modos se distinguen por brillo (no hay color).
local c = require("ink.palette").c

local function mode(bg)
  return {
    a = { fg = c.bg, bg = bg, gui = "bold" },
    b = { fg = c.fg, bg = c.bg_sel },
    c = { fg = c.prop, bg = c.bg_dark },
  }
end

return {
  normal = mode(c.prop),
  insert = mode(c.white),
  visual = mode(c.bracket),
  replace = mode(c.const),
  command = mode(c.oper),
  terminal = mode(c.type),
  inactive = {
    a = { fg = c.comment, bg = c.bg_dark },
    b = { fg = c.comment, bg = c.bg_dark },
    c = { fg = c.comment, bg = c.bg_dark },
  },
}
