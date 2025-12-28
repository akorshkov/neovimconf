-- manage my plugins using lazy.nvim plugin manager
--
-- list of plugins which should be actually installed is
-- site-specific and provided with 'site_settings' argument.

local M = {}

local default_plugin_options = {
  -- plugin name -> arguments for lazy.nvim plugin manager

  ["hrsh7th/nvim-cmp"] = { -- autocompletion
    dependencies = {
      "L3MON4D3/LuaSnip",  -- nvim-cmp requires a snippet engine. Here it is.
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
    },
  },
}

local function prepare_plugin_spec(plugin_name, settings_spec, dflt_spec)
  -- merge specified and default settings for the plugin and prepare the spec
  -- for plugin manager

  local spec = {}
  if dflt_spec ~= nil then
    for n, v in pairs(dflt_spec) do
      spec[n] = v
    end
  end

  if settings_spec ~= true then
    -- true value would indicate that it only plugin name was specified in the settings.
    -- as we got here there are actualy specified optins
    for n, v in pairs(settings_spec) do
      spec[n] = v
    end
  end

  if next(spec) == nil then
    -- there are actually no additional setting for this plugin. Simple name will do as a spec
    return plugin_name
  end

  if spec[1] == nil and spec.dir == nil and spec.url == nil then
    -- need to specify plugin name in the spec table
    spec[1] = plugin_name
  end

  return spec
end


function M.setup(site_settings)
  -- Bootstrap lazy.nvim
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
      vim.api.nvim_echo({
        { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
        { out, "WarningMsg" },
        { "\nPress any key to ignore and continue..." },
      }, true, {})
      vim.fn.getchar()
      return
    end
  end
  vim.opt.rtp:prepend(lazypath)

  -- prepare plugins specs list for plugin manager setup
  local specs = {
    "folke/lazy.nvim"  -- add the plugin manager itself to the list of plugins
  }

  local plugins_to_install = require("ak.setup_tools").unfold_config_table(
    site_settings.plugins_to_install)

  for plugin_name, settings_spec in pairs(plugins_to_install) do
    local dflt_spec = default_plugin_options[plugin_name]
    local spec = prepare_plugin_spec(plugin_name, settings_spec, dflt_spec)

    table.insert(specs, spec)
  end

  -- vim.print(specs)

  require("lazy").setup({
    spec = specs,
    dev = {
      path = site_settings.plugins_dev_path,
    }
  })

  -- configuration of some plugins is complicated enough to be placed in the separate files
  require "ak.plugin_cmp"

end

return M
