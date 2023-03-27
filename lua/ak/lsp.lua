-- configure lsp-related stuff


local status_ok, mason = pcall(require, "mason")
if not status_ok then
  return
end
mason.setup()

-- local status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
-- if not status_ok then
-- 	return
-- end
-- mason_lspconfig.setup()

-- configure lsp settings    -- TODO: use mason_lspconfig to make it more flexible
local nvim_lsp = require('lspconfig')

local opts = { noremap=true, silent=false }


local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'g]', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'g[', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)


  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.format({async=true})<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.format()<CR>', opts)

  if client.name ~= 'pyright' then
    -- don't want to re-format all the existing python projects
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>FF', '<cmd>lua vim.lsp.buf.format()<CR>', opts)
  end
end

-- the language servers I will use
local lsp_servers = { 'jedi_language_server', 'gopls', 'lua_ls' }

for _, s in ipairs(lsp_servers) do
  nvim_lsp[s].setup {
    on_attach = on_attach
  }
end


-- formatters
local status_ok, null_ls = pcall(require, 'null-ls')
if not status_ok then
  return
end

local sources = {
  null_ls.builtins.formatting.gofmt,
  null_ls.builtins.formatting.black,
}

null_ls.setup{ sources = sources }
