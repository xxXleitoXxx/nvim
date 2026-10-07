#!/bin/bash
# Lanzador portable de Neovim - aísla config, datos, estado y caché,
# y usa el binario empaquetado (misma versión en cualquier PC o servidor).
# Uso:
#   ./nvim-portable.sh                 -> abre Neovim
#   ./nvim-portable.sh archivo.txt     -> abre un archivo
#   ./nvim-portable.sh doctor          -> comprueba binario y dependencias
#   ./nvim-portable.sh --update        -> (re)descarga la versión pineada
NVIM_VERSION="v0.12.5"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TOOLS_DIR="$SCRIPT_DIR/tools"

# Arquitectura del servidor: x86_64 o arm64 (el nombre del tarball oficial lo define)
detect_target() {
  case "$(uname -m)" in
    x86_64|amd64) echo "x86_64" ;;
    aarch64|arm64) echo "arm64" ;;
    *) echo "" ;;
  esac
}

TARGET="$(detect_target)"
TARBALL="nvim-linux-${TARGET}"
BUNDLED="$TOOLS_DIR/$TARBALL/bin/nvim"
TARBALL_URL="https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/${TARBALL}.tar.gz"

download_nvim() {
  if [ -z "$TARGET" ]; then
    echo "[nvim-portable] Error: arquitectura $(uname -m) sin tarball oficial; usa el nvim del sistema." >&2
    return 1
  fi
  if ! command -v tar >/dev/null 2>&1; then
    echo "[nvim-portable] Error: falta 'tar', necesario para descomprimir Neovim." >&2
    return 1
  fi
  mkdir -p "$TOOLS_DIR"
  local tmp="$TOOLS_DIR/nvim.tar.gz"

  echo "[nvim-portable] Descargando Neovim $NVIM_VERSION ($TARBALL), una sola vez..." >&2
  if command -v curl >/dev/null 2>&1; then
    curl -fL "$TARBALL_URL" -o "$tmp" || { rm -f "$tmp"; return 1; }
  elif command -v wget >/dev/null 2>&1; then
    wget -O "$tmp" "$TARBALL_URL" || { rm -f "$tmp"; return 1; }
  else
    echo "[nvim-portable] Error: necesitas curl o wget para descargar Neovim." >&2
    return 1
  fi

  tar xzf "$tmp" -C "$TOOLS_DIR" || { rm -f "$tmp"; return 1; }
  rm -f "$tmp"
  chmod +x "$BUNDLED" || return 1

  # Verifica que el binario realmente corresponde a la versión pineada
  local got
  got="$("$BUNDLED" --version 2>/dev/null | head -n1 | tr -d '\r')"
  case "$got" in
    *"$NVIM_VERSION"*) : ;;
    *) echo "[nvim-portable] Aviso: el binario reporta '$got' (se esperaba $NVIM_VERSION)." >&2 ;;
  esac
  return 0
}

doctor() {
  echo "nvim-portable en $SCRIPT_DIR"
  echo "  destino:    $TARBALL  ($NVIM_VERSION)"
  if [ -x "$BUNDLED" ]; then
    echo "  binario:    $("$BUNDLED" --version 2>/dev/null | head -n1)"
  else
    echo "  binario:    aún no descargado (se baja solo al abrir o con --update)"
  fi

  local faltan=0
  local group
  for group in "git" "tar" "curl wget" "unzip" "cc gcc" "java javac" "node npm" "pandoc" "pdftotext" "rg" "xclip xsel wl-copy" "lazygit"; do
    local ok=0 d
    for d in $group; do
      command -v "$d" >/dev/null 2>&1 && ok=1 && break
    done
    if [ "$ok" = "1" ]; then
      printf '  [ok]    %s\n' "$group"
    else
      printf '  [falta] %s\n' "$group"
      faltan=$((faltan + 1))
    fi
  done

  local status=0
  if [ ! -x "$BUNDLED" ]; then
    status=1
    echo "  -> ejecuta './nvim-portable.sh --update' para traer el binario."
  fi
  if [ "$faltan" -gt 0 ]; then
    status=1
    echo "  -> $faltan dependencia(s) ausente(s); instala solo las que uses."
    echo "     Ubuntu/Debian: sudo apt install -y build-essential unzip curl git ripgrep"
    echo "     RHEL/Fedora:   sudo dnf install -y gcc gcc-c++ make unzip curl git ripgrep"
  fi
  return $status
}

case "${1:-}" in
  doctor)
    doctor
    exit $?
    ;;
  --update|-u)
    if download_nvim; then
      echo "[nvim-portable] Neovim $NVIM_VERSION listo en $BUNDLED" >&2
      exit 0
    fi
    echo "[nvim-portable] No se pudo preparar el binario empaquetado." >&2
    exit 1
    ;;
esac

# 1. Preferir binario empaquetado
if [ -x "$BUNDLED" ]; then
  NVIM_BIN="$BUNDLED"
else
  # 2. Si no hay empaquetado, descargar la versión pineada (una sola vez)
  if ! download_nvim; then
    # 3. Fallback: nvim del sistema (init.lua exige 0.9+ y avisa si es viejo)
    echo "[nvim-portable] Aviso: usando nvim del sistema, se recomienda el empaquetado $NVIM_VERSION." >&2
    NVIM_BIN="$(command -v nvim 2>/dev/null)"
    if [ -z "$NVIM_BIN" ]; then
      echo "[nvim-portable] Error: no hay Neovim disponible ni se pudo descargar." >&2
      exit 1
    fi
  else
    NVIM_BIN="$BUNDLED"
  fi
fi

export XDG_CONFIG_HOME="$SCRIPT_DIR/config"
export XDG_DATA_HOME="$SCRIPT_DIR/data"
export XDG_STATE_HOME="$SCRIPT_DIR/state"
export XDG_CACHE_HOME="$SCRIPT_DIR/cache"
exec "$NVIM_BIN" "$@"
