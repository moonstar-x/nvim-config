local js_filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" }

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
    },
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
      {
        "<leader>dB",
        function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end,
        desc = "Conditional breakpoint",
      },
      { "<leader>dc", function() require("dap").continue() end, desc = "Start / continue" },
      { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to cursor" },
      { "<leader>do", function() require("dap").step_over() end, desc = "Step over" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step into" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "Step out" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run last" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "REPL" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
      { "<leader>du", function() require("dapui").toggle({}) end, desc = "Toggle debug UI" },
      { "<leader>de", function() require("dapui").eval() end, mode = { "n", "x" }, desc = "Evaluate" },
    },
    config = function()
      local dap = require("dap")

      -- vscode-js-debug (installed by Mason) handles Node, Deno-free TS, Chrome and Edge.
      for _, adapter in ipairs({ "pwa-node", "pwa-chrome", "pwa-msedge" }) do
        dap.adapters[adapter] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = { command = "js-debug-adapter", args = { "${port}" } },
        }
      end
      -- launch.json files often say "node" / "chrome": map them to the pwa-* adapters.
      for _, alias in ipairs({ "node", "chrome" }) do
        dap.adapters[alias] = function(callback, config)
          config.type = "pwa-" .. alias
          callback(dap.adapters[config.type])
        end
      end

      local configs = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch current file (Node)",
          program = "${file}",
          cwd = "${workspaceFolder}",
          sourceMaps = true,
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach to Node process",
          processId = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
          sourceMaps = true,
        },
        {
          type = "pwa-chrome",
          request = "launch",
          name = "Launch Chrome",
          url = function() return vim.fn.input("URL: ", "http://localhost:3000") end,
          webRoot = "${workspaceFolder}",
          sourceMaps = true,
        },
      }
      for _, ft in ipairs(js_filetypes) do
        dap.configurations[ft] = configs
      end

      -- Configurations from .vscode/launch.json are picked up too; tell nvim-dap which files they apply to.
      local vscode = require("dap.ext.vscode")
      for _, type in ipairs({ "node", "chrome", "pwa-node", "pwa-chrome", "pwa-msedge" }) do
        vscode.type_to_filetypes[type] = js_filetypes
      end

      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DiagnosticHint" })
      vim.fn.sign_define("DapLogPoint", { text = "◉", texthl = "DiagnosticInfo" })
      vim.fn.sign_define("DapStopped", { text = "→", texthl = "DiagnosticWarn", linehl = "Visual" })
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "nvim-neotest/nvim-nio" },
    opts = {},
    config = function(_, opts)
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup(opts)
      -- Open the panels when a session starts, close them when it ends.
      dap.listeners.after.event_initialized.dapui = function() dapui.open({}) end
      dap.listeners.before.event_terminated.dapui = function() dapui.close({}) end
      dap.listeners.before.event_exited.dapui = function() dapui.close({}) end
    end,
  },

  {
    "theHamsta/nvim-dap-virtual-text",
    opts = {},
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts_extend = { "ensure_installed" },
    opts = { ensure_installed = { "js-debug-adapter" } },
  },

  {
    "folke/which-key.nvim",
    opts_extend = { "spec" },
    opts = {
      spec = {
        { "<leader>d", group = "debug" },
      },
    },
  },
}
