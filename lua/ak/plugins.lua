-- manage my plugins using packer.nvim plugin manager =====
--
-- list of plugins which should be actually installed is
-- site-specific and provided with 'site_settings' argument.

local M = {}

-- info about all the plugins which are ready to be installed
-- (my nvim configuration is ready aware of them and is ready
-- to configure them properly)
local supported_plugins = {
  -- plugin name -> arguments for packer

  ["wbthomason/packer.nvim"] = {},     -- the plugin manager itself

  ["vimwiki/vimwiki"] = {},

  ["akorshkov/ak_syntax"] = {},
  ["akorshkov/ak_vimwiki"] = {},       -- my amendments to vimwiki

  ["hrsh7th/nvim-cmp"] = {             -- autocompletion
    "L3MON4D3/LuaSnip",  -- nvim-cmp requires a snippet engine. Here it is.
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-nvim-lsp",
  },

  ["neovim/nvim-lspconfig"] = {},
  ["williamboman/mason.nvim"] = {},    -- installer of language servers for lsp
  ["williamboman/mason-lspconfig.nvim"] = {},  -- config lsp to use servers installed by mason

  ["jose-elias-alvarez/null-ls.nvim"] = {  -- helps to plug lsp formatters into lsp
    requires = {"nvim-lua/plenary.nvim"},
  },

  ["tpope/vim-fugitive"] = {},

  ["nvim-treesitter/nvim-treesitter"] = {
    run = function()
      -- workaround for known problem: officially suggested command ':TSUpdate'
      -- fails on install
      local ts_update = require('nvim-treesitter.install').update({with_sync=true})
      ts_update()
    end,
  },

  ["nvim-telescope/telescope.nvim"] = {},   -- fuzzy finder
  ["kyazdani42/nvim-tree.lua"] = {},   -- file manager
  ["Einenlum/yaml-revealer"] = {},
}

-- initialize plugin manager
function M.setup(site_settings)
  -- packer have to be installed always
  local pck_path = vim.fn.stdpath( "data" ) .. "/site/pack/packer/start/packer.nvim"

  if vim.fn.empty( vim.fn.glob( pck_path ) ) > 0 then
    vim.fn.system({
      "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim",
      pck_path,
    })
    print("Installing packer; close and reopen neovim")
    vim.cmd("packadd packer.nvim")
    return
  end

  -- packer installed. Use it to install all other plugins
  local status_ok, packer = pcall(require, "packer")

  if not status_ok then
    vim.notity("Oops, failed to load 'packer' plugin manager")
    return
  end

  local must_plugins = {
    ["wbthomason/packer.nvim"] = true,
  }

  packer.startup(function(use)
    for plugin_name, arguments in pairs(supported_plugins) do
      if site_settings.plugins_to_install[plugin_name] or must_plugins[plugin_name] then
        if not arguments[1] then
          -- plugin name was not specified explicitely in arguments
          arguments[1] = plugin_name
        end
        use(arguments)
      end
    end
  end)
  -- all required plugins are installed.
  -- configuration of installed plugins is in general.lua
end

return M
