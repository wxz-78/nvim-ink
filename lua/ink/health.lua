-- Comprobaciones de Ink para `:checkhealth ink`.
-- Comprueba la versión de Neovim, el color de 24 bits, la paleta y las herramientas externas.
local M = {}

local health = vim.health or require("health")

local function has(bin)
  return vim.fn.executable(bin) == 1
end

function M.check()
  health.start("Ink")

  local version = vim.version()
  local label = ("Neovim %d.%d.%d"):format(version.major, version.minor, version.patch)
  if vim.fn.has("nvim-0.11.2") == 1 then
    health.ok(label)
  else
    health.error(label .. ": LazyVim requiere Neovim 0.11.2 o posterior")
  end

  if vim.o.termguicolors then
    health.ok("termguicolors activado")
  else
    health.warn("termguicolors desactivado; el tema necesita color de 24 bits")
  end

  local colorterm = vim.env.COLORTERM
  if colorterm == "truecolor" or colorterm == "24bit" then
    health.ok("COLORTERM=" .. colorterm)
  else
    health.warn("COLORTERM no es truecolor/24bit; los grises pueden no verse como en foot")
  end

  local ok, palette = pcall(require, "ink.palette")
  if ok and type(palette) == "table" and palette.c and palette.ansi then
    local tones = 0
    for _ in pairs(palette.c) do
      tones = tones + 1
    end
    if #palette.ansi == 16 then
      health.ok(("Paleta cargada: %d tonos y 16 colores ANSI"):format(tones))
    else
      health.error(("La paleta ANSI tiene %d colores; deben ser 16"):format(#palette.ansi))
    end
  else
    health.error("No se pudo cargar lua/ink/palette.lua")
  end

  if vim.g.colors_name == "ink" then
    health.ok("Colorscheme activo: ink")
  else
    health.info("Colorscheme activo: " .. (vim.g.colors_name or "ninguno"))
  end

  local ink_ok, ink = pcall(require, "ink")
  if ink_ok and ink.opts then
    health.info(
      ("Opciones: semantic=%s, transparent=%s"):format(tostring(ink.opts.semantic), tostring(ink.opts.transparent))
    )
  end

  if ink_ok and ink.sections then
    local broken = {}
    for _, name in ipairs(ink.sections) do
      local mod_ok, mod = pcall(require, "ink.groups." .. name)
      if not (mod_ok and type(mod) == "function") then
        table.insert(broken, name)
      end
    end
    if #broken == 0 then
      health.ok(("Grupos de resaltado: %d módulos cargados"):format(#ink.sections))
    else
      health.error("Fallan módulos de lua/ink/groups/: " .. table.concat(broken, ", "))
    end
  end

  health.start("Ink · herramientas externas")
  local missing = {}
  for _, tool in ipairs(require("ink.deps").missing()) do
    table.insert(missing, tool[1] .. " (" .. tool[2] .. ")")
  end

  if #missing == 0 then
    health.ok("Todas las herramientas externas están en el PATH")
  else
    health.warn("Faltan herramientas en el PATH:\n  - " .. table.concat(missing, "\n  - "))
  end

  if has("wl-copy") and has("wl-paste") then
    health.ok("wl-copy y wl-paste disponibles (portapapeles de Wayland)")
  elseif has("wl-copy") then
    health.info("wl-copy disponible; wl-paste no está en el PATH (copiar funciona, pegar puede no hacerlo)")
  else
    health.info("wl-copy no está en el PATH; el portapapeles puede no sincronizarse")
  end
end

return M
