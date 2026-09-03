-- Standard Unicode emoji built from explicit UTF-8 bytes (not typed
-- directly, since multi-byte codepoints don't survive as plain text here).
-- Emoji are used instead of Nerd Font private-use glyphs because their
-- codepoints are stable across font versions and render in full color.
local icon_coffee = string.char(0xE2, 0x98, 0x95) -- U+2615 hot beverage
local icon_camera = string.char(0xF0, 0x9F, 0x93, 0xB7) -- U+1F4F7 camera
local icon_phone = string.char(0xF0, 0x9F, 0x93, 0xB1) -- U+1F4F1 mobile phone (iOS dev)

-- Dashboard menu icons, same reasoning: real emoji instead of Nerd Font
-- private-use glyphs, which weren't rendering (blank) in this terminal.
local icon_find_file = string.char(0xF0, 0x9F, 0x94, 0x8D) -- U+1F50D magnifying glass tilted right
local icon_new_file = string.char(0xF0, 0x9F, 0x93, 0x84) -- U+1F4C4 page facing up
local icon_find_text = string.char(0xF0, 0x9F, 0x94, 0x8E) -- U+1F50E magnifying glass tilted left
local icon_recent = string.char(0xF0, 0x9F, 0x93, 0x82) -- U+1F4C2 open file folder
local icon_config = string.char(0xE2, 0x9A, 0x99) -- U+2699 gear
local icon_session = string.char(0xF0, 0x9F, 0x92, 0xBE) -- U+1F4BE floppy disk
local icon_lazy = string.char(0xF0, 0x9F, 0x92, 0xA4) -- U+1F4A4 zzz (sleep)
local icon_quit = string.char(0xF0, 0x9F, 0x9A, 0xAA) -- U+1F6AA door

local dashboard_header = table.concat({
  "",
  "",
  "        " .. icon_coffee .. "    " .. icon_camera .. "    " .. icon_phone,
  "",
  "            nvim-carvaba",
  "",
  "     coffee \194\183 code \194\183 photography",
  "",
}, "\n")

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
    { section = "header" },
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
        header = dashboard_header,
        -- stylua: ignore
        ---@type snacks.dashboard.Item[]
        keys = {
          { icon = icon_find_file .. " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = icon_new_file .. " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = icon_find_text .. " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = icon_recent .. " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = icon_config .. " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = icon_session .. " ", key = "s", desc = "Restore Session", section = "session" },
          { icon = icon_lazy .. " ", key = "l", desc = "Lazy", action = ":Lazy" },
          { icon = icon_quit .. " ", key = "q", desc = "Quit", action = ":qa" },
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
