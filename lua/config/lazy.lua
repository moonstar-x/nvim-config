local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Load every spec file in lua/plugins/ (one file per concern).
  spec = { { import = "plugins" } },

  -- Colorscheme to use while installing plugins on a fresh machine.
  install = { colorscheme = { "catppuccin", "habamax" } },

  -- Check for plugin updates in the background, without a popup each time.
  checker = { enabled = true, notify = false },

  -- Don't announce every config file change.
  change_detection = { notify = false },

  rocks = { enabled = true },

  performance = {
    rtp = {
      -- Built-in plugins we never use; disabling them speeds up startup.
      disabled_plugins = { "gzip", "tarPlugin", "tohtml", "zipPlugin" },
    },
  },
})
