#!/usr/bin/env bash
# install.sh — instala dependencias y configuración de Neovim (Ink), con copia de seguridad.
# Uso: ./install.sh [--dry-run] [--no-deps] [--no-sync] [--no-font]
set -euo pipefail

cd "$(dirname "$0")"

DRY_RUN=0
INSTALL_DEPS=1
SYNC_PLUGINS=1
INSTALL_FONT=1

usage() {
    cat << 'USAGE'
install.sh — instala dependencias y configuración de Neovim (Ink), con copia de seguridad.

Uso: ./install.sh [opciones]

  -n, --dry-run   solo muestra lo que haría, sin cambiar nada
      --no-deps   no instala paquetes del sistema (solo copia la configuración)
      --no-font   no instala JetBrainsMono Nerd Font
      --no-sync   no descarga los plugins al terminar (se descargan al abrir nvim)
  -h, --help      esta ayuda
USAGE
}

for arg in "$@"; do
    case "$arg" in
        -n | --dry-run) DRY_RUN=1 ;;
        --no-deps) INSTALL_DEPS=0 ;;
        --no-font) INSTALL_FONT=0 ;;
        --no-sync) SYNC_PLUGINS=0 ;;
        -h | --help)
            usage
            exit 0
            ;;
        *)
            echo "Opción desconocida: $arg" >&2
            usage >&2
            exit 2
            ;;
    esac
done

DEST="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
# Solo lo que Neovim necesita; no se copian .git, .github, tests ni scripts.
ITEMS=(init.lua colors lua lazy-lock.json lazyvim.json stylua.toml .editorconfig)
# Binarios que LazyVim y Mason necesitan (deben coincidir con lua/ink/deps.lua; lo vigila check.sh).
DEPS=(git rg fd gcc node npm tree-sitter lazygit)
# Versión mínima de Neovim que exige LazyVim.
NVIM_MIN="0.11.2"

# ── Utilidades ─────────────────────────────────────────────────────────────────────
if [ -t 1 ]; then
    B=$'\033[1m' G=$'\033[32m' Y=$'\033[33m' R=$'\033[31m' N=$'\033[0m'
else
    B='' G='' Y='' R='' N=''
fi
step() { printf '\n%s==>%s %s%s%s\n' "$G" "$N" "$B" "$*" "$N"; }
info() { printf '    %s\n' "$*"; }
warn() { printf '%s  aviso%s %s\n' "$Y" "$N" "$*" >&2; }
fail() { printf '%s  error%s %s\n' "$R" "$N" "$*" >&2; }

run() {
    if [ "$DRY_RUN" = 1 ]; then
        echo "  [dry-run] $*"
    else
        "$@"
    fi
}

have() { command -v "$1" > /dev/null 2>&1; }

# Ejecuta con privilegios (sudo si no somos root).
as_root() {
    if [ "$(id -u)" = 0 ]; then
        run "$@"
    elif have sudo; then
        run sudo "$@"
    else
        fail "Necesito permisos de administrador y no hay sudo. Ejecuta como root: $*"
        return 1
    fi
}

# true si $1 >= $2 (versiones tipo 0.11.2)
version_ge() { [ "$(printf '%s\n%s\n' "$2" "$1" | sort -V | head -n1)" = "$2" ]; }

# ── Dependencias ───────────────────────────────────────────────────────────────────
detect_pm() {
    for pm in pacman apt-get dnf zypper; do
        have "$pm" && {
            echo "$pm"
            return
        }
    done
    echo ""
}

