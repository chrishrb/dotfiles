local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- fetch packer_compiled
pcall(require, "packer_compiled")

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

-- Install your plugins here
return packer.startup({function(use)
  -- My plugins here
  use "wbthomason/packer.nvim"            -- Have packer manage itself
  use "nvim-lua/plenary.nvim"             -- Useful lua functions used in lots of plugins
  use "windwp/nvim-autopairs"             -- Autopairs, integrates with both cmp and treesitter
  use "numToStr/Comment.nvim"             -- Easily comment stuff
  use "kyazdani42/nvim-web-devicons"      -- Icons for nvim-tree
  use "kyazdani42/nvim-tree.lua"          -- neovim tree
  use {                                   -- nvim tree file renamings
    'antosha417/nvim-lsp-file-operations',
    requires = {
      { "nvim-lua/plenary.nvim" },
      { "kyazdani42/nvim-tree.lua" },
    }
  }
  use "akinsho/bufferline.nvim"           -- bufferline with different "tabs"
  use "moll/vim-bbye"                     -- delete buffers without closing your window or messing up your layout
  use "nvim-lualine/lualine.nvim"         -- line below for showing INSERT, branch, line number and problems
  use "ahmedkhalf/project.nvim"           -- project management with  vim
  use "lewis6991/impatient.nvim"          -- makes vim faster
  use "lukas-reineke/indent-blankline.nvim"   -- indent line
  use "goolord/alpha-nvim"                -- nice start screen
  use "folke/which-key.nvim"              -- whichkey help
  use({
    "kylechui/nvim-surround",             -- change surround e.g. ys{motion}{char}, ds{char}, cs{target}{replacement}
    tag = "*",
    config = function()
      require("nvim-surround").setup({})
    end
  })
  use "vim-scripts/BufOnly.vim"           -- delete all bufs except the one you are working
  use { 'alexghergh/nvim-tmux-navigation', config = function() -- tmux navigation
        require'nvim-tmux-navigation'.setup {
            disable_when_zoomed = false, -- defaults to false
            keybindings = {
                left = "<C-h>",
                down = "<C-j>",
                up = "<C-k>",
                right = "<C-l>",
                last_active = "<C-\\>",
                next = "<C-Space>",
            }
        }
    end
  }
  use 'stsewd/gx-extended.vim'            -- use gx to go to link

  -- Colorschemes
  use 'folke/tokyonight.nvim'             -- nice and simple theme

  -- cmp plugins
  use "hrsh7th/nvim-cmp"                  -- The completion plugin
  use "hrsh7th/cmp-buffer"                -- buffer completions
  use "hrsh7th/cmp-path"                  -- path completions
  use "hrsh7th/cmp-cmdline"               -- cmdline completions
  use "saadparwaiz1/cmp_luasnip"          -- snippet completions
  use "hrsh7th/cmp-nvim-lsp"              -- cmp for lsp

  -- snippets
  use "L3MON4D3/LuaSnip"                  -- snippet engine
  use "rafamadriz/friendly-snippets"      -- a bunch of snippets to use

  -- LSP
  use {                                   -- language server installer
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
  }
  use "tamago324/nlsp-settings.nvim"      -- language server settings defined in json for
  use "jose-elias-alvarez/null-ls.nvim"   -- for formatters and linters
  use 'mfussenegger/nvim-jdtls'           -- nvim java language server
  use {
    "folke/trouble.nvim",                 -- show diagnostics of current document/workspace
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup {}
    end
  }
  use {                                   -- debugging with nvim
    "mfussenegger/nvim-dap",              -- debugger
    "rcarriga/nvim-dap-ui",               -- ui for debugger
    "jayp0521/mason-nvim-dap.nvim",       -- mason adapter for dap
    "theHamsta/nvim-dap-virtual-text",    -- show line visual
  }
  use {                                   -- winbar
      "SmiteshP/nvim-navic",
      requires = "neovim/nvim-lspconfig"
  }
  use {
    "chrishrb/hover.nvim",               -- get documentation when pressing K
  }

  -- Telescope
  use "nvim-telescope/telescope.nvim"     -- fuzzy finder for vim

  -- Treesitter
  use {
    "nvim-treesitter/nvim-treesitter",    -- extended syntax highlighting
    run = ":TSUpdate",
  }
  use "JoosepAlviste/nvim-ts-context-commentstring"   -- comment with gcc and gc in every language
  use "windwp/nvim-ts-autotag"            -- autoclose and rename html tags

  -- Git
  use "lewis6991/gitsigns.nvim"           -- show changed lines in vim
  use 'tpope/vim-fugitive'                -- git

  -- other
  -- use "hashivim/vim-terraform" --terraform
  use {"jghauser/mkdir.nvim", config = function() require("mkdir") end}   -- creates automatically missing directories, like mkdir -p

  -- flutter
  use {'akinsho/flutter-tools.nvim', requires = 'nvim-lua/plenary.nvim'}  -- flutter all-in-one solution

  -- rust
  use 'simrat39/rust-tools.nvim' -- rust tools

  -- go
  use 'ray-x/go.nvim' -- go tools

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end,
config = {
  -- Move to lua dir so impatient.nvim can cache it
  compile_path = vim.fn.stdpath('config')..'/lua/packer_compiled.lua'
}})
