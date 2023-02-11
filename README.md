My neovim configuration.
========================

Installation:
-------------
1. Clear (and/or backup) your ~/.config/nvim

2. Checkout this repo to ~/.config/nvim:

	`git clone https://github.com/akorshkov/neovimconf.git ~/.config/nvim`

3. Create site settings:

	`cp ~/.config/nvim/site_settings_template.lua ~/.config/nvim/site_settings.lua`

4. Inspect/modify this file, start nvim and run:

	`:PackerSync`

to install selected plugins.
