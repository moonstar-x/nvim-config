-- Servers to enable, mapped to the Mason package that provides them (false = installed some other way).
-- Their settings come from nvim-lspconfig, plus our overrides in after/lsp/<name>.lua (after/ so ours win).
local servers = {
  -- TypeScript / JavaScript
  vtsls = "vtsls",
  eslint = "eslint-lsp",
  biome = "biome", -- only starts in projects with biome.json
  denols = false, -- Homebrew's deno; only starts in projects with deno.json
  -- Web
  html = "html-lsp", -- also covers .mjml (treated as HTML)
  cssls = "css-lsp", -- CSS, SCSS, Less
  -- Data and docs
  jsonls = "json-lsp",
  yamlls = "yaml-language-server",
  graphql = "graphql-language-service-cli",
  mdx_analyzer = "mdx-analyzer",
  marksman = "marksman",
  -- Infrastructure
  dockerls = "dockerfile-language-server",
  docker_compose_language_service = "docker-compose-language-service",
  nginx_language_server = "nginx-language-server",
  -- Other languages
  basedpyright = "basedpyright",
  ruff = "ruff",
  bashls = "bash-language-server",
  lua_ls = "lua-language-server",
  typos_lsp = "typos-lsp",
}

local tools = { "shellcheck" } -- bashls runs shellcheck for its diagnostics
for _, pkg in pairs(servers) do
  if pkg then
    table.insert(tools, pkg)
  end
end

return {
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    opts = {},
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    lazy = false, -- installs anything missing at startup
    opts_extend = { "ensure_installed" }, -- other plugin files add their own tools
    opts = { ensure_installed = tools },
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason-org/mason.nvim" },
    config = function()
      vim.diagnostic.config({
        severity_sort = true,
        virtual_text = { spacing = 2, source = "if_many" },
        float = { border = "rounded", source = "if_many" },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.INFO] = "󰋽 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
          },
        },
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
        callback = function(args)
          local function map(lhs, rhs, desc, mode)
            vim.keymap.set(mode or "n", lhs, rhs, { buffer = args.buf, desc = desc })
          end
          -- Built in already: K hover, grn rename, gra code action, grr references,
          -- gri implementation, gO document symbols, [d / ]d diagnostics.
          map("gd", function()
            Snacks.picker.lsp_definitions()
          end, "Go to definition")
          map("gD", vim.lsp.buf.declaration, "Go to declaration")
          map("gy", function()
            Snacks.picker.lsp_type_definitions()
          end, "Go to type definition")
          map("<leader>ss", function()
            Snacks.picker.lsp_symbols()
          end, "Symbols in file")
          map("<leader>sS", function()
            Snacks.picker.lsp_workspace_symbols()
          end, "Symbols in workspace")
          map("<leader>sd", function()
            Snacks.picker.diagnostics()
          end, "Diagnostics")
          map("<leader>cd", vim.diagnostic.open_float, "Line diagnostics")
          map("<leader>uh", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = args.buf }), { bufnr = args.buf })
          end, "Toggle inlay hints")
        end,
      })

      vim.lsp.enable(vim.tbl_keys(servers))
    end,
  },

  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "snacks.nvim", words = { "Snacks" } },
      },
    },
  },

  -- JSON/YAML schemas for jsonls and yamlls (see after/lsp/jsonls.lua and after/lsp/yamlls.lua).
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
    version = false,
  },

  {
    "folke/which-key.nvim",
    opts_extend = { "spec" },
    opts = {
      spec = {
        { "<leader>c", group = "code" },
      },
    },
  },
}
