#!/usr/bin/env bash
# install.sh — copia la configuración a ~/.config/nvim (con copia de seguridad).
# Uso: ./install.sh [--dry-run]
set -euo pipefail

cd "$(dirname "$0")"

DRY_RUN=0
case "${1:-}" in
    "") ;;
    -n | --dry-run) DRY_RUN=1 ;;
    -h | --help)
        sed -n '2,3p' "$0" | sed 's/^# \{0,1\}//'
        exit 0
        ;;
    *)
        echo "Opción desconocida: $1 (usa --dry-run)" >&2
        exit 2
        ;;
esac

DEST="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
# Solo lo que Neovim necesita; no se copian .git, .github, tests ni scripts.
ITEMS=(init.lua colors lua lazy-lock.json lazyvim.json .neoconf.json stylua.toml .editorconfig)
# Binarios que LazyVim y Mason necesitan (deben coincidir con lua/ink/deps.lua; lo vigila check.sh).
DEPS=(git rg fd gcc node npm tree-sitter lazygit)

run() {
    if [ "$DRY_RUN" = 1 ]; then
        echo "  [dry-run] $*"
    else
        "$@"
    fi
}

if [ -e "$DEST" ] && [ "$(readlink -f "$DEST")" = "$(readlink -f "$PWD")" ]; then
    echo "$DEST ya apunta a este repositorio; no hay nada que copiar."
else
    if [ -e "$DEST" ] || [ -L "$DEST" ]; then
        backup="$DEST.bak-$(date +%Y%m%d-%H%M%S)"
        echo "Copia de seguridad: $DEST -> $backup"
        run mv "$DEST" "$backup"
    fi

    echo "Instalando en $DEST"
    run mkdir -p "$DEST"
    for item in "${ITEMS[@]}"; do
        [ -e "$item" ] && run cp -a "$item" "$DEST/"
    done
fi

missing=()
for bin in "${DEPS[@]}"; do
    command -v "$bin" > /dev/null 2>&1 || missing+=("$bin")
done

if [ "${#missing[@]}" -gt 0 ]; then
    echo
    echo "Faltan herramientas en el PATH: ${missing[*]}"
    echo "En Arch: sudo pacman -S --needed neovim git ripgrep fd lazygit tree-sitter-cli gcc make nodejs npm unzip curl wl-clipboard"
fi

echo
echo "Listo. Abre nvim (la primera vez descarga los plugins) y ejecuta :checkhealth ink"
