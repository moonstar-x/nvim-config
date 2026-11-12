return {
  -- WakaTime coding stats. Reuses ~/.wakatime.cfg.
  {
    "wakatime/vim-wakatime",
    lazy = false,
  },

  -- Discord status ("Editing main.ts in my-project"). :Cord to see options.
  {
    "vyfor/cord.nvim",
    build = ":Cord update", -- downloads the small server binary
    event = "VeryLazy",
    opts = {},
  },

  -- CSV/TSV files shown as aligned columns.
  {
    "hat0uma/csvview.nvim",
    ft = { "csv", "tsv" },
    cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
    opts = {
      view = { display_mode = "border" },
    },
    config = function(_, opts)
      require("csvview").setup(opts)
      -- Turn the view on for every CSV/TSV buffer, including the one that loaded the plugin.
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("user_csvview", { clear = true }),
        pattern = { "csv", "tsv" },
        callback = function(args)
          require("csvview").enable(args.buf)
        end,
      })
      if vim.tbl_contains({ "csv", "tsv" }, vim.bo.filetype) then
        require("csvview").enable(0)
      end
    end,
    keys = {
      { "<leader>uv", "<cmd>CsvViewToggle<cr>", desc = "Toggle CSV column view" },
    },
  },

  -- Size of each imported package, shown at the end of the import line.
  -- Installs its own Node dependencies on first use; options go in vim.g.import_cost.
  {
    "barrettruth/import-cost.nvim",
    lazy = false, -- it hooks FileType itself, so loading it on FileType would miss the first file
  },

  -- Latest version of each dependency, shown at the end of its line in package.json.
  -- Uses the package manager whose lock file it finds (npm, yarn, pnpm, bun).
  {
    "vuki656/package-info.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    event = "BufReadPost package.json", -- before BufEnter, which is when it shows the versions
    opts = {
      highlights = {
        up_to_date = { link = "Comment" },
        outdated = { link = "DiagnosticWarn" },
        invalid = { link = "DiagnosticError" },
      },
      hide_up_to_date = true,
    },
    config = function(_, opts)
      require("package-info").setup(opts)
      vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("user_package_info", { clear = true }),
        pattern = "package.json",
        callback = function(args)
          local function map(lhs, cmd, desc)
            vim.keymap.set("n", lhs, "<cmd>PackageInfo" .. cmd .. "<cr>", { buffer = args.buf, desc = desc })
          end
          map("<leader>pt", "Toggle", "Toggle latest versions")
          map("<leader>pu", "Update", "Update this package")
          map("<leader>pd", "Delete", "Delete this package")
          map("<leader>pi", "Install", "Install a package")
          map("<leader>pv", "ChangeVersion", "Change version")
        end,
      })
    end,
  },

  -- Headings, lists, code blocks, tables and checkboxes rendered inside Markdown buffers.
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "mdx" },
    opts = {
      file_types = { "markdown", "mdx" },
      completions = { lsp = { enabled = true } }, -- callout/checkbox completions through blink
    },
    keys = {
      { "<leader>ur", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle Markdown rendering" },
    },
  },

  -- Keeps the current function/class signature pinned at the top of the window.
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    opts = { max_lines = 3, mode = "cursor" },
    config = function(_, opts)
      local context = require("treesitter-context")
      context.setup(opts)
      Snacks.toggle
        .new({
          name = "Sticky context",
          get = context.enabled,
          set = function(state)
            if state then
              context.enable()
            else
              context.disable()
            end
          end,
        })
        :map("<leader>ux")
    end,
  },

  -- Minimap with search, diagnostics and git changes marked. Off until toggled.
  {
    "nvim-mini/mini.map",
    opts = function()
      local map = require("mini.map")
      return {
        integrations = {
          map.gen_integration.builtin_search(),
          map.gen_integration.diagnostic(),
          map.gen_integration.gitsigns(),
        },
        symbols = { encode = map.gen_encode_symbols.dot("4x2") },
        window = { width = 15, winblend = 0 },
      }
    end,
    keys = {
      {
        "<leader>um",
        function()
          require("mini.map").toggle()
        end,
        desc = "Toggle minimap",
      },
      {
        "<leader>uM",
        function()
          require("mini.map").toggle_focus()
        end,
        desc = "Focus minimap",
      },
    },
  },

  {
    "folke/which-key.nvim",
    opts_extend = { "spec" },
    opts = {
      spec = {
        { "<leader>p", group = "packages (package.json)" },
      },
    },
  },
}
