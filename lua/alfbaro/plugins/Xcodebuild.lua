return {
    "wojciech-kulik/xcodebuild.nvim",
    dependencies = {
        "MunifTanjim/nui.nvim",
    },
    ft = "swift",
    keys = {
        { "<leader>xl", "<cmd>XcodebuildToggleLogs<cr>", desc = "Toggle Xcodebuild Logs" },
        { "<leader>xb", "<cmd>XcodebuildBuild<cr>", desc = "Build Project" },
        { "<leader>xr", "<cmd>XcodebuildBuildRun<cr>", desc = "Build & Run Project" },
        { "<leader>xt", "<cmd>XcodebuildTest<cr>", desc = "Run Tests" },
        { "<leader>xT", "<cmd>XcodebuildTestClass<cr>", desc = "Run This Test Class" },
        { "<leader>X", "<cmd>XcodebuildPicker<cr>", desc = "Show All Xcodebuild Actions" },
        { "<leader>xd", "<cmd>XcodebuildSelectDevice<cr>", desc = "Select Device" },
        { "<leader>xp", "<cmd>XcodebuildSelectTestPlan<cr>", desc = "Select Test Plan" },
        { "<leader>xc", "<cmd>XcodebuildToggleCodeCoverage<cr>", desc = "Toggle Code Coverage" },
        { "<leader>xC", "<cmd>XcodebuildShowCodeCoverageReport<cr>", desc = "Show Code Coverage Report" },
        { "<leader>xq", function() Snacks.picker.qflist() end, desc = "Show QuickFix List" },
    },
    config = function()
        require("xcodebuild").setup({
            code_coverage = {
                enabled = true,
            },
            integrations = {
                snacks_nvim = {
                    enabled = true,
                },
            },
        })
    end,
}
