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
local function copy_to_clipboard(text)
  -- has("clipboard") es 1 solo si Neovim encontró un proveedor (wl-copy, xclip, etc.).
  if vim.fn.has("clipboard") == 1 and pcall(vim.fn.setreg, "+", text, "c") then
    return true
  end

  -- Sin proveedor, al menos deja el texto en el registro por defecto.
  vim.fn.setreg('"', text, "c")
  vim.notify('Ink: portapapeles no disponible; copiado al registro "', vim.log.levels.WARN)
  return false
end

local function copy_path(kind)
  if vim.api.nvim_buf_get_name(0) == "" then
    vim.notify("Ink: el buffer actual no tiene archivo", vim.log.levels.WARN)
    return
  end

  local path
  if kind == "relative" then
    path = vim.fn.expand("%:.")
  elseif kind == "absolute" then
    path = vim.fn.expand("%:p")
  else
    path = vim.fn.expand("%:.") .. ":" .. vim.fn.line(".")
  end

  if copy_to_clipboard(path) then
    vim.notify("Copiado: " .. path)
  end
end

map("n", "<leader>fy", function()
  copy_path("relative")
end, { desc = "Copiar ruta relativa" })

map("n", "<leader>fY", function()
  copy_path("absolute")
end, { desc = "Copiar ruta absoluta" })

map("n", "<leader>fL", function()
  copy_path("line")
end, { desc = "Copiar ruta:línea" })
