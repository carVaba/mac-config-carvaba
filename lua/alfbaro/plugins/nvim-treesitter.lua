 return {
  "nvim-treesitter/nvim-treesitter",
  commit = "90cd658",
   main = "nvim-treesitter",
  version = false, -- last release is way too old and doesn't work on Windows
  -- build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  init = function()
    local highlight = function(bufnr, lang)
        -------------------[ treesitter highlights ]-------------------------------
        if not vim.treesitter.language.add(lang) then
          return vim.notify(
            string.format("Treesitter cannot load parser for language: %s", lang),
            vim.log.levels.INFO,
            { title = "Treesitter" }
          )
        end
        vim.treesitter.start(bufnr)
      end

     vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          local ft = vim.bo.filetype
          local bt = vim.bo.buftype
          local buf = args.buf

          if bt ~= "" then
            return
          end -- don't run further.

          local ok, treesitter = pcall(require, "nvim-treesitter")
          if not ok then
            return
          end

          --------------------[ treesitter folds ]-------------------------------

          if ft == "javascriptreact" or ft == "typescriptreact" then
            vim.opt_local.foldmethod = "indent"
          else
            vim.opt_local.foldmethod = "expr"
            vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
          end

          vim.schedule(function()
            -- Only run normal if we're not in terminal mode
            if vim.fn.mode() ~= "t" then
              vim.cmd "silent! normal! zx"
            end
          end)

          ---------------------[ treesitter indent ]-------------------------------

          if not vim.tbl_contains({ "python", "html", "yaml", "markdown" }, ft) then
            vim.bo.indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
          end

          --------------------[ treesitter parsers ]-------------------------------
          if vim.fn.executable "tree-sitter" ~= 1 then
            vim.api.nvim_echo({
              {
                "tree-sitter CLI not found. Parsers cannot be installed.",
                "ErrorMsg",
              },
            }, true, {})
            return false
          end

          if not vim.treesitter.language.get_lang(ft) then
            return
          end

          if vim.list_contains(treesitter.get_installed(), ft) then
            highlight(buf, ft)
          elseif vim.list_contains(treesitter.get_available(), ft) then
            treesitter.install(ft):await(function()
              highlight(buf, ft)
            end)
          end
        end,
      })

  end,
  config = function(_, opts)
      local treesitter = require "nvim-treesitter"
      treesitter.setup(opts)
      if vim.fn.executable "tree-sitter" ~= 1 then
        vim.api.nvim_echo({
          {
            "tree-sitter CLI not found. Parsers cannot be installed.",
            "ErrorMsg",
          },
        }, true, {})
        return false
      end
      treesitter.install(opts.install)
    end,
  keys = {
    { "<c-space>", desc = "Increment Selection" },
    { "<bs>", desc = "Decrement Selection", mode = "x" },
  },
  ---@type TSConfig
  ---@diagnostic disable-next-line: missing-fields
  opts = {
    highlight = { enable = true },
    indent = { enable = true },
    ensure_installed = {
      "bash",
      "c",
      "diff",
      "json",
      "jsonc",
      "lua",
      "luadoc",
      "luap",
      "markdown",
      "markdown_inline",
      "printf",
      "python",
      "regex",
      "vim",
      "vimdoc",
      "xml",
      "yaml",
      "swift"
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-space>",
        node_incremental = "<C-space>",
        scope_incremental = false,
        node_decremental = "<bs>",
      },
    },
    textobjects = {
      move = {
        enable = true,
        goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
        goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
        goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
        goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
      },
    },
  },
  ---@param opts TSConfig
}
