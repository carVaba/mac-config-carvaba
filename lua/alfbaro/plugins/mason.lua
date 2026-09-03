return {
    "mason-org/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    cmd = "Mason",
    opts = {
        ensure_installed = { "lua_ls", "pyright" },
    },
    dependencies = {
        { "mason-org/mason.nvim", opts = {
            ui = {
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗"
                }
             }
            }
        },
        "neovim/nvim-lspconfig",
    },
}