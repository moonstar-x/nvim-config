return {
  -- Claude Code's IDE integration: Claude sees your selection, and its edits open as diffs here.
  -- Run `claude` in any terminal while Neovim is open (or <leader>acc) and it connects automatically.
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    cmd = { "ClaudeCode", "ClaudeCodeFocus", "ClaudeCodeSend", "ClaudeCodeAdd", "ClaudeCodeTreeAdd" },
    event = "VeryLazy", -- start the integration server early so an external `claude` can find it
    opts = {
      terminal = { split_side = "right", split_width_percentage = 0.4 },
    },
    keys = {
      { "<leader>acc", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>acf", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>acr", "<cmd>ClaudeCode --resume<cr>", desc = "Resume a session" },
      { "<leader>acC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue last session" },
      { "<leader>acm", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select model" },
      { "<leader>acb", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add this file" },
      { "<leader>acs", "<cmd>ClaudeCodeSend<cr>", mode = "x", desc = "Send selection" },
      { "<leader>acs", "<cmd>ClaudeCodeTreeAdd<cr>", ft = { "oil", "snacks_picker_list" }, desc = "Add file" },
      { "<leader>acy", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>acn", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Reject diff" },
    },
  },

  -- A terminal for any AI CLI (Codex, Claude, ...) with keys to send it context.
  {
    "folke/sidekick.nvim",
    opts = {
      nes = { enabled = false }, -- next-edit suggestions need GitHub Copilot
    },
    keys = {
      {
        "<c-.>",
        function()
          require("sidekick.cli").toggle()
        end,
        mode = { "n", "t", "i", "x" },
        desc = "Toggle AI CLI",
      },
      {
        "<leader>aa",
        function()
          require("sidekick.cli").toggle()
        end,
        desc = "Toggle AI CLI",
      },
      {
        "<leader>as",
        function()
          require("sidekick.cli").select()
        end,
        desc = "Select AI CLI",
      },
      {
        "<leader>ax",
        function()
          require("sidekick.cli").toggle({ name = "codex", focus = true })
        end,
        desc = "Codex",
      },
      {
        "<leader>ad",
        function()
          require("sidekick.cli").close()
        end,
        desc = "Detach CLI session",
      },
      {
        "<leader>at",
        function()
          require("sidekick.cli").send({ msg = "{this}" })
        end,
        mode = { "n", "x" },
        desc = "Send this",
      },
      {
        "<leader>af",
        function()
          require("sidekick.cli").send({ msg = "{file}" })
        end,
        desc = "Send file",
      },
      {
        "<leader>av",
        function()
          require("sidekick.cli").send({ msg = "{selection}" })
        end,
        mode = "x",
        desc = "Send selection",
      },
      {
        "<leader>ap",
        function()
          require("sidekick.cli").prompt()
        end,
        mode = { "n", "x" },
        desc = "Pick a prompt",
      },
    },
  },

  -- Manage MCP servers (UI: :MCPHub). Also serves them, plus Neovim itself, on one endpoint
  -- that Claude Code or Codex can connect to: http://localhost:37373/mcp
  {
    "ravitemer/mcphub.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    build = "bundled_build.lua", -- installs mcp-hub inside the plugin folder, no global npm install
    cmd = "MCPHub",
    opts = { use_bundled_binary = true },
    keys = {
      { "<leader>aM", "<cmd>MCPHub<cr>", desc = "MCP Hub" },
    },
  },

  {
    "folke/which-key.nvim",
    opts_extend = { "spec" },
    opts = {
      spec = {
        { "<leader>a", group = "ai", mode = { "n", "x" } },
        { "<leader>ac", group = "claude code", mode = { "n", "x" } },
      },
    },
  },
}
