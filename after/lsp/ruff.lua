return {
  on_attach = function(client)
    client.server_capabilities.hoverProvider = false -- leave hover to basedpyright
  end,
}
