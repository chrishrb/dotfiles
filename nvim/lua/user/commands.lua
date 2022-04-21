-- autoformat range or file with lsp
vim.cmd [[
  command! -range=% LspFormat <line1>,<line2>lua vim.lsp.buf.formatting_sync()
]]

-- open telescope buffer-selection
vim.api.nvim_add_user_command("Buffers", "Telescope buffers", { nargs = 0 })
