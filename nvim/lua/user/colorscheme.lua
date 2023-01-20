require("catppuccin").setup {
    color_overrides = {
        all = {
            text = "#ffffff",
        },
        mocha = {
            base = "#1e1e2e",
        },
        frappe = {},
        macchiato = {},
        latte = {},
    }
}

vim.cmd [[
  try
    colorscheme catppuccin
  catch /^Vim\%((\a\+)\)\=:E185/
    colorscheme default
    set background=dark
  endtry
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
