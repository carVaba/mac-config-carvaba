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
