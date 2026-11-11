-- General keymaps. Plugin-specific keymaps live with their plugin spec in lua/plugins/.

local map = vim.keymap.set

-- Clear search highlighting with <Esc>.
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Open the lazy.nvim plugin manager UI.
map("n", "<leader>l", "<cmd>Lazy<CR>", { desc = "Lazy (plugin manager)" })
