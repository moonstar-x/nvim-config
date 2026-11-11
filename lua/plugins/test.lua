return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "marilari88/neotest-vitest",
      "nvim-neotest/neotest-jest",
    },
    opts = function()
      local lib = require("neotest.lib")

      -- Both adapters claim any folder with a package.json. When both claim the same project they race,
      -- and a run can come back with every test "skipped". Only claim projects that use the runner.
      local function only_for(runner, adapter)
        local root = adapter.root
        adapter.root = function(path)
          local dir = root(path)
          if not dir then
            return nil
          end
          for name in vim.fs.dir(dir) do
            if name:match("^" .. runner .. "%.config%.") then
              return dir
            end
          end
          local ok, pkg = pcall(function()
            return vim.json.decode(lib.files.read(dir .. "/package.json"))
          end)
          if ok and type(pkg) == "table" then
            if pkg[runner] then
              return dir -- e.g. a "jest" config block
            end
            for _, field in ipairs({ "dependencies", "devDependencies" }) do
              if type(pkg[field]) == "table" and pkg[field][runner] then
                return dir
              end
            end
          end
        end
        return adapter
      end

      return {
        adapters = {
          only_for("vitest", require("neotest-vitest")),
          only_for("jest", require("neotest-jest")({})),
        },
        status = { virtual_text = true },
        output = { open_on_run = false },
        quickfix = { open = false },
      }
    end,
    keys = {
      { "<leader>tr", function() require("neotest").run.run() end, desc = "Run nearest test" },
      { "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run file" },
      { "<leader>tT", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Run all tests" },
      { "<leader>tl", function() require("neotest").run.run_last() end, desc = "Run last" },
      { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug nearest test" },
      { "<leader>tw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, desc = "Watch file" },
      { "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop" },
      { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Summary panel" },
      {
        "<leader>to",
        function() require("neotest").output.open({ enter = true, auto_close = true }) end,
        desc = "Test output",
      },
      { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Output panel" },
      { "]T", function() require("neotest").jump.next({ status = "failed" }) end, desc = "Next failed test" },
      { "[T", function() require("neotest").jump.prev({ status = "failed" }) end, desc = "Previous failed test" },
    },
  },

  {
    "folke/which-key.nvim",
    opts_extend = { "spec" },
    opts = {
      spec = {
        { "<leader>t", group = "test" },
      },
    },
  },
}
