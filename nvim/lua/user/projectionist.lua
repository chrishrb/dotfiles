-- load projections file
if vim.g.loaded_vim_projectionist then
  return
end

Projectionist = {}
vim.g.loaded_vim_projectionist = 1

local base_dir = vim.fn.resolve(vim.fn.expand("<sfile>:p:h"))
local file = base_dir .. "/projections.json"

Projectionist.set_projections = function()
  local json = vim.fn.readfile(file)
  local dict = vim.fn['projectionist#json_parse'](json)
  vim.g.projectionist_heuristics = dict
end

vim.cmd([[
  augroup _projectionist-fix
    autocmd!
    autocmd BufEnter *
          \ if (&filetype ==# 'netrw' && !exists('b:projectionist')) ||
          \     &buftype !~# 'nofile\|quickfix' |
          \   call ProjectionistDetect(expand('%:p')) |
  augroup END

  augroup _projections
    autocmd!
    autocmd User ProjectionistDetect lua Projectionist.set_projections()
  augroup end
]])
