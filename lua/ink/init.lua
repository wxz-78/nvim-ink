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
  opts = opts or {}
  M.opts = vim.tbl_deep_extend("force", M.opts, opts)
  -- Mantén vim.g sincronizado para que :InkReload y los comandos no pierdan los valores.
  if opts.semantic ~= nil then
    vim.g.ink_semantic = opts.semantic
  end
  if opts.transparent ~= nil then
    vim.g.ink_transparent = opts.transparent
  end
end

-- Cada sección vive en lua/ink/groups/<nombre>.lua y devuelve function(ctx) -> tabla de grupos.
-- El orden importa: si un grupo se repite, gana el de la sección posterior.
local sections = { "interface", "syntax", "treesitter", "lsp", "git", "plugins" }
M.sections = sections

local function groups(o)
  local c = palette.c
  local ctx = {
    c = c,
    s = o.semantic and palette.hues or palette.grays,
    bg = o.transparent and "NONE" or c.bg,
    side = o.transparent and "NONE" or c.bg_dark,
  }

  local out = {}
  for _, name in ipairs(sections) do
    out = vim.tbl_extend("force", out, require("ink.groups." .. name)(ctx))
  end
  return out
end

function M.commands()
  if M.command_created then
    return
  end
  M.command_created = true

  vim.api.nvim_create_user_command("InkSemantic", function()
    M.opts.semantic = not M.opts.semantic
    vim.g.ink_semantic = M.opts.semantic
    vim.cmd.colorscheme("ink")
    vim.notify("Ink: tonos en diagnósticos/git " .. (M.opts.semantic and "activados" or "desactivados"))
  end, { desc = "Ink: alternar tonos en diagnósticos y git" })

  vim.api.nvim_create_user_command("InkTransparent", function()
    M.opts.transparent = not M.opts.transparent
    vim.g.ink_transparent = M.opts.transparent
    vim.cmd.colorscheme("ink")
    vim.notify("Ink: fondo transparente " .. (M.opts.transparent and "activado" or "desactivado"))
  end, { desc = "Ink: alternar fondo transparente" })

  vim.api.nvim_create_user_command("InkReload", function()
    vim.cmd.colorscheme("ink")
    vim.notify("Ink: tema recargado")
  end, { desc = "Ink: recargar el tema" })
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

  M.commands()
end

return M
