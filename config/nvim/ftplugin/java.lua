-- ~/.config/nvim/ftplugin/java.lua
-- Configuración profesional de Eclipse JDTLS para Java y Spring Boot con Lombok

local ok, jdtls = pcall(require, "jdtls")
if not ok then
  return
end

-- Detectar la raíz del proyecto (Maven, Gradle, Git)
local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
local root_dir = require("jdtls.setup").find_root(root_markers)
if not root_dir then
  return
end

-- Workspace aislado por proyecto para evitar colisiones de caché
local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = vim.fn.stdpath("data") .. "/site/java/workspace-root/" .. project_name

-- Rutas de Mason para JDTLS
local mason_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
local launcher_jar = vim.fn.glob(mason_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
local lombok_jar = mason_path .. "/lombok.jar"
local config_dir = mason_path .. "/config_linux"

if launcher_jar == "" then
  vim.notify("nvim-portable: JDTLS no está instalado todavía. Ejecuta :MasonInstall jdtls", vim.log.levels.WARN)
  return
end

-- Java portable: se resuelve por JAVA_HOME o por el PATH del servidor,
-- sin rutas fijas de un PC concreto.
local java_home = vim.env.JAVA_HOME
if java_home == nil or java_home == "" or vim.fn.executable(java_home .. "/bin/java") == 0 then
  local javac = vim.fn.exepath("javac")
  -- resolve() sigue los symlinks (update-alternatives) hasta el JDK real
  java_home = javac ~= "" and vim.fn.fnamemodify(vim.fn.resolve(javac), ":h:h") or ""
end

local java_bin = java_home ~= "" and (java_home .. "/bin/java") or vim.fn.exepath("java")
if java_bin == nil or java_bin == "" then
  vim.notify("nvim-portable: no se encontró Java (define JAVA_HOME o instala default-jdk). JDTLS desactivado.", vim.log.levels.WARN)
  return
end
if vim.fn.executable(java_bin) == 0 then
  java_bin = vim.fn.resolve(vim.fn.exepath("java"))
end

-- Versión del JDK para el runtime de JDTLS (2024+ necesita Java 21+ para CORRER el
-- servidor, aunque tu proyecto puede seguir en 17).
local java_version = vim.fn.system({ java_bin, "-version" }):match('version%s+"([%d%._]+)"') or ""
local java_major = tonumber(java_version:match("^(%d+)")) or 0
if java_major > 0 and java_major < 21 then
  vim.notify("nvim-portable: Java " .. java_major .. " detectado; JDTLS recomienda 21+ para arrancar.", vim.log.levels.WARN)
end
local runtime_name = "JavaSE-" .. (java_major > 0 and tostring(java_major) or "17")

-- Comando de arranque de JDTLS con soporte nativo de Lombok para Spring Boot
local cmd = {
  java_bin,
  "-Declipse.application=org.eclipse.jdt.ls.core.id1",
  "-Dosgi.bundles.defaultStartLevel=4",
  "-Declipse.product=org.eclipse.jdt.ls.core.product",
  "-Dlog.level=ALL",
  "-Xmx2G",
  "--add-modules=ALL-SYSTEM",
  "--add-opens", "java.base/java.util=ALL-UNNAMED",
  "--add-opens", "java.base/java.lang=ALL-UNNAMED",
}

-- El agente de Lombok solo si Mason lo trae (versiones antiguas no lo incluyen
-- y un -javaagent inexistente impide que JDTLS arranque).
if vim.fn.filereadable(lombok_jar) == 1 then
  table.insert(cmd, "-javaagent:" .. lombok_jar)
end
table.insert(cmd, "-jar")
table.insert(cmd, launcher_jar)
table.insert(cmd, "-configuration")
table.insert(cmd, config_dir)
table.insert(cmd, "-data")
table.insert(cmd, workspace_dir)

local capabilities = require("cmp_nvim_lsp").default_capabilities()
local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

local on_attach = function(client, bufnr)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
  end

  -- Navegación estilo IDE (JDTLS): clases, métodos, implementaciones Spring Boot
  map("n", "gd", vim.lsp.buf.definition, "Java: Ir a definición (clase/método)")
  map("n", "gD", vim.lsp.buf.declaration, "Java: Ir a declaración")
  map("n", "gi", vim.lsp.buf.implementation, "Java: Ir a implementación (@Service/@Component)")
  map("n", "gt", vim.lsp.buf.type_definition, "Java: Ir a definición de tipo")
  map("n", "gr", vim.lsp.buf.references, "Java: Ver referencias")
  map("n", "K", vim.lsp.buf.hover, "Java: Documentación (Javadoc)")
  -- Ctrl-Click estilo VSCode/IntelliJ (requiere mouse=a en options.lua)
  map("n", "<C-LeftMouse>", "<LeftMouse><cmd>lua vim.lsp.buf.definition()<CR>", "Java: Ctrl+Click ir a definición")
  map("n", "gb", "<C-o>", "Java: Volver atrás")
  map("n", "<leader>rn", vim.lsp.buf.rename, "Java: Renombrar símbolo")
  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Java: Acciones de código")

  -- Atajos de refactorización y testing para Java / Spring Boot
  map("n", "<leader>jo", jdtls.organize_imports, "Java: Organizar imports")
  map("n", "<leader>jv", jdtls.extract_variable, "Java: Extraer variable")
  map("v", "<leader>jv", function() jdtls.extract_variable(true) end, "Java: Extraer variable")
  map("n", "<leader>jc", jdtls.extract_constant, "Java: Extraer constante")
  map("v", "<leader>jc", function() jdtls.extract_constant(true) end, "Java: Extraer constante")
  map("v", "<leader>jm", function() jdtls.extract_method(true) end, "Java: Extraer método")
  map("n", "<leader>jt", jdtls.test_class, "Java: Testear clase")
  map("n", "<leader>jn", jdtls.test_nearest_method, "Java: Testear método cercano")
end

local jdk_home = java_home ~= "" and java_home or vim.fn.fnamemodify(java_bin, ":h:h")

local settings = {
  java = {
    home = jdk_home,
    eclipse = { downloadSources = true },
    maven = { downloadSources = true },
    implementationsCodeLens = { enabled = true },
    referencesCodeLens = { enabled = true },
    references = { includeDecompiledSources = true },
    format = {
      enabled = true,
    },
    signatureHelp = { enabled = true },
    completion = {
      favoriteStaticMembers = {
        "org.hamcrest.MatcherAssert.assertThat",
        "org.hamcrest.Matchers.*",
        "org.hamcrest.CoreMatchers.*",
        "org.junit.jupiter.api.Assertions.*",
        "java.util.Objects.requireNonNull",
        "java.util.Objects.requireNonNullElse",
        "org.mockito.Mockito.*",
        "org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*",
        "org.springframework.test.web.servlet.result.MockMvcResultMatchers.*",
      },
      importOrder = {
        "java",
        "javax",
        "org",
        "com",
      },
    },
    sources = {
      organizeImports = {
        starThreshold = 9999,
        staticStarThreshold = 9999,
      },
    },
    codeGeneration = {
      toString = {
        template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
      },
      useBlocks = true,
    },
    configuration = {
      runtimes = {
        {
          -- Runtime detectado en ESTA máquina (JAVA_HOME / PATH), no una ruta fija
          name = runtime_name,
          path = jdk_home,
          default = true,
        },
      },
    },
  },
}

local config = {
  cmd = cmd,
  root_dir = root_dir,
  settings = settings,
  capabilities = capabilities,
  init_options = {
    extendedClientCapabilities = extendedClientCapabilities,
  },
  on_attach = on_attach,
}

jdtls.start_or_attach(config)
