-- This file contains local (installation specific) settings for nvim configuration.
--
-- If name of this file is 'site_settings_template.lua' then it is just a
-- template; it's modification would not affect anything. Copy it
-- to 'site_settings.lua' before doing any modifications.

site_settings.plugins_to_install = {
  "nvim-treesitter/nvim-treesitter",
  "nvim-treesitter/playground",

  -- "vimwiki/vimwiki",

  -- "akorshkov/ak_syntax",
  -- "akorshkov/ak_vimwiki",       -- my amendments to vimwiki

  -- "hrsh7th/nvim-cmp",           -- autocompletion

  -- "neovim/nvim-lspconfig",
  -- "williamboman/mason.nvim",    -- installer of language servers for lsp
  -- "williamboman/mason-lspconfig.nvim",  -- config lsp to use servers installed by mason

  -- "jose-elias-alvarez/null-ls.nvim",  -- helps to plug lsp formatters into lsp

  -- "tpope/vim-fugitive",

  -- "nvim-treesitter/nvim-treesitter",

  -- "nvim-telescope/telescope.nvim",   -- fuzzy finder
  "kyazdani42/nvim-tree.lua",        -- file manager
  -- "Einenlum/yaml-revealer",
}
