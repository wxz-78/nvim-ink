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

-- 5. Comandos en caliente: alternan modos y sincronizan vim.g.
for _, cmd in ipairs({ "InkSemantic", "InkTransparent", "InkReload" }) do
  check(vim.fn.exists(":" .. cmd) == 2, "falta el comando :" .. cmd)
end

local gray_error = hex(hl("DiagnosticError").fg)
vim.cmd("InkSemantic")
check(hex(hl("DiagnosticError").fg) == palette.hues.error:lower(), ":InkSemantic no aplica los tonos")
check(vim.g.ink_semantic == true, ":InkSemantic no actualiza vim.g")
vim.cmd("InkSemantic")
check(hex(hl("DiagnosticError").fg) == gray_error, ":InkSemantic no restaura los grises")
check(vim.g.ink_semantic == false, ":InkSemantic no restaura vim.g")

vim.cmd("InkTransparent")
check(hl("Normal").bg == nil, ":InkTransparent no quita el fondo")
check(vim.g.ink_transparent == true, ":InkTransparent no actualiza vim.g")
vim.cmd("InkTransparent")
check(hex(hl("Normal").bg) == palette.c.bg:lower(), ":InkTransparent no restaura el fondo")
check(vim.g.ink_transparent == false, ":InkTransparent no restaura vim.g")

vim.cmd("InkReload")
check(vim.g.colors_name == "ink", ":InkReload no recarga el tema")

-- 6. Especificaciones de resaltado: claves, colores y enlaces válidos.
local valid_keys = {
  fg = true,
  bg = true,
  sp = true,
  link = true,
  bold = true,
  italic = true,
  underline = true,
  undercurl = true,
  underdashed = true,
  underdotted = true,
  underdouble = true,
  strikethrough = true,
  reverse = true,
  inverse = true,
  nocombine = true,
  ctermfg = true,
  ctermbg = true,
  cterm = true,
  force = true,
  default = true,
  blend = true,
}
local ctx = { c = palette.c, s = palette.grays, bg = palette.c.bg, side = palette.c.bg_dark }
local groups = {}
for _, name in ipairs(ink.sections) do
  for group, spec in pairs(require("ink.groups." .. name)(ctx)) do
    groups[group] = spec
    if type(spec) ~= "table" then
      check(false, "grupo no es una tabla: " .. group)
    else
      for k, v in pairs(spec) do
        if not valid_keys[k] then
          check(false, ("clave desconocida en %s: %s"):format(group, k))
        end
        if (k == "fg" or k == "bg" or k == "sp") and v ~= "NONE" then
          if type(v) ~= "string" or not v:match("^#%x%x%x%x%x%x$") then
            check(false, ("color inválido en %s.%s: %s"):format(group, k, tostring(v)))
          end
        end
      end
    end
  end
end
for group, spec in pairs(groups) do
  if type(spec) == "table" and type(spec.link) == "string" and groups[spec.link] == nil then
    check(false, ("enlace roto: %s -> %s"):format(group, spec.link))
  end
end

-- 7. Atajos y autocmds propios (LazyVim los carga en VeryLazy).
local trim_group = vim.api.nvim_create_augroup("ink_trim_whitespace", { clear = false })
local function trim_autocmds()
  return vim.api.nvim_get_autocmds({ group = trim_group, event = "BufWritePre" })
end
if #trim_autocmds() == 0 then
  vim.cmd("doautocmd User VeryLazy")
end
check(#trim_autocmds() > 0, "falta el autocmd de recorte")
for _, lhs in ipairs({ "<Leader>fy", "<Leader>fY", "<Leader>fL" }) do
  check(vim.fn.maparg(lhs, "n") ~= "", "falta el atajo " .. lhs)
end

-- 8. Recorte de espacios al guardar, con sus excepciones.
local function test_trim(suffix, lines, expected, setup)
  local path = vim.fn.tempname() .. suffix
  local f = assert(io.open(path, "w"))
  f:write(table.concat(lines, "\n"), "\n")
  f:close()
  vim.cmd("edit! " .. vim.fn.fnameescape(path))
  if setup then
    setup()
  end
  vim.cmd("write")
  local actual = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  check(vim.deep_equal(actual, expected), "recorte en " .. suffix .. ": " .. vim.inspect(actual))
  vim.cmd("bdelete!")
  vim.fn.delete(path)
end

-- LazyVim activa spell en buffers de texto: sin spelllang no pide descargar diccionarios.
local spell = vim.o.spell
local spelllang = vim.o.spelllang
vim.o.spell = false
vim.o.spelllang = ""
test_trim(".txt", { "a   ", "b\t" }, { "a", "b" })
test_trim(".md", { "a  ", "b" }, { "a  ", "b" })
test_trim(".txt", { "a   " }, { "a   " }, function()
  vim.b.ink_no_trim = true
end)
vim.o.spell = spell
vim.o.spelllang = spelllang

if #failures > 0 then
  io.stderr:write("Ink smoke test: FALLÓ\n  - " .. table.concat(failures, "\n  - ") .. "\n")
  vim.cmd("cquit 1")
end
io.stderr:write("Ink smoke test: OK\n")