install_deps() {
    local pm
    pm="$(detect_pm)"

    case "$pm" in
        pacman)
            step "Instalando dependencias con pacman"
            local pkgs=(neovim git ripgrep fd lazygit tree-sitter-cli gcc make nodejs npm unzip curl wl-clipboard)
            [ "$INSTALL_FONT" = 1 ] && pkgs+=(ttf-jetbrains-mono-nerd)
            as_root pacman -S --needed --noconfirm "${pkgs[@]}" || warn "pacman no pudo instalar todo; revisa el mensaje de arriba."
            ;;
        apt-get)
            step "Instalando dependencias con apt"
            as_root apt-get update || true
            # En Debian/Ubuntu fd se llama fdfind; lazygit y tree-sitter-cli no siempre están en los repos.
            as_root apt-get install -y neovim git ripgrep fd-find gcc make nodejs npm unzip curl wl-clipboard fontconfig ||
                warn "apt no pudo instalar todo; revisa el mensaje de arriba."
            as_root apt-get install -y lazygit 2> /dev/null || true
            if ! have fd && have fdfind && [ "$DRY_RUN" = 0 ]; then
                mkdir -p "$HOME/.local/bin"
                ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
                info "fd -> fdfind (enlace en ~/.local/bin)"
            fi
            ;;
        dnf)
            step "Instalando dependencias con dnf"
            as_root dnf install -y neovim git ripgrep fd-find lazygit gcc make nodejs npm unzip curl wl-clipboard fontconfig ||
                warn "dnf no pudo instalar todo; revisa el mensaje de arriba."
            ;;
        zypper)
            step "Instalando dependencias con zypper"
            as_root zypper --non-interactive install neovim git ripgrep fd lazygit gcc make nodejs npm unzip curl wl-clipboard fontconfig ||
                warn "zypper no pudo instalar todo; revisa el mensaje de arriba."
            ;;
        *)
            warn "No reconozco el gestor de paquetes. Instala a mano: neovim git ripgrep fd lazygit tree-sitter-cli gcc make nodejs npm unzip curl wl-clipboard"
            return 0
            ;;
    esac

    # tree-sitter-cli solo existe como paquete en Arch; en el resto va por npm, en el prefijo del usuario.
    if [ "$pm" != pacman ] && ! have tree-sitter && have npm; then
        info "Instalando tree-sitter-cli con npm (en ~/.local)"
        run npm install -g --prefix "$HOME/.local" tree-sitter-cli || warn "No se pudo instalar tree-sitter-cli con npm."
    fi

    # Nerd Font: fuera de Arch se descarga de la última versión publicada.
    if [ "$pm" != pacman ] && [ "$INSTALL_FONT" = 1 ]; then
        install_font_manual
    fi
}

install_font_manual() {
    if have fc-list && fc-list 2> /dev/null | grep -qi 'JetBrainsMono.*Nerd'; then
        info "JetBrainsMono Nerd Font ya está instalada"
        return 0
    fi
    if ! have curl || ! have unzip; then
        warn "Sin curl/unzip no puedo bajar la Nerd Font. Descárgala de https://www.nerdfonts.com/font-downloads"
        return 0
    fi
    local fontdir="${XDG_DATA_HOME:-$HOME/.local/share}/fonts/JetBrainsMonoNerd"
    local url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
    info "Descargando JetBrainsMono Nerd Font"
    if [ "$DRY_RUN" = 1 ]; then
        echo "  [dry-run] curl -fL $url -> $fontdir"
        return 0
    fi
    local tmp
    tmp="$(mktemp -d)"
    if curl -fsSL "$url" -o "$tmp/font.zip" && mkdir -p "$fontdir" && unzip -oq "$tmp/font.zip" -d "$fontdir"; then
        have fc-cache && fc-cache -f "$fontdir" > /dev/null 2>&1 || true
        info "Instalada en $fontdir"
    else
        warn "No se pudo instalar la fuente. Descárgala de https://www.nerdfonts.com/font-downloads"
    fi
    rm -rf "$tmp"
}

