-- my neovim configuration

-- Read local settings
-- Local settings are different on different installations, so the file
-- with local settings is not commited
Site_settings = {}
local conf_dir = vim.fn.stdpath( "config" )
local site_settings_path = conf_dir .. "/site_settings.lua"
if vim.fn.empty( vim.fn.glob( site_settings_path ) ) > 0 then
  local site_settings_template_path = conf_dir .. "/site_settings_template.lua"
  local msg = "Local settings not found at '" .. site_settings_path .. "'\n"
  msg = msg .. "Please copy settings from template: \n\n"
  msg = msg .. "  cp " .. site_settings_template_path .. " " .. site_settings_path
  msg = msg .. "\n\nand review it"
  vim.notify(msg)
else
  dofile(site_settings_path)
end

local site_settings = Site_settings
Site_settings = nil

-- install plugins selected in Site_settings
require("ak.plugins").setup(site_settings)

-- configure installed plugins and everything else
require("ak.general").setup(site_settings)
