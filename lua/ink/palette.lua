-- Ink · paleta
-- Todos los valores salen de tu dotfile (foot.ini, fish/config.fish, gtk.css, labwc themerc y fuzzel.ini):
-- grises sobre negro, sin un solo color. La jerarquía se marca con brillo, negrita, cursiva y subrayado.
local M = {}

M.c = {
  -- Superficies
  bg = "#101010", -- foot: background · fuzzel: background
  bg_dark = "#0a0a0a", -- gtk: view_bg · barras laterales y línea de estado
  bg_float = "#141414", -- gtk: card_bg / headerbar · ventanas flotantes y menús
  bg_hl = "#151515", -- labwc: título activo · línea del cursor
  bg_alt = "#1a1a1a", -- foot: regular0
  bg_sel = "#3a3a3a", -- labwc: borde activo · fish: selección del pager
  border = "#2f2f2f", -- labwc: menu.separator
  border_hl = "#4a4a4a", -- labwc: botón inactivo

  -- Texto, de más apagado a más brillante
  comment = "#5c5c5c", -- fish: comentarios
  punct = "#6e6e6e", -- fish: «end» y autosugerencia
  oper = "#9a9a9a", -- fish: operadores y comillas
  bracket = "#8f8f8f", -- foot: regular4
  prop = "#bfbfbf", -- fuzzel: text
  param = "#c8c8c8", -- fish: parámetros
  type = "#cfcfcf", -- foot: regular6
  const = "#d5d5d5", -- foot: regular3
  fg = "#e4e4e4", -- gtk: window_fg · fish: normal
  fg_bright = "#f5f5f5", -- foot: foreground
  sel = "#e7e7e7", -- fuzzel: selection (se usa invertido: búsqueda activa, etiquetas de flash)
  white = "#ffffff", -- fish: comandos
}

-- Colores ANSI de foot: se usan tal cual en :terminal, lazygit, etc.
M.ansi = {
  "#1a1a1a", "#9b9b9b", "#b9b9b9", "#d5d5d5", "#8f8f8f", "#b3b3b3", "#cfcfcf", "#e6e6e6",
  "#6f6f6f", "#bdbdbd", "#dddddd", "#f5f5f5", "#a9a9a9", "#c9c9c9", "#e9e9e9", "#ffffff",
}

-- Estados (diagnósticos y git).
-- «grays» es el modo fiel a tu dotfile: sin color, el brillo marca la gravedad.
-- «hues» es opcional (vim.g.ink_semantic = true): tonos apagados solo para estados.
M.grays = {
  error = "#ffffff", warn = "#d5d5d5", info = "#9a9a9a", hint = "#6e6e6e", ok = "#bdbdbd",
  add = "#e6e6e6", change = "#a9a9a9", delete = "#6f6f6f",
  add_bg = "#1f1f1f", change_bg = "#191919", delete_bg = "#131313", text_bg = "#3a3a3a",
}
M.hues = {
  error = "#c97b7b", warn = "#c9a66b", info = "#8fa7c4", hint = "#8fb5a5", ok = "#8fb98f",
  add = "#8fb98f", change = "#c9b27b", delete = "#c97b7b",
  add_bg = "#18241a", change_bg = "#25221a", delete_bg = "#2a1b1b", text_bg = "#3a3520",
}

return M
