vim.filetype.add({
  extension = {
    mdx = "mdx",
    mjml = "html",
  },
  filename = {
    ["compose.yml"] = "yaml.docker-compose",
    ["compose.yaml"] = "yaml.docker-compose",
    ["docker-compose.yml"] = "yaml.docker-compose",
    ["docker-compose.yaml"] = "yaml.docker-compose",
  },
  pattern = {
    ["compose%..+%.ya?ml"] = "yaml.docker-compose", -- compose.override.yml, compose.prod.yaml, ...
    ["docker%-compose%..+%.ya?ml"] = "yaml.docker-compose",
  },
})

-- Reuse existing Treesitter parsers for filetypes that don't have their own.
vim.treesitter.language.register("bash", "env")
vim.treesitter.language.register("markdown", "mdx")
vim.treesitter.language.register("properties", "jproperties")
vim.treesitter.language.register("yaml", "yaml.docker-compose")
