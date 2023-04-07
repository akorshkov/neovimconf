-- configure configuration of lsp-related stuff
local M = {}

-- settings for the language servers I will use
local default_servers_settings = {
  lua_ls = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
}

-- settings for the lsp-related tools ('sources' for null-ls plugin)
local default_lsp_tools_settings = {
  black = {
    { "formatting", "black" },
    settings = nil,
  },
  stylua = {
    { "formatting", "stylua" },
    settings = nil,
  },
}


-- keyboard mappings for all lsp servers
local opts = { noremap = true, silent = false }

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'g]', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'g[', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)

  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl',
  '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)

  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.format()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'v', '<space>f', '<cmd>lua vim.lsp.buf.format()<CR>', opts)

  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>FF', '<cmd>lua vim.lsp.buf.format()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'v', '<leader>FF', '<cmd>lua vim.lsp.buf.format()<CR>', opts)
end

-- helper function; require and setup "mason" plugin, but only once
local function make_mason_plugin_getter()
  local checked = false
  local result = nil
  local function get_mason_plugin()
    if checked then
      return result
    end
    local status, mason = pcall(require, "mason")
    checked = true
    if status then
      mason.setup()
      result = mason
    else
      result = nil
    end
    return result
  end
  return get_mason_plugin
end

local get_mason_plugin = make_mason_plugin_getter()

-- install all lsp servers specified in site_settings.lsp_servers
-- "mason" and "mason-lspconfig" are used to do it
local function ensure_lsp_servers(site_lsp_servers)
  if next(site_lsp_servers) == nil then
    -- no lsp servers to install
    return
  end

  mason = get_mason_plugin()

  if mason == nil then
    print("WARNING: can't install lsp servers, 'mason' plugin is required")
    return
  end

  local status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
  if not status_ok then
    print("WARNING: can't install lsp servers, 'mason-lspconfig' plugin is required")
    return
  end

  local lsp_servers = require("ak.setup_tools").unfold_config_table(site_lsp_servers)

  local lsp_servers_names = {}
  for server_name, _ in pairs(lsp_servers) do
    table.insert(lsp_servers_names, server_name)
  end

  -- install required lsp servers
  mason_lspconfig.setup {
    ensure_installed = lsp_servers_names
  }

  -- configure lsp servers
  local nvim_lsp = require('lspconfig')

  for server_name, setup_settings in pairs(lsp_servers) do
    if type(setup_settings) == "boolean" then
      setup_settings = default_servers_settings[server_name] or {}
    end
    nvim_lsp[server_name].setup {
      on_attach = on_attach,
      settings = setup_settings
    }
  end
end


local function ensure_null_ls_tools(site_lsp_tools)
  if next(site_lsp_tools) == nil then
    -- no tools to install
    return
  end

  -- parse site settings
  local lsp_tools = require("ak.setup_tools").unfold_config_table(site_lsp_tools)
  local lsp_tools_filtered = {} -- {tool_name: {bpath, settings={...}}}
  for tool_name, conf_settings in pairs(lsp_tools) do
    if type(conf_settings) == "boolean" then
      -- only tool name was specified in Site_settings.lsp_tools. Get config from defaults
      conf_settings = default_lsp_tools_settings[tool_name]
    end
    if conf_settings then
      lsp_tools_filtered[tool_name] = conf_settings
    else
      print("WARNING: configuration for '" .. tool_name .. "' was not specified neither " ..
        "in Site_settings.lsp_tools nor in default_lsp_tools_settings")
    end
  end

  local null_ls_sources_names = {}
  for tool_name, _ in pairs(lsp_tools_filtered) do
    table.insert(null_ls_sources_names, tool_name)
  end

  local mason = get_mason_plugin()

  if mason == nil then
    print("WARNING: can't install some lsp tools, 'mason' plugin is required")
    return
  end

  local status_ok, null_ls = pcall(require, "null-ls")
  if not status_ok then
    print("WARNING: can't install some lsp tools, 'null-ls' plugin is required")
    return
  end

  local status_ok, mason_null_ls = pcall(require, "mason-null-ls")
  if not status_ok then
    print("WARNING: can't install some lsp tools, 'mason-null-ls' plugin is required")
    return
  end

  -- mason-null-ls is used only to install the tools
  mason_null_ls.setup({
    ensure_installed = null_ls_sources_names,
    automatic_installation = false,
    automatic_setup = false,
  })

  -- configure null-ls - wrapper for all the lsp-related tools which are not lsp servers
  local sources = {}
  for _, options in pairs(lsp_tools_filtered) do
    local tool_type = options[1][1]
    local src_name = options[1][2]
    local null_ls_builtin = null_ls.builtins[tool_type][src_name]
    local src = null_ls_builtin
    if options.settings then
      src = null_ls_builtin.with(options.settings)
    end
    table.insert(sources, src)
  end

  null_ls.setup { sources = sources }
end




function M.setup(site_settings)
  ensure_lsp_servers(site_settings.lsp_servers)
  ensure_null_ls_tools(site_settings.lsp_tools)
end

return M
