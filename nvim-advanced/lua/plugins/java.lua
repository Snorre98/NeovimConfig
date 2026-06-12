--[[============================================================================
  plugins/java.lua — nvim-jdtls, full Java language support.

  WHY A WHOLE FILE? Java's language server (jdtls) can't be started the simple
  way other servers are. It needs:
    - a JDK on the machine (Java 17+; check with `java -version`),
    - a per-PROJECT data/workspace folder,
    - a launcher jar + a platform-specific config folder.
  So instead of listing it in lsp.lua, we start it ourselves every time a Java
  file opens. tools.lua already installs jdtls via Mason.

  The same LSP keymaps from lsp.lua (gd, K, gr, <leader>rn, …) apply once it
  attaches. If you don't write Java, this file simply never runs.
============================================================================--]]

return {
  "mfussenegger/nvim-jdtls",
  ft = "java", -- only load for Java files
  dependencies = { "saghen/blink.cmp" },
  config = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "java",
      callback = function()
        local jdtls_dir = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
        local launcher = vim.fn.glob(jdtls_dir .. "/plugins/org.eclipse.equinox.launcher_*.jar")

        if launcher == "" then
          vim.notify("jdtls not installed yet — run :MasonInstall jdtls", vim.log.levels.WARN)
          return
        end

        -- Platform-specific config folder shipped inside the jdtls package.
        local cfg = jdtls_dir .. (vim.fn.has("mac") == 1 and "/config_mac" or "/config_linux")

        -- One isolated workspace per project, keyed by the project folder name.
        local root = vim.fs.root(0, { "gradlew", "mvnw", "pom.xml", "build.gradle", ".git" })
          or vim.fn.getcwd()
        local workspace = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. vim.fn.fnamemodify(root, ":p:h:t")

        require("jdtls").start_or_attach({
          cmd = {
            "java",
            "-Declipse.application=org.eclipse.jdt.ls.core.id1",
            "-Dosgi.bundles.defaultStartLevel=4",
            "-Declipse.product=org.eclipse.jdt.ls.core.product",
            "-Dlog.protocol=true",
            "-Dlog.level=ALL",
            "-Xmx1g",
            "--add-modules=ALL-SYSTEM",
            "--add-opens", "java.base/java.util=ALL-UNNAMED",
            "--add-opens", "java.base/java.lang=ALL-UNNAMED",
            "-jar", launcher,
            "-configuration", cfg,
            "-data", workspace,
          },
          root_dir = root,
          capabilities = require("blink.cmp").get_lsp_capabilities(),
        })
      end,
    })
  end,
}
