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

-- JDTLS nuevo (2024+) exige Java 21 solo para CORRER el servidor.
-- Tu proyecto sigue en Java 17. Usamos el Java 21 que ya trae IntelliJ (/opt/idea/jbr),
-- sin instalar nada nuevo.
local java_bin = "/opt/idea/jbr/bin/java"
if vim.fn.executable(java_bin) == 0 then
  java_bin = "/usr/lib/jvm/java-17-openjdk-amd64/bin/java"
end
if vim.fn.executable(java_bin) == 0 then
  java_bin = "java"
end

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
  "-javaagent:" .. lombok_jar,
  "-jar", launcher_jar,
  "-configuration", config_dir,
  "-data", workspace_dir,
}

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

local settings = {
  java = {
    home = "/usr/lib/jvm/java-17-openjdk-amd64",
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
          name = "JavaSE-17",
          path = "/usr/lib/jvm/java-17-openjdk-amd64",
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
