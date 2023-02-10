-- configure telescope plugin

local status_ok, telescope = pcall(require, 'telescope')
if not status_ok then
  return
end

telescope.setup()

builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
