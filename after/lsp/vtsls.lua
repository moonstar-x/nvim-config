local lang_settings = {
  updateImportsOnFileMove = { enabled = "always" },
  suggest = { completeFunctionCalls = true },
  inlayHints = {
    parameterNames = { enabled = "literals" },
    parameterTypes = { enabled = true },
    variableTypes = { enabled = false },
    propertyDeclarationTypes = { enabled = true },
    functionLikeReturnTypes = { enabled = true },
    enumMemberValues = { enabled = true },
  },
}

return {
  settings = {
    vtsls = {
      autoUseWorkspaceTsdk = true,
      experimental = {
        completion = { enableServerSideFuzzyMatch = true },
      },
    },
    typescript = lang_settings,
    javascript = lang_settings,
  },
}
