-- Prueba de humo de Ink (la usa el CI; también sirve en local):
--   nvim --headless "+luafile tests/smoke.lua" +qa
-- Sale con código 1 si algo falla.
local failures = {}

local function check(ok, msg)
  if not ok then
    table.insert(failures, msg)
  end
end

local function hl(name)
  return vim.api.nvim_get_hl(0, { name = name, link = false })
end

local function hex(n)
  return n and ("#%06x"):format(n) or nil
end

-- Carga el tema y apunta el error (con su traza) en vez de abortar la prueba.
local function apply(label)
  local ok, err = pcall(vim.cmd, "colorscheme ink")
  check(ok, ("colorscheme ink falló (%s): %s"):format(label, tostring(err)))
  return ok
end

-- 1. El tema carga y define los grupos básicos.
apply("por defecto")
check(vim.g.colors_name == "ink", "colors_name no es «ink»")

for _, group in ipairs({ "Normal", "Comment", "Visual", "DiagnosticError", "DiffAdd", "@function" }) do
  check(next(hl(group)) ~= nil, "grupo sin definir: " .. group)
end

-- 2. Cada módulo de lua/ink/groups/ carga y devuelve una función.
local ink = require("ink")
for _, name in ipairs(ink.sections) do
  local ok, mod = pcall(require, "ink.groups." .. name)
  check(ok and type(mod) == "function", "falla ink.groups." .. name)
end

-- 3. Los modos opcionales se aplican.
local palette = require("ink.palette")

vim.g.ink_semantic = true
apply("ink_semantic")
check(hex(hl("DiagnosticError").fg) == palette.hues.error:lower(), "ink_semantic no cambia DiagnosticError")

vim.g.ink_semantic = false
vim.g.ink_transparent = true
apply("ink_transparent")
check(hl("Normal").bg == nil, "ink_transparent deja fondo en Normal")

vim.g.ink_transparent = false
apply("restaurar")
check(hex(hl("Normal").bg) == palette.c.bg:lower(), "Normal no recupera el fondo")

-- 4. :checkhealth ink no debe tener errores.
vim.cmd("checkhealth ink")
for _, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, -1, false)) do
  if line:find("ERROR", 1, true) then
    table.insert(failures, "health: " .. vim.trim(line))
  end
end

if #failures > 0 then
  io.stderr:write("Ink smoke test: FALLÓ\n  - " .. table.concat(failures, "\n  - ") .. "\n")
  vim.cmd("cquit 1")
end
io.stderr:write("Ink smoke test: OK\n")
