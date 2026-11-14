#!/usr/bin/env bash
# check.sh — comprobaciones locales, las mismas ideas que el CI.
# Uso: ./check.sh
set -uo pipefail

cd "$(dirname "$0")"

fail=0
ok() { printf '  ok    %s\n' "$1"; }
bad() {
    printf '  FALLO %s\n' "$1"
    fail=1
}
skip() { printf '  salta %s\n' "$1"; }

echo "Sintaxis Lua"
if command -v luajit > /dev/null 2>&1; then
    while IFS= read -r -d '' f; do
        luajit -bl "$f" > /dev/null 2>&1 && ok "$f" || bad "$f"
    done < <(find . -name '*.lua' -not -path './.git/*' -print0 | sort -z)
else
    skip "luajit no está instalado"
fi

echo "Globales indefinidos (variables sin declarar)"
# Un `local x = require(...)` olvidado al mover código entre archivos da «attempt to index global 'x'» solo al ejecutar.
# luajit -bl lista el bytecode: GGET/GSET son accesos a variables globales; solo se permiten las de Lua y Neovim.
if command -v luajit > /dev/null 2>&1; then
    allowed=" vim require pairs ipairs type tostring tonumber pcall error assert select next string table math os io setmetatable getmetatable unpack print _G package jit "
    globals_bad=0
    while IFS= read -r -d '' f; do
        while read -r op name; do
            case "$allowed" in *" $name "*) ;; *) bad "$f usa la variable global «$name» ($op): ¿falta un local?"; globals_bad=1 ;; esac
        done < <(luajit -bl "$f" 2> /dev/null | sed -n 's/.*\b\(GGET\|GSET\)\b.*; "\(.*\)".*/\1 \2/p' | sort -u)
    done < <(find . -name '*.lua' -not -path './.git/*' -print0 | sort -z)
    [ "$globals_bad" = 0 ] && ok "sin variables globales inesperadas"
else
    skip "luajit no está instalado"
fi

echo "Formato (StyLua)"
if command -v stylua > /dev/null 2>&1; then
    stylua --check . > /dev/null 2>&1 && ok "stylua --check ." || bad "stylua --check . (ejecuta: stylua .)"
else
    skip "stylua no está instalado"
fi

echo "JSON"
if command -v jq > /dev/null 2>&1; then
    for f in *.json .neoconf.json; do
        [ -e "$f" ] || continue
        jq empty "$f" 2> /dev/null && ok "$f" || bad "$f"
    done
else
    skip "jq no está instalado"
fi

echo "Módulos de grupos"
sections=$(grep -oE 'local sections = \{[^}]*\}' lua/ink/init.lua | grep -oE '"[a-z]+"' | tr -d '"')
for s in $sections; do
    [ -f "lua/ink/groups/$s.lua" ] && ok "groups/$s.lua" || bad "falta lua/ink/groups/$s.lua"
done
for f in lua/ink/groups/*.lua; do
    name=$(basename "$f" .lua)
    grep -qx "$name" <<< "$sections" || bad "$f no está en la lista sections de lua/ink/init.lua"
done

echo "Dependencias: install.sh = lua/ink/deps.lua"
sh_deps=$(grep -E '^DEPS=\(' install.sh | sed -E 's/^DEPS=\((.*)\)/\1/' | tr ' ' '\n' | sort)
lua_deps=$(grep -oE '^\s*\{ "[a-z-]+",' lua/ink/deps.lua | grep -oE '"[a-z-]+"' | tr -d '"' | sort)
[ -n "$sh_deps" ] && [ "$sh_deps" = "$lua_deps" ] && ok "misma lista" || bad "las listas de install.sh y deps.lua difieren"

echo "Paleta ANSI = foot.ini del dotfile"
foot="${INK_FOOT:-../labwc-ink/.config/foot/foot.ini}"
if [ -f "$foot" ]; then
    from_foot=$(grep -E '^(regular|bright)[0-7]=' "$foot" | sed -E 's/^[a-z]+([0-7])=(.*)/\1 \2/' | wc -l)
    # foot: regular0-7 y bright0-7 en orden; sin '#', en minúsculas
    foot_hex=$( { grep -E '^regular[0-7]=' "$foot" | sort; grep -E '^bright[0-7]=' "$foot" | sort; } | sed -E 's/^[a-z]+[0-7]=//' | tr 'A-F' 'a-f')
    pal_hex=$(sed -n '/^M.ansi = {/,/^}/p' lua/ink/palette.lua | grep -oE '#[0-9a-fA-F]{6}' | tr -d '#' | tr 'A-F' 'a-f')
    if [ "$from_foot" -eq 16 ] && [ "$foot_hex" = "$pal_hex" ]; then
        ok "16 colores iguales"
    else
        bad "la paleta ANSI de palette.lua difiere de $foot"
    fi
else
    skip "no hay $foot (define INK_FOOT=/ruta/a/foot.ini)"
fi

echo
if [ "$fail" = 0 ]; then
    echo "Todo bien."
else
    echo "Hay fallos."
fi
exit "$fail"
