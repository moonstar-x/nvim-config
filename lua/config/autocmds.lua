local augroup = vim.api.nvim_create_augroup("user_config", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Reload files changed outside Neovim (git checkouts, an AI CLI in another pane, ...).
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup,
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd.checktime()
    end
  end,
})

-- Reopen files where you left off. Commit messages always start at the top.
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  callback = function(args)
    local name = vim.fs.basename(args.file)
    if name == "COMMIT_EDITMSG" or name == "git-rebase-todo" then
      return
    end
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(args.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Keep splits evenly sized when the terminal is resized.
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup,
  callback = function()
    local tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. tab)
  end,
})

-- Close help, quickfix and other read-only panels with q.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = {
    "help",
    "qf",
    "checkhealth",
    "gitsigns-blame",
    "dap-float",
    "neotest-output",
    "neotest-output-panel",
  },
  callback = function(args)
    vim.bo[args.buf].buflisted = false
    vim.keymap.set("n", "q", function()
      pcall(vim.cmd.close) -- fails harmlessly if it's the last window
    end, { buffer = args.buf, desc = "Close window" })
  end,
})
