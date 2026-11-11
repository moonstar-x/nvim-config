-- Autocommands: code that runs automatically on editor events.

-- One group for all of them, cleared on reload so nothing is registered twice.
local augroup = vim.api.nvim_create_augroup("user_config", { clear = true })

-- Briefly highlight text after yanking it.
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.hl.on_yank()
  end,
})
