-- Modificado a partir de LazyVim/starter (Apache-2.0). Ver NOTICE.
-- Atajos que se cargan en el evento VeryLazy.
-- Los de fábrica: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
local map = vim.keymap.set

-- Desplazamiento de media página con el cursor siempre centrado
map("n", "<C-d>", "<C-d>zz", { desc = "Bajar media página (centrado)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Subir media página (centrado)" })

-- Pegar sobre una selección sin perder lo copiado
map("x", "<leader>p", [["_dP]], { desc = "Pegar sin sobrescribir el registro" })

-- Ruta del archivo al portapapeles (para commits, issues, terminal...)
map("n", "<leader>fy", function()
  local path = vim.fn.expand("%:.")
  vim.fn.setreg("+", path)
  vim.notify("Copiado: " .. path)
end, { desc = "Copiar ruta relativa" })

map("n", "<leader>fY", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify("Copiado: " .. path)
end, { desc = "Copiar ruta absoluta" })
