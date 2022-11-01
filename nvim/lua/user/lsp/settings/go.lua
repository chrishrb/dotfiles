return {
  lsp_cfg = {
    capabilities = require("user.lsp.handlers").capabilities,
  },
  lsp_on_attach = require("user.lsp.handlers").on_attach,

  luasnip = true,
}
