return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local lualine = require("lualine")
        local time_utils = require("alfbaro.utils.time")
       lualine.setup({
            options = {
                theme = 'solarized_dark'
            },
            disabled_filetypes = { "packer", "snacks_picker_list" },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch", "diff" },
                lualine_c = { },
                lualine_x = { { "fileformat", symbols = { unix = "" } } },
                lualine_y = { "progress" },
                lualine_z = { "location", time_utils.lima_time , " " }
            }
        })
    end, 
}
