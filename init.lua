require("alfbaro.lazy")
require("alfbaro.core")

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

require("hardtime").setup()
require("nvim-tree").setup()
require("lazydev").setup({
    library = { "nvim-dap-ui" },
})

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
