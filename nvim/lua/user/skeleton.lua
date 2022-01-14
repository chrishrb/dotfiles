local status_ok, luasnip = pcall(require, "luasnip")
if not status_ok then
  return
end

vim.cmd([[
  augroup _skeleton
    autocmd User ProjectionistDetect lua Skeleton.insert_skeleton()
    " autocmd BufNewFile * silent! lua Skeleton.insert_skeleton()
  augroup END
]])

Skeleton = {}

local try_insert = function(skel)
  vim.fn.execute("normal! i " .. skel .. " ")
  if not luasnip.expand_or_jumpable() then
    vim.cmd("silent! undo")
    return false
  end

  -- enter insert mode
  luasnip.expand_or_jump()
  return true
end


Skeleton.insert_skeleton = function()
  local filename = vim.fn.expand("%")

  if not (vim.fn.line('$') == 1 and vim.fn.getline('$') == '') or vim.fn.filereadable(filename) == 1 then
    return
  end

  if vim.api.nvim_eval('exists("b:projectionist")') then
    -- loop through projections with 'skeleton' key and try each one until
    -- the snippet expands
    local tbl = vim.fn['projectionist#query_scalar']('skeleton')

    for key, value in ipairs(tbl) do
      if try_insert(value) then
        return
      end
    end
  end
end

