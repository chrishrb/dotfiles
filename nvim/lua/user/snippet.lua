-- lua snippets
pcall(require, "snippets.lua.java")

-- vscode like snippets
require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_vscode").lazy_load({ paths = { "~/.config/nvim/lua/snippets/vscode/" }})
