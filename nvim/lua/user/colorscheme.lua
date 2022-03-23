if not vim.g.tokyonight_style then
  vim.g.tokyonight_style = "night"
end

vim.cmd [[
  try
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

vim.opt.fillchars = {
  horiz = '━',
  horizup = '┻',
  horizdown = '┳',
  vert = '┃',
  vertleft  = '┫',
  vertright = '┣',
  verthoriz = '╋',
}
