-- This file contains local (installation specific) settings for nvim configuration.
--
-- If name of this file is 'site_settings_template.lua' then it is just a
-- template; it's modification would not affect anything. Copy it
-- to 'site_settings.lua' before doing any modifications

-- path to local plugins (used if plugin in plugins_to_install has dev=true)
Site_settings.plugins_dev_path = "~/Projects/vim_plugins"

-- Just uncomment plugins you want to be installed.
-- Configuration of these plugins (if such configuration is required) is
-- performed in lua/ak/plugins.lua
Site_settings.plugins_to_install = {
  -- either "plugin_name" or ["plugin_name"]={lazy opts}

  --["akorshkov/akn-filetype.vim"] = {
  --  dev = true,
  --},
  --["akorshkov/ak-colors.vim"] = {
  --  dev = true,
  --},
  --["akorshkov/kmantopic-filetype.nvim"] = {
  --  dev = true,
  --  opts = {},
  --},

  -- git plugin
  --"tpope/vim-fugitive",

  -- autocompletion
  --"hrsh7th/nvim-cmp",

  -- installer of misc tools such as lsp servers
  --"mason-org/mason.nvim",

  -- plugin required for LSP server for c#.
  --"seblyng/roslyn.nvim",

  --"neovim/nvim-lspconfig",
}

Site_settings.lsp_servers = {
  -- also need to install the LSP server. Can use jedi-language-server in Mason
  --"jedi_language_server",

  -- also need to install the LSP server. Can use lua-language-server in Mason
  --"lua_ls",

  -- C# LSP. To use this LSP it is necessary to:
  -- 1. install the LSP server. The only working installation instructions are to use Mason.
  --  So, install Mason, run :Mason, install "roslyn" LSP.
  --  (Mason has to be configured to use additional registry
  --  "github:Crashdummyy/mason-registry", it is done in this package)
  -- 2. install "seblyng/roslyn.nvim" plugin
  --"roslyn",

  -- roslyn_ls - C# roslyn LSP configuration provided by nvim-lspconfig.
  -- Unfortunately installation instructions
  -- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/roslyn_ls.lua
  -- would not work. Do not use it.
  -- !do not use it! "roslyn_ls",
}

-- site-specific settings of tabs behavior
-- key: filetype
-- value: {"s" or "t", tab_size}
-- It is possible to add records for other filetypes.
Site_settings.tabs_config = {
  -- default values are:
  --
  --python = {"s", 4},
  --go = {"t", 4},
  --cs = {"t", 4},
  --lua = {"s", 2},
  --akn = {"s", 2},
}

-- usually I do not want vim to respect settings from .editorconfig file
Site_settings.use_editorconfig = false
