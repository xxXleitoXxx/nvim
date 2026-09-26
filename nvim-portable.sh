#!/bin/bash
# Lanzador portable de Neovim - aísla config, datos, estado y caché
# Uso: ./nvim-portable.sh [archivos...]
#      ./nvim-portable.sh --clean  (ignora config, para depurar)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
export XDG_CONFIG_HOME="$SCRIPT_DIR/config"
export XDG_DATA_HOME="$SCRIPT_DIR/data"
export XDG_STATE_HOME="$SCRIPT_DIR/state"
export XDG_CACHE_HOME="$SCRIPT_DIR/cache"
exec nvim "$@"
