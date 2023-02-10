-- manage my plugins using packer.nvim plugin manager =====

local install_path = vim.fn.stdpath( "data" ) .. "/site/pack/packer/start/packer.nvim"

if vim.fn.empty( vim.fn.glob( install_path ) ) > 0 then
  vim.fn.system({
    "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
  print("Installing packer; close and reopen neovim")
  vim.cmd("packadd packer.nvim")
end

local status_ok, packer = pcall(require, "packer")

if not status_ok then
  vim.notity("Oops, failed to load 'packer' plugin manager")
  return
end

packer.startup(function(use)
  use "wbthomason/packer.nvim"     -- the plugin manager itself

  use "nvim-lua/plenary.nvim"      -- library, required by many others (null-ls)

  use "vimwiki/vimwiki"

  use "akorshkov/ak_syntax"
  use "akorshkov/ak_vimwiki"       -- my amendments to vimwiki

  use "hrsh7th/nvim-cmp"           -- autocompletion
  use "hrsh7th/cmp-buffer"
  use "hrsh7th/cmp-nvim-lsp"
  use "L3MON4D3/LuaSnip"           -- nvim-cmp requires a snippet engine. Here it is.

  use "neovim/nvim-lspconfig"
  use "williamboman/mason.nvim"    -- installer of language servers for lsp
  use "williamboman/mason-lspconfig.nvim"  -- config lsp to use servers installed by mason

  use "jose-elias-alvarez/null-ls.nvim"  -- helps to plug lsp formatters in lsp

  use "tpope/vim-fugitive"

  use {
    "nvim-treesitter/nvim-treesitter",
    run = ':TSUpdate',
  }

  use "nvim-telescope/telescope.nvim"   -- fuzzy finder
  use "kyazdani42/nvim-tree.lua"   -- file manager
  use "Einenlum/yaml-revealer"
end)

-- setup installed plugins
local nvimtree_ok, nvimtree = pcall(require, 'nvim-tree')
if nvimtree_ok then
  nvimtree.setup()
end
