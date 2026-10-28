# Ink · Neovim

[LazyVim](https://github.com/LazyVim/LazyVim) con los colores de tu dotfile (grises sobre negro, los mismos de `foot`, `fish`, GTK, labwc y fuzzel) y herramientas para programar.

## Instalación

```sh
# Dependencias (Arch). nodejs/npm: los usa Mason para instalar varios servidores de lenguaje.
sudo pacman -S --needed neovim git ripgrep fd lazygit tree-sitter-cli gcc make nodejs npm unzip curl wl-clipboard

# Copia la configuración (haz copia de la anterior si existe)
[ -d ~/.config/nvim ] && mv ~/.config/nvim ~/.config/nvim.bak
cp -r . ~/.config/nvim
nvim   # la primera vez descarga los plugins; espera a que termine
```

Fuente: `JetBrainsMono Nerd Font` (la de tu dotfile).

## Tema Ink

`:colorscheme ink`. Es el tema por defecto. Sin un solo color: la jerarquía se marca como en tu `fish`
(comandos en blanco y negrita, cadenas `#9a9a9a`, comentarios `#5c5c5c`, errores en blanco subrayado).
Los diagnósticos se distinguen por el subrayado (ondulado = error, rayado = aviso, punteado = info/pista).
Los 16 colores del `:terminal` son los de `foot`.

| Opción (en `lua/config/options.lua`) | Efecto |
| --- | --- |
| `vim.g.ink_semantic = true` | Tonos apagados solo en diagnósticos y git (rojo/ámbar/verde). También `:InkSemantic` en caliente |
| `vim.g.ink_transparent = true` | Fondo transparente (se ve el de foot) |

La paleta está en `lua/ink/palette.lua`, con el origen de cada valor.

## Qué se ha añadido

**Extras de LazyVim** (se guardan en `lazyvim.json`; gestiónalos con `:LazyExtras`):
TypeScript, Python, JSON, YAML, TOML, Docker, Markdown y Git; depurador (`<leader>d`), tests (`<leader>t`),
refactoring (`<leader>r`), renombrar con vista previa, harpoon (`<leader>H` añade, `<leader>h` abre),
docstrings con neogen (`<leader>cn`), contexto de la función fijo arriba, colores `#rrggbb` en el código
y tipos de archivo de dotfiles. Go, Rust, C/C++ y SQL se activan desde `:LazyExtras`.

**Plugins propios** (`lua/plugins/dev.lua`):

| Plugin | Para qué | Atajo |
| --- | --- | --- |
| diffview.nvim | Diffs, historial y conflictos de merge | `<leader>gv` abrir · `<leader>gV` cerrar |
| oil.nvim | Editar carpetas como un buffer | `-` |
| treesj | Separar/unir argumentos, tablas y bloques | `<leader>cj` |
| guess-indent.nvim | Detecta tabuladores/espacios por archivo | automático |

**Atajos** (`lua/config/keymaps.lua`): `<C-d>`/`<C-u>` centrados · `<leader>p` (visual) pega sin perder lo copiado ·
`<leader>fy` / `<leader>fY` copian la ruta relativa / absoluta.

**Aviso de dependencias:** al arrancar, si falta `git`, `rg`, `fd`, `gcc`, `npm`, `tree-sitter` o `lazygit`, sale un aviso con la lista.

**Ajustes:** `scrolloff` 8, guía en la columna 100, espacios al final de línea eliminados al guardar
(salvo Markdown/MDX, correo, diffs y buffers especiales), sin animaciones y sin comprobación periódica
de actualizaciones (`:Lazy sync` cuando quieras).

## Estructura

```
colors/ink.lua              colorscheme (carga lua/ink)
lua/ink/                    paleta y grupos de resaltado
lua/lualine/themes/ink.lua  línea de estado
lua/config/                 lazy, opciones, atajos y autocmds
lua/plugins/                colorscheme.lua · dev.lua · ui.lua
lazyvim.json                extras de LazyVim activos (gestionados por :LazyExtras)
```

## Licencia

Apache License 2.0 (ver `LICENSE` y `NOTICE`). Parte de [LazyVim/starter](https://github.com/LazyVim/starter),
también Apache-2.0; `NOTICE` lista los archivos modificados.
