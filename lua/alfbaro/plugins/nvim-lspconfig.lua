return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { "hrsh7th/cmp-nvim-lsp" },
    { "antosha417/nvim-lsp-file-operations", config = true },
  },
  config = function()
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    local lspconfig = vim.lsp.config
    local opts = { noremap = true, silent = true }
    local on_attach = function(_, bufnr)
      opts.buffer = bufnr

      opts.desc = "Show line diagnostics"
      vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

      opts.desc = "Show documentation for what is under cursor"
      vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

      opts.desc = "Show LSP definition"
      vim.keymap.set("n", "gd", function() Snacks.picker.lsp_definitions() end, opts)
    end

    -- Look up sourcekit-lsp and enable it only when a Swift file opens.
    -- This avoids a blocking `xcrun` call on every Neovim startup.
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "swift",
      once = true,
      callback = function()
        lspconfig("sourcekit", {
          capabilities = capabilities,
          on_attach = on_attach,
          root_dir = function(_, callback)
            callback(
              require("lspconfig.util").root_pattern("Package.swift")(vim.fn.getcwd())
                or require("lspconfig.util").find_git_ancestor(vim.fn.getcwd())
            )
          end,
          cmd = { vim.trim(vim.fn.system("xcrun -f sourcekit-lsp")) }
        })
        vim.lsp.enable("sourcekit")
      end,
    })

    -- nice icons
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    vim.diagnostic.config({
        float = { border = "rounded" },
        virtual_text = true,
        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = signs.Error,
                [vim.diagnostic.severity.WARN] = signs.Warn,
                [vim.diagnostic.severity.HINT] = signs.Hint,
                [vim.diagnostic.severity.INFO] = signs.Info,
            },
            linehl = {
                [vim.diagnostic.severity.ERROR] = "ErrorMsg",
            },
            numhl = {
                [vim.diagnostic.severity.WARN] = "WarningMsg",
            },
        },
    })
  end,
}
