-- This file contains local (installation specific) settings for nvim configuration.
--
-- If name of this file is 'site_settings_template.lua' then it is just a
-- template; it's modification would not affect anything. Copy it
-- to 'site_settings.lua' before doing any modifications.

-- plugins_to_install - table of plugins to install
-- Plugins will be installed by Packer.
-- Packer arguments for each plugin may be specified, but in most cases
-- it is not required - default arguments for plugins I usually use are
-- specified in lua/ak/plugins.lua.
Site_settings.plugins_to_install = {
  -- "nvim-treesitter/nvim-treesitter",
  -- "nvim-treesitter/playground",

  -- "akorshkov/vim-akn",
  -- "akorshkov/vim-ak-colors",
  -- "vimwiki/vimwiki",

  -- "akorshkov/ak_syntax",
  -- "akorshkov/ak_vimwiki",       -- my amendments to vimwiki

  -- "hrsh7th/nvim-cmp",           -- autocompletion

  "neovim/nvim-lspconfig",
  -- "williamboman/mason.nvim",    -- installer of language servers for lsp
  -- "williamboman/mason-lspconfig.nvim",  -- config lsp to use servers installed by mason

  -- "jose-elias-alvarez/null-ls.nvim",  -- helps to plug lsp formatters into lsp

  -- "tpope/vim-fugitive",

  -- "nvim-telescope/telescope.nvim",   -- fuzzy finder
  "kyazdani42/nvim-tree.lua",        -- file manager
  -- "Einenlum/yaml-revealer",
}
