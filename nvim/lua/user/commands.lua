-- autoformat range or file with lsp
vim.cmd [[
  command! -range=% LspFormat <line1>,<line2>lua vim.lsp.buf.format(nil, 10000)
]]

-- open telescope buffer-selection
vim.api.nvim_create_user_command("Buffers", "Telescope buffers", { nargs = 0 })
