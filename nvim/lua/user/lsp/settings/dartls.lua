return {
  lsp = {
    color = {
      enabled = true,
    },
    on_attach = require("user.lsp.handlers").on_attach,
    capabilities = require("user.lsp.handlers").capabilities,
    snippets = {
      enableSnippets = true,
    }
  }
}
