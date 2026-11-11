return {
  before_init = function(_, config)
    config.settings.yaml.schemas = require("schemastore").yaml.schemas()
  end,
  settings = {
    redhat = { telemetry = { enabled = false } },
    yaml = {
      schemaStore = { enable = false, url = "" }, -- SchemaStore.nvim provides the schemas instead
      keyOrdering = false,
      validate = true,
    },
  },
}
