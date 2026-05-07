return {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local lint = require("lint")
        local fs_utils = require("alfbaro.utils.fs")

        lint.linters_by_ft = {
            swift = { "swiftlint" },
            python = { "pylint" },
        }

        local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

        local function try_lint_with_validation()
            local ft = vim.bo.filetype
            if ft == "swift" and not fs_utils.file_exists_in_root(".swiftlint.yml") then
                vim.notify(
                    "Swiftlint configuration file not found in project root. Skipping Swift linting",
                    vim.log.levels.INFO
                )
                return
            end
            lint.try_lint()
        end

        -- this can have another value "TextChanged"
        vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
            group = lint_augroup,
            callback = try_lint_with_validation,
        })

        vim.keymap.set("n", "<leader>ml", function()
            require("lint").try_lint()
        end, { desc = "Lint file" })
    end,
}
