vim.cmd [[
  try
    let g:tokyonight_style = "night"
    colorscheme tokyonight
  catch /^Vim\%((\a\+)\)\=:E185/
    colorscheme default
    set background=dark
  endtry


  augroup JupyterCellHighlighting
    autocmd!
    autocmd BufEnter *.py syn match IPythonCell /#%%.*\|# %%.*\|##.*/
  augroup END

  highlight default link IPythonCell Folded
]]
