local map = vim.keymap.set

-- Clear search highlighting with <Esc>.
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Open the lazy.nvim plugin manager UI.
map("n", "<leader>l", "<cmd>Lazy<CR>", { desc = "Lazy (plugin manager)" })

-- Save from any mode.
map({ "n", "i", "x", "s" }, "<C-s>", "<cmd>write<CR><Esc>", { desc = "Save file" })

-- Move lines up/down. On macOS the terminal must send Option as Alt (Meta).
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<CR>==", { desc = "Move line up" })
map("i", "<A-j>", "<Esc><cmd>move .+1<CR>==gi", { desc = "Move line down" })
map("i", "<A-k>", "<Esc><cmd>move .-2<CR>==gi", { desc = "Move line up" })
map("x", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<CR>gv=gv", { desc = "Move selection down" })
map("x", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<CR>gv=gv", { desc = "Move selection up" })

-- Keep the selection after indenting.
map("x", "<", "<gv", { desc = "Indent left" })
map("x", ">", ">gv", { desc = "Indent right" })

-- Jump to errors / warnings only ([d / ]d jump to any diagnostic).
local function diagnostic_jump(count, severity)
  return function()
    vim.diagnostic.jump({
      count = count * vim.v.count1,
      severity = vim.diagnostic.severity[severity],
      on_jump = function(_, bufnr)
        vim.diagnostic.open_float({ bufnr = bufnr, scope = "cursor", focus = false })
      end,
    })
  end
end
map("n", "]e", diagnostic_jump(1, "ERROR"), { desc = "Next error" })
map("n", "[e", diagnostic_jump(-1, "ERROR"), { desc = "Previous error" })
map("n", "]w", diagnostic_jump(1, "WARN"), { desc = "Next warning" })
map("n", "[w", diagnostic_jump(-1, "WARN"), { desc = "Previous warning" })

-- Splits and resizing. macOS uses Ctrl+arrows for Spaces/Mission Control unless that's turned off.
map("n", "<leader>-", "<C-w>s", { desc = "Split below" })
map("n", "<leader>|", "<C-w>v", { desc = "Split right" })
map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Taller window" })
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Shorter window" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Narrower window" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Wider window" })

-- Undo history as a tree (ships with Neovim 0.12, loaded on first use).
map("n", "<leader>U", function()
  vim.cmd.packadd("nvim.undotree")
  require("undotree").open()
end, { desc = "Undo tree" })

-- <leader>u toggles. which-key shows whether each one is on or off.
-- Toggles that belong to one plugin live with it (inline blame in git.lua, sticky context in extras.lua).
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  once = true,
  callback = function()
    -- Read by format_on_save in lua/plugins/formatting.lua.
    Snacks.toggle
      .new({
        name = "Format on save",
        get = function()
          return vim.g.autoformat ~= false
        end,
        set = function(state)
          vim.g.autoformat = state
        end,
      })
      :map("<leader>uf")
    Snacks.toggle
      .new({
        name = "Format on save (buffer)",
        get = function()
          return vim.b.autoformat ~= false
        end,
        set = function(state)
          vim.b.autoformat = state
        end,
      })
      :map("<leader>uF")

    Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
    Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
    Snacks.toggle.option("relativenumber", { name = "Relative numbers" }):map("<leader>uL")
    Snacks.toggle.line_number():map("<leader>ul")
    Snacks.toggle.diagnostics():map("<leader>ud")
    Snacks.toggle.inlay_hints():map("<leader>uh")
    Snacks.toggle.indent():map("<leader>ug")
    Snacks.toggle.treesitter():map("<leader>uT")
  end,
})
