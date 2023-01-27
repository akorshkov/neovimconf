-- manage my plugins useing packer.nvim plugin manager =====

local install_path = vim.fn.stdpath( "data" ) .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty( vim.fn.glob( install_path ) ) > 0 then
	packer_just_installed = vim.fn.system({
		"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer; close and reopen neovim")
	vim.cmd("packadd packer.nvim")
end

local status_ok, packer = pcall(require, "packer")
if not status_ok then
	vim.notity("Oops, failed to load 'packer' plugin manager")
	return
end

packer.startup(function(use)
	use "wbthomason/packer.nvim"     -- the plugin maager itself
	use "vimwiki/vimwiki"
	use "akorshkov/ak_syntax"        -- my amendments to vimwiki

	if packer_just_installed then
		packer.sync()
	end
end)
