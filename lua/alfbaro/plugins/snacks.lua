return {
  "folke/snacks.nvim",
  lazy = false,
  priority = 1000,
  keys = {
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Fuzzy find files in cwd" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Fuzzy find recent files" },
    { "<leader>fs", function() Snacks.picker.grep() end, desc = "Find string in cwd" },
    { "<leader>fc", function() Snacks.picker.grep_word() end, desc = "Find string under cursor in cwd" },
    { "<leader>ee", function() Snacks.explorer() end, desc = "Toggle file explorer" },
  },
  opts = {
    dashboard = {
        sections = {
    { section = "keys", gap = 1, padding = 1 },
    { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
    { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
    {
      pane = 2,
      icon = " ",
      title = "Git Status",
      section = "terminal",
      enabled = function()
        return Snacks.git.get_root() ~= nil
      end,
      cmd = "git status --short --branch --renames",
      height = 5,
      padding = 1,
      ttl = 5 * 60,
      indent = 3,
    },
    { section = "startup" },
  },
      preset = {
        -- stylua: ignore
        ---@type snacks.dashboard.Item[]
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
    },
    explorer = {
      replace_netrw = true,
    },
    picker = {
      win = {
        input = {
          keys = {
            ["<C-k>"] = { "list_up", mode = { "i", "n" } },
            ["<C-j>"] = { "list_down", mode = { "i", "n" } },
          },
        },
      },
      sources = {
        explorer = {
          layout = { preset = "sidebar", preview = false },
          hidden = true,
          ignored = true,
          exclude = { ".DS_Store" },
        },
      },
    },
  },
}
