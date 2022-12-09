local status_ok, mason = pcall(require, "mason")
if not status_ok then
	return
end

local status_ok_1, mason_lspconfig = pcall(require, "mason-lspconfig")
if not status_ok_1 then
	return
end

-- ensured installed by mason
local servers = {
  "cssls",
  "html",
  "jdtls",
  "jsonls",
  "sumneko_lua",
  "tsserver",
  "pyright",
  "yamlls",
  "bashls",
  "clangd",
  "rust_analyzer",
  "gopls",
  "texlab",
}

mason.setup()
mason_lspconfig.setup {
  ensure_installed = servers,
  automatic_installation = true,
}

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
  return
end

local opts = {}

-- not managed by mason
table.insert(servers, "dartls")
for _, server in pairs(servers) do
  opts = {
    on_attach = require("user.lsp.handlers").on_attach,
    capabilities = require("user.lsp.handlers").capabilities,
  }

  server = vim.split(server, "@")[1]

  if server == "jsonls" then
    local jsonls_opts = require "user.lsp.settings.jsonls"
    opts = vim.tbl_deep_extend("force", jsonls_opts, opts)
  end

  if server == "sumneko_lua" then
	 	local sumneko_opts = require("user.lsp.settings.sumneko_lua")
	 	opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
  end

  if server == "jdtls" then
    goto continue
  end

  if server == "dartls" then
    local dartls_opts = require "user.lsp.settings.dartls"
    local flutter_tools_status_ok, flutter_tools = pcall(require, "flutter-tools")
    if not flutter_tools_status_ok then
      return
    end

    flutter_tools.setup(dartls_opts)
    goto continue
  end

  if server == "rust_analyzer" then
    local rust_opts = require "user.lsp.settings.rust"
    local rust_tools_status_ok, rust_tools = pcall(require, "rust-tools")
    if not rust_tools_status_ok then
      return
    end

    rust_tools.setup(rust_opts)
    goto continue
  end

  if server == "gopls" then
    local go_opts = require "user.lsp.settings.go"
    local go_tools_status_ok, go_tools = pcall(require, "go")
    if not go_tools_status_ok then
      return
    end

    go_tools.setup(go_opts)
    goto continue
  end

  lspconfig[server].setup(opts)
  ::continue::
end
