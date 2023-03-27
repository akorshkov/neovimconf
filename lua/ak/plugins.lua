-- manage my plugins using packer.nvim plugin manager =====
--
-- list of plugins which should be actually installed is
-- site-specific and provided with 'site_settings' argument.

local M = {}

-- default non-trivial arguments for installing pluging I usually use.
local default_plugin_options = {
  -- plugin name -> arguments for packer

  ["hrsh7th/nvim-cmp"] = {             -- autocompletion
    requires = {
      "L3MON4D3/LuaSnip",  -- nvim-cmp requires a snippet engine. Here it is.
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
    },
  },

  ["jose-elias-alvarez/null-ls.nvim"] = {  -- lsp-server interface for misc external tools
    config = function ()
      require("null-ls").setup()
    end,
    requires = {"nvim-lua/plenary.nvim"},
  },

  ["nvim-treesitter/nvim-treesitter"] = {
    run = function()
      -- workaround for known problem: officially suggested command ':TSUpdate'
      -- fails on install
      local ts_update = require('nvim-treesitter.install').update({with_sync=true})
      ts_update()
    end,
  },

  ["nvim-telescope/telescope.nvim"] = { -- fuzzy finder
    requires = {"nvim-lua/plenary.nvim"},
  },
}

-- initialize plugin manager
function M.setup(site_settings)
  if not site_settings.plugins_to_install then
    -- looks like site_settings not initialized, skip plugins processing
    return
  end

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
    "wbthomason/packer.nvim",
  }

  packer.startup(function(use)
    -- process configured list of lugins to install
    -- items in site_settings.plugins_to_install may contain options for plugin installation
    local plugins_to_install = {}
    for key, value in pairs(site_settings.plugins_to_install) do
      local plugin_name
      local packer_args
      if type(key) == "number" then
        -- this is just a name of plugin, w/o options
        plugin_name = value
        packer_args = false
      else
        plugin_name = key
        packer_args = value
      end
      plugins_to_install[plugin_name] = packer_args
    end

    -- include always required plugins
    for _, plugin_name in ipairs(must_plugins) do
      if not plugins_to_install[plugin_name] then
        plugins_to_install[plugin_name] = false
      end
    end

    -- specify default args for plugins to install
    for plugin_name, packer_args in pairs(plugins_to_install) do
      if type(packer_args) == "boolean" then
        -- options for the plugin were not specified explicitely. Use dafaults.
        packer_args = default_plugin_options[plugin_name] or {}
      end

      if not packer_args[1] then
        -- First element of packer_args table should be the plugin name.
        -- Not specified, use default.
        packer_args[1] = plugin_name
      end

      use(packer_args)
    end
  end)
  -- all selected plugins are installed.
  -- configuration of installed plugins is in general.lua
end

return M
