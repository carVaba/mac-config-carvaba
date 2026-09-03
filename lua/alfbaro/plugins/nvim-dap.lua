return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "wojciech-kulik/xcodebuild.nvim",
    "rcarriga/nvim-dap-ui",
  },
  ft = "swift",
  keys = {
    { "<leader>dd", function() require("xcodebuild.integrations.dap").build_and_debug() end, desc = "Build & Debug" },
    { "<leader>dr", function() require("xcodebuild.integrations.dap").debug_without_build() end, desc = "Debug Without Building" },
    { "<leader>dt", function() require("xcodebuild.integrations.dap").debug_tests() end, desc = "Debug Tests" },
    { "<leader>dT", function() require("xcodebuild.integrations.dap").debug_class_tests() end, desc = "Debug Class Tests" },
    { "<leader>b", function() require("xcodebuild.integrations.dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
    { "<leader>B", function() require("xcodebuild.integrations.dap").toggle_message_breakpoint() end, desc = "Toggle Message Breakpoint" },
    { "<leader>dx", function() require("xcodebuild.integrations.dap").terminate_session() end, desc = "Terminate Debugger" },
  },
  config = function()
    require("xcodebuild.integrations.dap").setup()
  end,
}