# ── Configuración ──────────────────────────────────────────────────────────────────
install_config() {
    step "Instalando la configuración en $DEST"
    if [ -e "$DEST" ] && [ "$(readlink -f "$DEST")" = "$(readlink -f "$PWD")" ]; then
        info "$DEST ya apunta a este repositorio; no hay nada que copiar."
        return 0
    fi

    # LazyVim guarda en `news` qué avisos ya mostró. Si no lo conservamos,
    # cada reinstallación vuelve a enseñar el NEWS.md como si fuera la primera.
    local old_news=""
    if [ "$DRY_RUN" = 0 ] && have jq && [ -f "$DEST/lazyvim.json" ]; then
        old_news="$(jq -c '.news // {}' "$DEST/lazyvim.json" 2> /dev/null || printf '{}')"
    fi

    if [ -e "$DEST" ] || [ -L "$DEST" ]; then
        local backup="$DEST.bak-$(date +%Y%m%d-%H%M%S)"
        info "Copia de seguridad: $DEST -> $backup"
        run mv "$DEST" "$backup"
    fi

    run mkdir -p "$DEST"
    local item
    for item in "${ITEMS[@]}"; do
        [ -e "$item" ] && run cp -a "$item" "$DEST/"
    done

    if [ -n "$old_news" ] && [ "$old_news" != "{}" ] && have jq; then
        local tmp="$DEST/lazyvim.json.tmp"
        if jq --argjson news "$old_news" '.news = ($news + .news)' "$DEST/lazyvim.json" > "$tmp" 2> /dev/null; then
            mv "$tmp" "$DEST/lazyvim.json"
            info "Avisos de LazyVim ya leídos conservados"
        else
            rm -f "$tmp"
        fi
    fi
    return 0
}

# ── Comprobaciones finales ─────────────────────────────────────────────────────────
verify() {
    step "Comprobando herramientas"
    # Rutas donde pueden haber quedado binarios instalados por este script.
    export PATH="$HOME/.local/bin:$PATH"

    local missing=() bin
    for bin in "${DEPS[@]}"; do
        have "$bin" || missing+=("$bin")
    done

    if [ "$DRY_RUN" = 1 ]; then
        info "(dry-run: no se comprueba lo que el script instalaría)"
        return 0
    fi

    if [ "${#missing[@]}" -gt 0 ]; then
        warn "Faltan herramientas en el PATH: ${missing[*]}"
        case " ${missing[*]} " in
            *" lazygit "*) info "lazygit: https://github.com/jesseduffield/lazygit#installation" ;;
        esac
    else
        info "Todas las herramientas están en el PATH."
    fi

    if have nvim; then
        local ver
        ver="$(nvim --version | head -n1 | sed -E 's/^NVIM v([0-9.]+).*/\1/')"
        if version_ge "$ver" "$NVIM_MIN"; then
            info "Neovim $ver"
        else
            warn "Neovim $ver es demasiado antiguo; LazyVim necesita $NVIM_MIN o posterior (https://github.com/neovim/neovim/releases)."
        fi
    else
        warn "nvim no está en el PATH."
    fi

    if [ -d "$HOME/.local/bin" ] && [[ ":$ORIG_PATH:" != *":$HOME/.local/bin:"* ]]; then
        info "Añade ~/.local/bin a tu PATH (fish: fish_add_path ~/.local/bin)."
    fi
}

sync_plugins() {
    [ "$SYNC_PLUGINS" = 1 ] || return 0
    step "Descargando plugins (Lazy restore)"
    if [ "$DRY_RUN" = 1 ]; then
        echo "  [dry-run] nvim --headless \"+Lazy! restore\" +qa"
        return 0
    fi
    if ! have nvim || ! have git; then
        warn "Sin nvim o git no se pueden descargar los plugins; se descargarán al abrir nvim."
        return 0
    fi
    if nvim --headless "+Lazy! restore" +qa 2>&1 | tail -n 5; then
        info "Plugins listos."
    else
        warn "No se pudieron descargar todos los plugins; se reintentará al abrir nvim."
    fi
}

ORIG_PATH="$PATH"

if [ "$INSTALL_DEPS" = 1 ]; then
    install_deps
else
    info "Se omite la instalación de paquetes (--no-deps)."
fi
install_config
verify
sync_plugins

step "Listo"
info "Abre nvim y ejecuta :checkhealth ink"
info "Fuente del terminal: JetBrainsMono Nerd Font (para los iconos)."
