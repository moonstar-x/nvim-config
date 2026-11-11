return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      picker = { enabled = true },
      explorer = { enabled = true, replace_netrw = false },
      notifier = { enabled = true },
      input = { enabled = true },
      indent = {
        enabled = true,
        indent = {
          hl = { "SnacksIndent1", "SnacksIndent2", "SnacksIndent3", "SnacksIndent4", "SnacksIndent5", "SnacksIndent6" },
        },
      },
      bigfile = { enabled = true },
      quickfile = { enabled = true },
    },
    keys = {
      -- Find
      { "<leader><space>", function() Snacks.picker.smart() end, desc = "Find files (smart)" },
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Files" },
      { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Git files" },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent files" },
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Config files" },
      -- Search
      { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep project" },
      { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Grep word under cursor", mode = { "n", "x" } },
      { "<leader>sb", function() Snacks.picker.lines() end, desc = "Lines in buffer" },
      { "<leader>sh", function() Snacks.picker.help() end, desc = "Help pages" },
      { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
      { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command history" },
      { "<leader>sr", function() Snacks.picker.resume() end, desc = "Resume last search" },
      { "<leader>sn", function() Snacks.picker.notifications() end, desc = "Notification history" },
      { "<leader>uc", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
      -- Explorer
      { "<leader>e", function() Snacks.explorer() end, desc = "File explorer" },
    },
  },

  {
    "folke/which-key.nvim",
    opts_extend = { "spec" },
    opts = {
      spec = {
        { "<leader>f", group = "find" },
        { "<leader>s", group = "search" },
        { "<leader>u", group = "ui" },
      },
    },
  },

  {
    "stevearc/oil.nvim",
    lazy = false,
    opts = {
      view_options = { show_hidden = true },
      keymaps = {
        -- Free these for vim-tmux-navigator.
        ["<C-h>"] = false,
        ["<C-l>"] = false,
        ["gR"] = "actions.refresh",
      },
    },
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
    },
  },

  {
    "christoomey/vim-tmux-navigator",
    cmd = { "TmuxNavigateLeft", "TmuxNavigateDown", "TmuxNavigateUp", "TmuxNavigateRight", "TmuxNavigatePrevious" },
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Window left" },
      { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Window down" },
      { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Window up" },
      { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Window right" },
      { "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>", desc = "Previous window" },
    },
  },
}
