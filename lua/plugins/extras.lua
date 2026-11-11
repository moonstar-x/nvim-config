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
    keys = {
      { "<leader>ux", function() require("treesitter-context").toggle() end, desc = "Toggle sticky context" },
    },
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
      { "<leader>um", function() require("mini.map").toggle() end, desc = "Toggle minimap" },
      { "<leader>uM", function() require("mini.map").toggle_focus() end, desc = "Focus minimap" },
    },
  },
}
