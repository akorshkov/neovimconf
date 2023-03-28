-- general nvim configuration  =============================

local M = {}

-- vim options   -------------------------------------------
for k, v in pairs {
  backup = false,                  -- do not create backup files
  mouse = "",                      -- mouse clicks do not move vim cursor
  hidden = false,                  -- abandon buffer when last attached window is closed

  hlsearch = true,                 -- highlight search results
  incsearch = false,               -- do search only after I push enter

  splitbelow = true,               -- affect split
  splitright = true,               -- and vsplit commands

  virtualedit = 'block',           -- in visual mode cursor goes beyond end of line

  signcolumn = 'no',               -- signcolumn will be display on demand
} do
  vim.opt[k] = v
end


-- vim variables  ------------------------------------------
vim.g.mapleader = ','
vim.g.maplocalleader = '\\'


-- color scheme. Probably there is a better way?  ----------
local status_ok, err = pcall(vim.cmd, "colorscheme ak_colors")
if not status_ok then
  -- use one of standard color schemes
  vim.cmd "colorscheme torte"
  vim.cmd "highlight Search term=reverse ctermbg=3 ctermfg=0 guibg=Gold2"
  vim.cmd "highlight SpellBad term=reverse ctermbg=224 ctermfg=6 gui=undercurl guisp=Red"
  vim.cmd "highlight SpellRare term=reverse ctermbg=225 ctermfg=2 gui=undercurl guisp=Magenta"
  vim.cmd "highlight SpellCap term=reverse ctermbg=4 ctermfg=3 gui=undercurl guisp=Blue"
end

-- statusline ----------------------------------------------
local statusline = {
  "%-3.3n ",                         -- buffer number
  "%f ",                             -- file name
  "%h%m%r%w",                        -- status flag
  "[%{strlen(&ft)?&ft:'none'}] ",    -- file type
  "%=",                              -- right align remainder
  "0x%-8B ",                         -- character value
  "%-10(%l,%c%V%) ",                 -- cursor position
  "%<%P",                            -- file position
}

vim.api.nvim_set_option('statusline', table.concat(statusline))

-- commands to specify tab width and behavior  -------------
-- tabstop        - how tab character looks
-- softtabstop    - width of what is inserted when I push tab button.
--                  Depending on other options one or more tabs and/or spaces
--                  are actually inserted.
-- shiftwidth     - num spaces used for auto indents
-- expandtab      - insert spaces when I push tab

local function _conf_tabs_width(if_expand, tab_width)
  vim.opt_local['expandtab'] = if_expand
  vim.opt_local['shiftwidth'] = tab_width
  vim.opt_local['softtabstop'] = tab_width
  if if_expand then
    vim.opt_local['tabstop'] = 8
  else
    vim.opt_local['tabstop'] = tab_width
  end
end

local mk_cmd = vim.api.nvim_create_user_command
mk_cmd('Ss2', function() _conf_tabs_width(true, 2) end, {})
mk_cmd('Ss4', function() _conf_tabs_width(true, 4) end, {})
mk_cmd('St2', function() _conf_tabs_width(false, 2) end, {})
mk_cmd('St4', function() _conf_tabs_width(false, 4) end, {})
mk_cmd('St8', function() _conf_tabs_width(false, 8) end, {})


-- filetype-specific formatting options
-- (strange, but lsp does not do it)

vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.opt.shiftwidth = 4
    vim.opt.softtabstop = 4
    vim.opt.tabstop = 4
    vim.opt.expandtab = false
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt.shiftwidth = 4
    vim.opt.softtabstop = 4
    vim.opt.tabstop = 4
    vim.opt.expandtab = true
  end,
})
 

-- configure diagnostic ------------------------------------
vim.diagnostic.config{
  virtual_text = false,  -- do not display annoying warnings all the time
}

-- toggle diagnostic signcolumn
function toggle_signcolumn()
  if vim.opt_local.signcolumn:get() == 'yes' then
    vim.opt_local['signcolumn'] = 'no'
  else
    vim.opt_local['signcolumn'] = 'yes'
  end
end

vim.keymap.set('n', 'mm', ':lua toggle_signcolumn()<CR>', {silent=true})
vim.keymap.set('n', 'mk', ':lua vim.diagnostic.open_float()<CR>', {silent=true})
vim.keymap.set('n', 'mn', ':lua vim.diagnostic.goto_next()<CR>', {silent=true})
vim.keymap.set('n', 'mN', ':lua vim.diagnostic.goto_prev()<CR>', {silent=true})

