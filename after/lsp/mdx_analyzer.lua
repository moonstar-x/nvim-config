return {
  before_init = function(_, config)
    -- Use the project's TypeScript, or fall back to the copy bundled with vtsls.
    local tsdk = require("lspconfig.util").get_typescript_server_path(config.root_dir)
    if tsdk == "" then
      tsdk = vim.env.MASON .. "/packages/vtsls/node_modules/@vtsls/language-server/node_modules/typescript/lib"
    end
    config.init_options.typescript.tsdk = tsdk
  end,
}
