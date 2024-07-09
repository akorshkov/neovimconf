-- This file contains local (installation specific) settings for nvim configuration.
--
-- If name of this file is 'site_settings_template.lua' then it is just a
-- template; it's modification would not affect anything. Copy it
-- to 'site_settings.lua' before doing any modifications.

-- plugins_to_install - installation arguments of plugins to install
-- Plugins will be installed by Packer and most plugins do not require
-- any installation arguments.
--
-- Packer arguments for each plugin may be specified, but in most cases
-- it is not required - default arguments for plugins I usually use are
-- specified in lua/ak/plugins.lua.
--
-- But configuration of installed plugins is still required. (usually it means
-- that 'setup' method must be called). Initialization code is
-- located in lua/ak/general.lua
Site_settings.plugins_to_install = {
  -- "nvim-treesitter/nvim-treesitter",
  -- "nvim-treesitter/playground",

  -- "akorshkov/ak-colors.vim",
  -- "akorshkov/kmantopic-filetype.nvim"
  -- "akorshkov/akn-filetype.vim",
  -- "vimwiki/vimwiki",

  -- "akorshkov/ak-syntax.vim",
  -- "akorshkov/ak_vimwiki",       -- my amendments to vimwiki

  -- "hrsh7th/nvim-cmp",           -- autocompletion

  "neovim/nvim-lspconfig",
  -- "williamboman/mason.nvim",    -- installer of misc third-party tools used by nvim
  -- "williamboman/mason-lspconfig.nvim",  -- config lsp to use servers installed by mason

  -- "jose-elias-alvarez/null-ls.nvim",  -- helps to plug lsp formatters into lsp
  -- "jay-babu/mason-null-ls.nvim", -- helps to install tools to be used by null-ls

  -- "tpope/vim-fugitive",

  -- "nvim-telescope/telescope.nvim",   -- fuzzy finder
  "kyazdani42/nvim-tree.lua",        -- file manager
  -- "Einenlum/yaml-revealer",
}

-- lsp servers to be installed (using mason and mason-lspconfig plugins)
-- lsp servers are not part of nvim. But these servers will be installed in
-- nvim data directory. Are supposed to be used by nvim only and shoud not
-- affect rest of the system.
--
-- mason-lspconfig.nvim is required to install these servers.
--
-- (the table may conain names, or names/settings:  ["name"] = {settings}
Site_settings.lsp_servers = {
  -- 'jedi_language_server',
  -- 'gopls',
  -- 'lua_ls',
  -- 'rust_analyzer',
}

-- Tools, which are not lsp servers, but perform some lsp-related tasks
-- These tools will be used as sources for null-ls plugin.
-- These tools will be installed by mason-null-ls plugin.
Site_settings.lsp_tools = {
  -- 'black',  -- formatter for python
  -- 'stylua', -- formatter for lua
}

-- site-specific settings of tabs behavior
-- key: filetype
-- value: {"s" or "t", tab_size}
Site_settings.tabs_config = {
  -- python = {"s", 4},
  -- go = {"t", 4},
}
