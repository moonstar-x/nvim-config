local prettier_configs = {
  ".prettierrc", ".prettierrc.json", ".prettierrc.json5", ".prettierrc.yaml", ".prettierrc.yml",
  ".prettierrc.toml", ".prettierrc.js", ".prettierrc.cjs", ".prettierrc.mjs", ".prettierrc.ts",
  ".prettierrc.cts", ".prettierrc.mts", "prettier.config.js", "prettier.config.cjs",
  "prettier.config.mjs", "prettier.config.ts", "prettier.config.cts", "prettier.config.mts",
}

-- Prettier only runs in projects that opted in: a Prettier config file, or a "prettier" key in package.json.
local function has_prettier_config(_, ctx)
  if vim.fs.find(prettier_configs, { path = ctx.dirname, upward = true })[1] then
    return true
  end
  local pkg = vim.fs.find("package.json", { path = ctx.dirname, upward = true })[1]
  if not pkg then
    return false
  end
  local ok, json = pcall(vim.json.decode, table.concat(vim.fn.readfile(pkg), "\n"))
  return ok and type(json) == "table" and json.prettier ~= nil
end

local function has_biome_config(_, ctx)
  return vim.fs.find({ "biome.json", "biome.jsonc" }, { path = ctx.dirname, upward = true })[1] ~= nil
end

local function has_deno_config(_, ctx)
  return vim.fs.find({ "deno.json", "deno.jsonc" }, { path = ctx.dirname, upward = true })[1] ~= nil
end

-- The first one the project is configured for wins: Deno, then Biome, then Prettier.
local js = { "deno_fmt", "biome-check", "prettierd", stop_after_first = true }
local biome_or_prettier = { "biome-check", "prettierd", stop_after_first = true }

return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    keys = {
      { "<leader>cf", function() require("conform").format() end, mode = { "n", "x" }, desc = "Format" },
      {
        "<leader>uf",
        function()
          vim.g.autoformat = vim.g.autoformat == false
          vim.notify("Format on save " .. (vim.g.autoformat and "enabled" or "disabled"))
        end,
        desc = "Toggle format on save",
      },
      {
        "<leader>uF",
        function()
          vim.b.autoformat = vim.b.autoformat == false
          vim.notify("Format on save " .. (vim.b.autoformat and "enabled" or "disabled") .. " for this buffer")
        end,
        desc = "Toggle format on save (buffer)",
      },
    },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" -- gq uses conform too
    end,
    opts = {
      formatters_by_ft = {
        javascript = js,
        javascriptreact = js,
        typescript = js,
        typescriptreact = js,
        json = js,
        jsonc = js,
        css = biome_or_prettier,
        graphql = biome_or_prettier,
        scss = { "prettierd" },
        less = { "prettierd" },
        html = { "prettierd" },
        yaml = { "prettierd" },
        markdown = { "prettierd" },
        mdx = { "prettierd" },
        lua = { "stylua" },
        python = { "ruff_format" },
        sh = { "shfmt" },
        bash = { "shfmt" },
      },
      formatters = {
        deno_fmt = {
          condition = has_deno_config,
          cwd = function(_, ctx)
            return vim.fs.root(ctx.dirname, { "deno.json", "deno.jsonc" }) -- so deno finds its config
          end,
        },
        ["biome-check"] = { condition = has_biome_config },
        prettierd = { condition = has_prettier_config },
        shfmt = { prepend_args = { "-i", "2", "-ci" } }, -- 2-space indent, indent case branches
      },
      format_on_save = function(buf)
        if vim.g.autoformat == false or vim.b[buf].autoformat == false then
          return
        end
        -- ESLint's fixes run first (only where the ESLint server is attached), then the formatter.
        return {
          timeout_ms = 3000,
          lsp_format = "first",
          filter = function(client)
            return client.name == "eslint"
          end,
        }
      end,
    },
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts_extend = { "ensure_installed" },
    opts = { ensure_installed = { "biome", "prettierd", "stylua", "shfmt", "hadolint" } },
  },

  -- Linters that don't run as language servers. ESLint, Ruff and ShellCheck already come through LSP.
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile", "BufWritePost" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        dockerfile = { "hadolint" },
      }
      vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("user_lint", { clear = true }),
        callback = function()
          lint.try_lint()
        end,
      })
      lint.try_lint()
    end,
  },
}
