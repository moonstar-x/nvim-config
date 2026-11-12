return {
  -- Task runner: npm/yarn/pnpm scripts, Makefiles, .vscode/tasks.json and shell commands,
  -- with output kept per task. Also runs launch.json's preLaunchTask for nvim-dap.
  {
    "stevearc/overseer.nvim",
    cmd = { "OverseerOpen", "OverseerClose", "OverseerToggle", "OverseerRun", "OverseerShell", "OverseerTaskAction" },
    opts = {},
    keys = {
      { "<leader>oo", "<cmd>OverseerRun<cr>", desc = "Run a task" },
      { "<leader>ow", "<cmd>OverseerToggle!<cr>", desc = "Task list" },
      { "<leader>os", "<cmd>OverseerShell<cr>", desc = "Run a shell command" },
      { "<leader>oa", "<cmd>OverseerTaskAction<cr>", desc = "Task action" },
      {
        "<leader>ol",
        function()
          local overseer = require("overseer")
          local tasks = overseer.list_tasks({
            status = { overseer.STATUS.SUCCESS, overseer.STATUS.FAILURE, overseer.STATUS.CANCELED },
            sort = require("overseer.task_list").sort_finished_recently,
          })
          if vim.tbl_isempty(tasks) then
            vim.notify("No finished tasks to restart", vim.log.levels.WARN)
          else
            overseer.run_action(tasks[1], "restart")
          end
        end,
        desc = "Restart last task",
      },
    },
  },

  {
    "folke/which-key.nvim",
    opts_extend = { "spec" },
    opts = {
      spec = {
        { "<leader>o", group = "tasks" },
      },
    },
  },
}
