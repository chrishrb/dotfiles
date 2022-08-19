-- autoformat range or file with lsp
vim.cmd [[
  command! -range=% LspFormat <line1>,<line2>lua vim.lsp.buf.format(nil, 10000)
]]

-- open telescope buffer-selection
vim.api.nvim_create_user_command("Buffers", "Telescope buffers", { nargs = 0 })

-- use fixed bdelete instead of bd
vim.cmd [[
  cabbrev bd <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'Bdelete' : 'bd')<CR>
]]
