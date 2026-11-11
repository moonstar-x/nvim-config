local parsers = {
  "typescript",
  "tsx",
  "javascript",
  "jsdoc",
  "json",
  "yaml",
  "toml",
  "lua",
  "luadoc",
  "markdown",
  "markdown_inline",
  "html",
  "css",
  "graphql",
  "nginx",
  "dockerfile",
  "python",
  "bash",
  "properties",
  "gitignore",
  "regex",
  "vim",
  "vimdoc",
  "query",
  "diff",
  "gitcommit",
  "git_config",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install(parsers)

      -- The main branch doesn't enable anything by itself: start highlighting
      -- and indentation for every buffer that has a parser.
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
        callback = function(args)
          if pcall(vim.treesitter.start, args.buf) then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      move = { set_jumps = true },
    },
    config = function(_, opts)
      require("nvim-treesitter-textobjects").setup(opts)

      -- Selecting (af, ic, ...) is done by mini.ai in editor.lua, using these same queries.
      local move = require("nvim-treesitter-textobjects.move")

      -- ]f/[f and ]k/[k: next/previous function and class (]c is left for git hunks).
      local moves = { f = { "@function.outer", "function" }, k = { "@class.outer", "class" } }
      for key, obj in pairs(moves) do
        local query, name = obj[1], obj[2]
        vim.keymap.set({ "n", "x", "o" }, "]" .. key, function()
          move.goto_next_start(query, "textobjects")
        end, { desc = "Next " .. name })
        vim.keymap.set({ "n", "x", "o" }, "[" .. key, function()
          move.goto_previous_start(query, "textobjects")
        end, { desc = "Previous " .. name })
      end
    end,
  },

  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },

  {
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
