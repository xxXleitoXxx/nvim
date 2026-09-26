#!/bin/bash
# Lanzador portable de Neovim - aísla config, datos, estado y caché,
# y usa el binario empaquetado (misma versión en cualquier PC).
# Uso: ./nvim-portable.sh [archivos...]
NVIM_VERSION="v0.12.5"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BUNDLED="$SCRIPT_DIR/tools/nvim-linux-x86_64/bin/nvim"
TARBALL_URL="https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux-x86_64.tar.gz"

pick_system_nvim() {
  command -v nvim 2>/dev/null
}

# 1. Preferir binario empaquetado
if [ -x "$BUNDLED" ]; then
  NVIM_BIN="$BUNDLED"
else
  # 2. Si no hay empaquetado, descargar la versión pineada (una sola vez)
  if [ ! -x "$BUNDLED" ]; then
    echo "[nvim-portable] Descargando Neovim $NVIM_VERSION (una sola vez)..." >&2
    mkdir -p "$SCRIPT_DIR/tools"
    if curl -fL "$TARBALL_URL" -o "$SCRIPT_DIR/tools/nvim.tar.gz"; then
      tar xzf "$SCRIPT_DIR/tools/nvim.tar.gz" -C "$SCRIPT_DIR/tools" \
        && rm "$SCRIPT_DIR/tools/nvim.tar.gz" \
        && chmod +x "$BUNDLED"
    fi
  fi
  if [ -x "$BUNDLED" ]; then
    NVIM_BIN="$BUNDLED"
  else
    # 3. Fallback: nvim del sistema (init.lua exige 0.9+ y avisa si es viejo)
    echo "[nvim-portable] Aviso: usando nvim del sistema, se recomienda el empaquetado $NVIM_VERSION." >&2
    NVIM_BIN="$(pick_system_nvim)"
    if [ -z "$NVIM_BIN" ]; then
      echo "[nvim-portable] Error: no hay Neovim disponible ni se pudo descargar." >&2
      exit 1
    fi
  fi
fi

export XDG_CONFIG_HOME="$SCRIPT_DIR/config"
export XDG_DATA_HOME="$SCRIPT_DIR/data"
export XDG_STATE_HOME="$SCRIPT_DIR/state"
export XDG_CACHE_HOME="$SCRIPT_DIR/cache"
exec "$NVIM_BIN" "$@"
