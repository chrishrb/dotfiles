vim.cmd [[
  function! LSPFormat()
    echo "Hello"
  endfunction

  command! -range=% LspFormat <line1>,<line2>lua vim.lsp.buf.formatting_sync()
]]
