-- general nvim configuration  =============================

-- options   -----------------------------------------------
for k, v in pairs {
	backup = false,                  -- do not create backup files
	mouse = "",                      -- mouse clicks do not move vim cursor

	hlsearch = true,                 -- highlight search results
	incsearch = false,               -- do search only after I push enter

	splitbelow = true,               -- affect split
	splitright = true,               -- and vsplit commands

	virtualedit = 'block',           -- in visual mode cursor goes beyond end of line
} do
	vim.opt[k] = v
end


-- variables  ----------------------------------------------
vim.g.mapleader = ','
vim.g.maplocalleader = '\\'


-- color scheme. Probably there is a better way?  ----------
vim.cmd "colorscheme torte"
vim.cmd "highlight Search term=reverse ctermbg=3 ctermfg=0 guibg=Gold2"
vim.cmd "highlight SpellBad term=reverse ctermbg=224 ctermfg=6 gui=undercurl guisp=Red"
vim.cmd "highlight SpellRare term=reverse ctermbg=225 ctermfg=2 gui=undercurl guisp=Magenta"
vim.cmd "highlight SpellCap term=reverse ctermbg=4 ctermfg=3 gui=undercurl guisp=Blue"


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

vim.api.nvim_create_user_command('Ss2', function() _conf_tabs_width(true, 2) end, {})
vim.api.nvim_create_user_command('Ss4', function() _conf_tabs_width(true, 4) end, {})
vim.api.nvim_create_user_command('St2', function() _conf_tabs_width(false, 2) end, {})
vim.api.nvim_create_user_command('St4', function() _conf_tabs_width(false, 4) end, {})
vim.api.nvim_create_user_command('St8', function() _conf_tabs_width(false, 8) end, {})


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
