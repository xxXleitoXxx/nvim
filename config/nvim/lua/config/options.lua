-- ~/.config/nvim/lua/config/options.lua
-- Opciones del editor optimizadas para desarrollo profesional en Linux

local opt = vim.opt

-- Asegurar que los binarios instalados por Mason estén en el PATH de Neovim
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
if not string.find(vim.env.PATH, mason_bin, 1, true) then
  vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
end

-- Configuración de JAVA_HOME para desarrollo en Spring Boot / Java:
-- si el servidor no lo exporta, lo deducimos del propio JDK del PATH.
if not vim.env.JAVA_HOME or vim.env.JAVA_HOME == "" then
  local javac = vim.fn.exepath("javac")
  if javac ~= "" then
    -- resolve() sigue los symlinks (/usr/bin/javac -> /usr/lib/jvm/<jdk>/bin/javac)
    local home = vim.fn.fnamemodify(vim.fn.resolve(javac), ":h:h")
    if vim.fn.isdirectory(home) == 1 then
      vim.env.JAVA_HOME = home
    end
  end
end

-- ==========================================
-- 1. INDENTACIÓN Y FORMATO DE TEXTO (CRÍTICO)
-- ==========================================
opt.expandtab = true       -- Convierte tabs en espacios (evita romper código en Python/JS)
opt.shiftwidth = 2        -- Número de espacios para cada nivel de indentación
opt.tabstop = 2           -- Número de espacios que cuenta un tab
opt.softtabstop = 2       -- Número de espacios que inserta la tecla Tab
opt.smartindent = true     -- Auto-indentación inteligente al abrir llaves o bloques
opt.autoindent = true      -- Mantiene la indentación de la línea anterior
opt.shiftround = true      -- Redondea la indentación a múltiplos de shiftwidth
opt.wrap = false           -- No partir líneas largas visualmente por defecto
opt.linebreak = true       -- Al usar wrap, corta las líneas en espacios/palabras completas, no a la mitad

-- ==========================================
-- 2. APARIENCIA E INTERFAZ
-- ==========================================
opt.number = true          -- Muestra el número de línea absoluto y fijo
opt.relativenumber = false -- Desactiva números relativos dinámicos para evitar que los números se arrastren
opt.cursorline = true      -- Resalta la línea donde está el cursor
opt.termguicolors = true   -- Colores TrueColor de 24 bits en la terminal
opt.signcolumn = "yes"     -- Mantiene siempre la columna de signos visible (evita saltos de pantalla)
opt.scrolloff = 8          -- Mantiene 8 líneas de margen visible al hacer scroll vertical
opt.sidescrolloff = 8      -- Mantiene 8 columnas de margen en scroll horizontal
opt.mouse = "a"            -- Habilita mouse en todos los modos (requerido para Ctrl-Click)
opt.mousemodel = "extend"  -- Ctrl-Click extiende selección en vez de abrir popup (permite mapear <C-LeftMouse>)

-- ==========================================
-- 3. INTEGRACIÓN CON LINUX Y SISTEMA OPERATIVO
-- ==========================================
-- Sincroniza el portapapeles de Neovim con el portapapeles del sistema (X11 con xclip)
opt.clipboard = "unnamedplus"

-- ==========================================
-- 4. BÚSQUEDA Y NAVEGACIÓN
-- ==========================================
opt.ignorecase = true      -- Ignora mayúsculas/minúsculas al buscar...
opt.smartcase = true       -- ...a menos que se use al menos una letra mayúscula
opt.hlsearch = true        -- Resalta coincidencias de búsqueda
opt.incsearch = true       -- Muestra resultados mientras se va escribiendo

-- ==========================================
-- 5. COMPORTAMIENTO DE DIVISIONES Y VENTANAS
-- ==========================================
opt.splitbelow = true      -- Los splits horizontales se abren abajo
opt.splitright = true      -- Los splits verticales se abren a la derecha

-- ==========================================
-- 6. RENDIMIENTO Y PERSISTENCIA
-- ==========================================
opt.updatetime = 250       -- Actualización rápida para diagnósticos y Git signs (250ms)
opt.timeoutlen = 300       -- Tiempo de espera para combinaciones de teclas (Which-Key)
opt.undofile = true        -- Guarda el historial de deshacer (Undo) en disco entre sesiones
opt.swapfile = false       -- Desactiva archivos .swp para evitar bloqueos
