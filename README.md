# nvim-portable

Configuración de Neovim autocontenida: el repo solo lleva la config, el binario de Neovim y
los plugins se resuelven dentro de la propia carpeta (`tools/`, `data/`, `state/`, `cache/`).
Nada se escribe en `~/.config` ni en `~/.local`, así que sirve igual en tu PC, en un USB o en
un servidor sin permisos de root.

- Neovim pineado: **v0.12.5** (misma versión en todas las máquinas)
- Plugins pineados con `lazy-lock.json`
- Soporta `x86_64` y `arm64`

## Estructura

```
nvim-portable/
├── nvim-portable.sh      # lanzador (aísla XDG_* y ejecuta Neovim)
├── config/nvim/          # init.lua + lua/  (lo que se versiona)
├── tools/                # binario Neovim desempaquetado  (ignorado por git)
├── data/                 # lazy.nvim, plugins, mason       (ignorado por git)
├── state/ y cache/       # shada, logs, compilados de TS   (ignorado por git)
```

## Instalación en el servidor

```bash
# 1. Clonar la config
git clone git@github.com:xxXleitoXxx/nvim.git ~/nvim-portable
cd ~/nvim-portable

# 2. Dependencias mínimas del sistema
sudo apt install -y git curl tar build-essential unzip ripgrep   # Debian/Ubuntu
# sudo dnf install -y git curl tar gcc gcc-c++ make unzip ripgrep  # RHEL/Fedora

# 3. Traer el binario de Neovim (una sola vez; el launcher también lo hace solo)
./nvim-portable.sh --update

# 4. Comprobar que todo está en su sitio
./nvim-portable.sh doctor

# 5. Abrir Neovim
./nvim-portable.sh
```

Primer arranque: lazy.nvim clona los plugins y Mason descarga los servidores de lenguaje
(ts_ls, pyright, jdtls, html, cssls, lua_ls, marksman) dentro de `data/`. Tarda un poco solo
la primera vez.

Atajo en el servidor (opcional, para no escribir `./nvim-portable.sh`):

```bash
ln -s ~/nvim-portable/nvim-portable.sh ~/.local/bin/nvimp
alias nvim=~/nvim-portable/nvim-portable.sh
```

## Extras opcionales

| Quiero | Instalo |
| --- | --- |
| Java / Spring Boot (JDTLS) | `sudo apt install -y default-jdk` (21+ recomendado; el proyecto puede seguir en 17) |
| Autocompletado web (prettier) | `sudo npm install -g prettier` |
| Formateo Lua | `cargo install stylua` |
| Formateo Python / shell / C | `pipx install black`, `go install mvdan.cc/sh/v3/cmd/shfmt@latest`, `sudo apt install clang-format` |
| LazyGit (`<leader>gg`) | `sudo apt install -y lazygit` |
| Lazy.nvim (versión pineada) | `sudo apt install -y luarocks` → `sudo luarocks install luacheck` |
| Markdown, DOCX, PDF (`<leader>cw/cp/cm`) | `sudo apt install -y pandoc poppler-utils libreoffice` |

## Uso

```
./nvim-portable.sh                 # abrir
./nvim-portable.sh src/App.java    # abrir un archivo
./nvim-portable.sh doctor          # diagnóstico de binario y dependencias
./nvim-portable.sh --update        # re-descargar la versión pineada
```

Para actualizar plugins: `:Lazy update` (dentro de Neovim) y sube `config/nvim/lazy-lock.json`.

## Atajos (leader = espacio)

| Atajo | Acción |
| --- | --- |
| `<leader>e` / `<leader>f` | explorador de archivos / enfocarlo |
| `<leader>p` / `<leader>g` / `<leader>/` | Telescope: archivos, grep, buffer actual |
| `gd` `gD` `gi` `gr` `K` | ir a definición, declaración, implementaciones, referencias, docs |
| `<C-LeftMouse>` | definición estilo IntelliJ |
| `<leader>rn` | renombrar símbolo |
| `<leader>cf` | formatear (Conform + LSP) |
| `<leader>jo/jv/jc/jm` | refactor de Java: imports, variable, constante, método |
| `<leader>vs` | seleccionar entorno virtual de Python |
| `<leader>sr/sl/sd` | restaurar sesión / último proyecto / dejar de guardar |
| `<leader>tz` | modo Zen |
| `<leader>gg` | LazyGit en terminal flotante |
| `<c-\>` | terminal (Toggleterm) |
| `grr` `gri` `grd` | Telescope + LSP: referencias, implementaciones, definiciones |

## Problemas frecuentes

**"Esta config requiere Neovim 0.9+"** → se está usando el `nvim` del sistema.
Instala Neovim ≥ 0.9 o ejecuta `./nvim-portable.sh --update` y usa el launcher.

**JDTLS no arranca** → requiere Java 21+ para correr el servidor: `java -version`.
Si tienes varios JDK, exporta `JAVA_HOME=/ruta/al/jdk21` antes de abrir.

**Neovim se ve sin colores** → la terminal no soporta 24 bits. Prueba
`export TERM=xterm-256color` o usa `terminal-guicolors`.

**Los parsers de Treesitter no compilan** → falta un compilador (`build-essential` / `gcc`).

**Portapapeles (`"+y`, `"+p`) vacío** → falta `xclip` o `xsel` (o `wl-clipboard` en Wayland).