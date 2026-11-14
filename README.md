# Ink · Neovim

[![CI](https://github.com/wxz-78/nvim-ink/actions/workflows/ci.yml/badge.svg)](https://github.com/wxz-78/nvim-ink/actions/workflows/ci.yml)

[LazyVim](https://github.com/LazyVim/LazyVim) con los colores de tu dotfile (grises sobre negro, los mismos de `foot`, `fish`, GTK, labwc y fuzzel) y herramientas para programar.

## Requisitos

- Neovim 0.11.2 o posterior (lo exige LazyVim; compilado con LuaJIT).
- Un terminal con color de 24 bits (`COLORTERM=truecolor` o `24bit`).
- `JetBrainsMono Nerd Font` (la del dotfile) para los iconos.
- `git`, `ripgrep`, `fd`, `lazygit`, `gcc`, `make`, `nodejs`, `npm`, `tree-sitter-cli`, `curl`, `unzip` y `wl-clipboard`.

## Instalación

```sh
# Dependencias (Arch). nodejs/npm: los usa Mason para instalar varios servidores de lenguaje.
sudo pacman -S --needed neovim git ripgrep fd lazygit tree-sitter-cli gcc make nodejs npm unzip curl wl-clipboard

# Instala la configuración. Si ya existe ~/.config/nvim, la mueve a ~/.config/nvim.bak-FECHA.
# Solo copia lo que Neovim necesita (no .git, .github ni tests). Con --dry-run solo muestra qué haría.
./install.sh

nvim   # la primera vez descarga los plugins; espera a que termine
```

Para comprobar que todo está en su sitio:

```vim
:checkhealth ink
```

Para desarrollar (o clonar directamente en `~/.config/nvim`, sin copiar), `./check.sh` valida sintaxis Lua,
variables globales sin declarar (un `local` olvidado), formato, JSON y que `install.sh`, `lua/ink/deps.lua` y los módulos de `lua/ink/groups/` sean coherentes.
Si tienes el repo `labwc-ink` al lado (o `INK_FOOT=/ruta/a/foot.ini`), también comprueba que los 16 colores
ANSI de `palette.lua` coinciden con los de `foot.ini`.

## Tema Ink

`:colorscheme ink`. Es el tema por defecto. Sin un solo color: la jerarquía se marca como en tu `fish`
(comandos en blanco y negrita, cadenas `#9a9a9a`, comentarios `#5c5c5c`, errores en blanco subrayado).
Los diagnósticos se distinguen por el subrayado (ondulado = error, rayado = aviso, punteado = info/pista).
Los 16 colores del `:terminal` son los de `foot`.

| Opción (en `lua/config/options.lua`) | Efecto |
| --- | --- |
| `vim.g.ink_semantic = true` | Tonos apagados solo en diagnósticos y git (rojo/ámbar/verde). También `:InkSemantic` en caliente |
| `vim.g.ink_transparent = true` | Fondo transparente (se ve el de foot). También `:InkTransparent` |

Comandos útiles: `:InkSemantic`, `:InkTransparent` y `:InkReload`.

La paleta está en `lua/ink/palette.lua`, con el origen de cada valor. Los grupos de resaltado se reparten en
`lua/ink/groups/` (interfaz, sintaxis, treesitter, LSP, git y plugins). El tema cubre también
lualine, bufferline, snacks, blink.cmp, trouble, noice, DAP, oil, lazy, Mason, treesitter-context y render-markdown.

## Qué se ha añadido

**Extras de LazyVim** (se guardan en `lazyvim.json`; gestiónalos con `:LazyExtras`):
TypeScript, Python, JSON, YAML, TOML, Docker, Markdown y Git; depurador (`<leader>d`), tests (`<leader>t`),
refactoring (`<leader>r`), renombrar con vista previa, harpoon (`<leader>H` añade, `<leader>h` abre),
docstrings con neogen (`<leader>cn`), contexto de la función fijo arriba, colores `#rrggbb` en el código,
tipos de archivo de dotfiles, **incrementar/decrementar valores** (`editor.dial`) y **entornos**
(`coding.mini-surround`). Go, Rust, C/C++ y SQL se activan desde `:LazyExtras`.

**Plugins propios** (`lua/plugins/dev.lua`):

| Plugin | Para qué | Atajo |
| --- | --- | --- |
| diffview.nvim | Diffs, historial y conflictos de merge | `<leader>gv` abrir · `<leader>gV` cerrar |
| oil.nvim | Editar carpetas como un buffer | `-` |
| treesj | Separar/unir argumentos, tablas y bloques | `<leader>cj` |
| guess-indent.nvim | Detecta tabuladores/espacios por archivo | automático |

**Edición** (extras de LazyVim):

| Atajo | Efecto |
| --- | --- |
| `<C-a>` / `<C-x>` | Incrementar/decrementar números, fechas, booleanos, colores hex… |
| `g<C-a>` / `g<C-x>` | Lo mismo, pero incremental en visual |
| `gsa` / `gsd` | Añadir / quitar un entorno (comillas, paréntesis, etiquetas…) |
| `gsr` / `gsf` / `gsF` | Reemplazar / buscar entorno a la derecha / a la izquierda |
| `gsh` / `gsn` | Resaltar entorno / cambiar el número de líneas |

**Atajos** (`lua/config/keymaps.lua`): `<C-d>`/`<C-u>` centrados · `<leader>p` (visual) pega sin perder lo copiado ·
`<leader>fy` / `<leader>fY` copian la ruta relativa / absoluta · `<leader>fL` copia `ruta:línea`.
Las ventanas de ayuda, quickfix, man y health se cierran con `q`.

**Aviso de dependencias:** al arrancar, si falta `git`, `rg`, `fd`, `gcc`, `node`, `npm`, `tree-sitter` o `lazygit`,
sale un aviso con la lista (`lua/ink/deps.lua`). No aparece en modo headless; para silenciarlo,
`vim.g.ink_skip_deps_check = true` en `lua/config/options.lua`. `:checkhealth ink` da el detalle.

**Ajustes:** `scrolloff` 8, guía en la columna 120 (igual que StyLua), espacios al final de línea eliminados al guardar
(salvo Markdown/MDX, correo, diffs, vimwiki y buffers especiales; se puede desactivar por buffer con
`:lua vim.b.ink_no_trim = true`), recarga de archivos modificados fuera de Neovim, ortografía en inglés y español,
ventanas flotantes redondeadas en Neovim 0.11+, sin animaciones y sin comprobación periódica de actualizaciones
(`:Lazy sync` cuando quieras).

## Actualizar y reproducir

```vim
:Lazy sync      " actualiza plugins y escribe lazy-lock.json
:Lazy restore   " vuelve a las versiones fijadas en lazy-lock.json
:LazyExtras     " activa o desactiva extras de LazyVim
```

`lazy-lock.json` se versiona para que la configuración sea reproducible. Tras un `:Lazy sync`,
revisa el diff y haz commit del lock junto con tus cambios.

## Estructura

```
.github/workflows/ci.yml    lint (StyLua, LuaJIT, JSON) y arranque real de Neovim con prueba de humo
install.sh                  instala en ~/.config/nvim con copia de seguridad (--dry-run)
check.sh                    comprobaciones locales (sintaxis, globales sin declarar, formato, JSON, coherencia, paleta vs foot)
tests/smoke.lua             prueba de humo: tema, grupos, modos opcionales y :checkhealth ink
colors/ink.lua              colorscheme (carga lua/ink)
lua/ink/                    paleta, deps (herramientas externas), health y grupos de resaltado
lua/ink/groups/             un módulo por sección: interface · syntax · treesitter · lsp · git · plugins
lua/lualine/themes/ink.lua  línea de estado
lua/config/                 lazy, opciones, atajos y autocmds
lua/plugins/                colorscheme.lua · dev.lua · ui.lua
lazyvim.json                extras de LazyVim activos (gestionados por :LazyExtras)
lazy-lock.json              versiones fijadas de los plugins
stylua.toml                 formato del código Lua
```

## Licencia

Apache License 2.0 (ver `LICENSE` y `NOTICE`). Parte de [LazyVim/starter](https://github.com/LazyVim/starter),
también Apache-2.0; `NOTICE` lista los archivos modificados.
