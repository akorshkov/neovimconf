-- my neovim configuration

-- Read local settings
-- Local settings are different on different installations, so the file
-- with local settings is not commited
site_settings = {}
local conf_dir = vim.fn.stdpath( "config" )
local site_settings_path = conf_dir .. "/site_settings.lua"
if vim.fn.empty( vim.fn.glob( site_settings_path ) ) > 0 then
  local site_settings_template_path = conf_dir .. "/site_settings_template.lua"
  msg = "Local settings not found at '" .. site_settings_path .. "'\n"
  msg = msg .. "Please copy settings from template: \n\n"
  msg = msg .. "  cp " .. site_settings_template_path .. " " .. site_settings_path
  msg = msg .. "\n\nand review it"
  vim.notify(msg)
else
  dofile(site_settings_path)
end

-- pre-process site_settings
if site_settings.plugins_to_install then
  -- elements of this table may be in one of two forms:
  --   ["plugin/name"] = some_options,  -- form 1
  --   "plugin/name",                   -- form 2
  -- Transfer elements in form 2 to equivalent:
  --   ["plugin/name"] = true,
  local plugins_to_install = {}
  for plugin_name, options in pairs(site_settings.plugins_to_install) do
    if type(plugin_name) == 'number' then
      plugin_name = options
      if not plugins_to_install[plugin_name] then
        plugins_to_install[plugin_name] = true
      end
    else
      plugins_to_install[plugin_name] = options
    end
    site_settings.plugins_to_install = plugins_to_install
  end
end

-- install plugins selected in site_settings
require("ak.plugins").setup(site_settings)

-- configure installed plugins and everything else
require("ak.general").setup(site_settings)
