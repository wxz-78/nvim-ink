-- Modificado a partir de LazyVim/starter (Apache-2.0). Ver NOTICE.
-- Opciones que se cargan antes de lazy.nvim.
-- Las de fábrica: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

-- Colores (ver lua/ink/init.lua)
vim.g.ink_semantic = false -- true = tonos apagados en diagnósticos y git; también con :InkSemantic
vim.g.ink_transparent = false -- true = fondo transparente
vim.g.ink_skip_deps_check = false -- true = no avisar al arrancar de herramientas que faltan

-- Sin animaciones: menos trabajo para el terminal y respuesta inmediata
vim.g.snacks_animate = false

local opt = vim.opt
opt.scrolloff = 8 -- contexto arriba y abajo del cursor
opt.sidescrolloff = 8
opt.colorcolumn = "120" -- guía de ancho, igual que stylua.toml (la línea larga se ve, no se corta)
opt.linebreak = true -- si activas wrap, no parte palabras
opt.showbreak = "↪ "
opt.list = true -- muestra tabuladores y espacios al final
opt.listchars = { tab = "│ ", trail = "·", nbsp = "␣" }

-- Recarga los archivos que cambian fuera de Neovim (git switch, formateadores...)
opt.autoread = true

-- Corrector ortográfico en inglés y español (se activa con :set spell o <leader>us)
opt.spelllang = { "en", "es" }

-- Ventanas flotantes con las mismas esquinas redondeadas que waybar/fuzzel (Neovim 0.11+)
if vim.fn.has("nvim-0.11") == 1 then
  opt.winborder = "rounded"
end