-- common (filetype independent) mappings ------------------
-- Q runs my 'hot' macro 'q'
-- (use standard 'qq' command to start macro recording and 'q' to stop)
vim.keymap.set('n', 'Q', '@q', {})

-- keep same buffer value after pasting it
vim.keymap.set('v', 'p', '"_dP', {})

-- stay in visual mode after changing indent level
vim.keymap.set('v', '>', '>gv', {})
vim.keymap.set('v', '<', '<gv', {})

-- highlight (not search!) current word
vim.keymap.set('n', '+', ':match RedrawDebugComposed /\\<<C-R><C-W>\\>/<CR>', {})

-- toggle match trailing blank and mixes of tabs/spaces
vim.keymap.set('n', 'm ', ':lua ToggleBadSpacesHl()<CR>', {silent=true})

function ToggleBadSpacesHl()
  if not vim.b.akTrailingHl then
    vim.b.akTrailingHl = vim.fn.matchadd("ErrorMsg", "\\t \\| \\t\\|\\s\\+$")
  else
    vim.fn.matchdelete(vim.b.akTrailingHl)
    vim.b.akTrailingHl = nil
  end
end

-- hotkeys for quick-fix window
-- F17 = Shift+F5, etc.
vim.keymap.set('n', '<F5>', ':lopen<CR>', {})
vim.keymap.set('n', '<F17>', ':lclose<CR>', {})
vim.keymap.set('n', '<F6>', ':copen<CR>', {})
vim.keymap.set('n', '<F18>', ':cclose<CR>', {})
vim.keymap.set('n', '<F7>', ':lnext<CR>', {})
vim.keymap.set('n', '<F19>', ':lprev<CR>', {})
vim.keymap.set('n', '<F8>', ':cnext<CR>', {})
vim.keymap.set('n', '<F20>', ':cprev<CR>', {})

-- helper commands to report syntax group on current cursor position
function syn_stack()
  local syn_names = {}
  for _, syn_id in ipairs(vim.fn.synstack(vim.fn.line('.'), vim.fn.col('.'))) do
    local syn_name = syn_id .. "." .. vim.fn.synIDattr(syn_id, 'name')
    table.insert(syn_names, syn_name)
  end
  -- not sure what is going on here and if names are correct
  -- looks like from now on highlight groups are listed
  local hl_names = {}
  local hl_id = vim.fn.synID(vim.fn.line('.'), vim.fn.col('.'), 1)
  while true do
    local hl_name = hl_id .. '.' .. vim.fn.synIDattr(hl_id, 'name')
    table.insert(hl_names, hl_name)
    local next_hl_id = vim.fn.synIDtrans(hl_id)
    if next_hl_id == hl_id then break end
    hl_id = next_hl_id
  end

  local result = "syntax: [" .. table.concat(syn_names, ", ") .. "]"
  result = result .. ' => ' .. table.concat(hl_names, " -> ")
  print(result)
end

vim.keymap.set('n', '<leader><F12>', ':lua syn_stack()<CR>', {silent=true})
vim.keymap.set('n', '<F12>', ':syntax sync fromstart<CR>', {silent=true})

-- subsequent configuration depends on installed plugins
function M.setup(site_settings)

  -- congig of these plugins is in separate files
  require "ak.cmp"
  require "ak.lsp"

  -- nvim-tree plugin
  local nvimtree_ok, nvimtree = pcall(require, 'nvim-tree')
  if nvimtree_ok then
    nvimtree.setup()  -- :help nvim-tree-setup
    vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', {})
  end

  -- treesitter plugin
  local treesitter_ok, treesitter = pcall(require, 'nvim-treesitter.configs')
  if treesitter_ok then
    treesitter.setup{
      ensure_installed = { 'c', 'lua', 'vim', 'help', 'python', 'go' },
      sync_install = false,
      auto_install = false,
      highlight = {
        enable = false,
      },
      indent = {
        enable = true,
      },
    }
  end

  -- telescope plugin
  local telescope_ok, telescope = pcall(require, 'telescope')
  if telescope_ok then
    telescope.setup()

    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
    vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
  end
end

return M
