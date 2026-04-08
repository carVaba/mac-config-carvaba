return {
  "neovim/nvim-lspconfig",
  dependencies = {
    { "hrsh7th/cmp-nvim-lsp" }, -- choose which plugin you use
    { "saghen/blink.cmp" }, -- choose which plugin you use
    { "antosha417/nvim-lsp-file-operations", config = true },
  },
  config = function()
    -- choose which plugin you use:
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    -- local capabilities = require("blink.cmp").get_lsp_capabilities()

    local lspconfig = vim.lsp.config
    local opts = { noremap = true, silent = true }
    local on_attach = function(_, bufnr)
      opts.buffer = bufnr

      opts.desc = "Show line diagnostics"
      vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

      opts.desc = "Show documentation for what is under cursor"
      vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

      opts.desc = "Show LSP definition"
      vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions trim_text=true<cr>", opts)
    end

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

    -- nice icons
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end
  end,
}
