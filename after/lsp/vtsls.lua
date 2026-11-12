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

-- Apply one of vtsls's whole-file source actions. Only vtsls's own action counts,
-- so Biome's or ESLint's version of the same action doesn't open a picker.
local function source_action(client, kind)
  return function()
    vim.lsp.buf.code_action({
      apply = true,
      context = { only = { kind }, diagnostics = {} },
      filter = function(_, client_id)
        return client_id == client.id
      end,
    })
  end
end

-- Jump to the .js/.ts source instead of the .d.ts declaration.
local function goto_source_definition(client, buf)
  local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
  client:request("workspace/executeCommand", {
    command = "typescript.goToSourceDefinition",
    arguments = { params.textDocument.uri, params.position },
  }, function(err, result)
    if err or not result or vim.tbl_isempty(result) then
      vim.notify("No source definition found", vim.log.levels.WARN)
    elseif #result == 1 then
      vim.lsp.util.show_document(result[1], client.offset_encoding, { focus = true })
    else
      vim.fn.setqflist({}, " ", {
        title = "Source definitions",
        items = vim.lsp.util.locations_to_items(result, client.offset_encoding),
      })
      vim.cmd("botright copen")
    end
  end, buf)
end

return {
  -- Runs after the LspAttach keymaps in lua/plugins/lsp.lua, so gD here replaces "go to declaration".
  on_attach = function(client, buf)
    local function map(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = buf, desc = desc })
    end
    map("<leader>co", source_action(client, "source.organizeImports"), "Organize imports")
    map("<leader>cM", source_action(client, "source.addMissingImports.ts"), "Add missing imports")
    map("<leader>cu", source_action(client, "source.removeUnused.ts"), "Remove unused imports")
    map("<leader>cD", source_action(client, "source.fixAll.ts"), "Fix all diagnostics")
    map("gD", function()
      goto_source_definition(client, buf)
    end, "Go to source definition")
  end,
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
