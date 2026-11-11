return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = { "rafamadriz/friendly-snippets" },
    opts_extend = { "sources.default" },
    opts = {
      -- Tab accepts, like VS Code. Also: <C-space> open, <C-e> close,
      -- <C-n>/<C-p> or arrows to move, <C-b>/<C-f> scroll docs, <C-k> signature.
      keymap = { preset = "super-tab" },
      appearance = { nerd_font_variant = "mono" },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
        menu = { border = "rounded" },
      },
      signature = { enabled = true, window = { border = "rounded" } },
      sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
        },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
  },

  -- Load blink before any server starts, so servers learn what completion features we support.
  {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp" },
  },
}
