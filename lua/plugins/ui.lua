return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "macchiato",
      custom_highlights = function(colors)
        local darken = require("catppuccin.utils.colors").darken
        local rainbow = { colors.red, colors.peach, colors.yellow, colors.green, colors.sapphire, colors.mauve }
        local groups = {}
        for i, color in ipairs(rainbow) do
          groups["SnacksIndent" .. i] = { fg = darken(color, 0.35, colors.base) }
        end
        return groups
      end,
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  {
    "nvim-mini/mini.icons",
    lazy = true,
    opts = {},
    init = function()
      -- Some plugins only know nvim-web-devicons. Let them use mini.icons
      -- instead, so we don't need a second icon plugin.
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts_extend = { "spec" },
    opts = {
      preset = "modern",
      spec = {},
    },
    keys = {
      -- All keymaps. The ones that only exist in this buffer (LSP, git, ...) carry the filetype's icon.
      -- (Showing only this buffer's keymaps left an empty popup in buffers that have none, like terminals.)
      {
        "<leader>?",
        function()
          require("which-key").show()
        end,
        desc = "Keymaps",
      },
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.showmode = false
    end,
    opts = {
      options = {
        theme = "catppuccin-nvim",
        globalstatus = true,
        component_separators = "",
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff" },
        lualine_c = { "diagnostics", { "filename", path = 1 } },
        lualine_x = {
          {
            function()
              local names = {}
              for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
                if client.name ~= "typos_lsp" then
                  table.insert(names, client.name)
                end
              end
              return " " .. table.concat(names, " ")
            end,
            cond = function()
              return #vim.lsp.get_clients({ bufnr = 0 }) > 0
            end,
          },
          "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      extensions = { "lazy", "mason", "oil", "trouble" },
    },
  },

  {
    "HiPhish/rainbow-delimiters.nvim",
    event = { "BufReadPost", "BufNewFile" },
  },
}
