--[[
Packer Plugins
--]]
require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'

	use "github/copilot.vim"
	use 'tpope/vim-sleuth'
	use 'tpope/vim-unimpaired'
	use 'tpope/vim-abolish'
	use 'tpope/vim-sensible'
	use 'tpope/vim-fugitive'

	use { 'akinsho/bufferline.nvim', tag = "v3.*", requires = 'nvim-tree/nvim-web-devicons' }


	use({
		'bluz71/vim-moonfly-colors',
		as = 'moonfly'
	})

	use {
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate'
	}

	use {
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v1.x',
		requires = {
			-- LSP Support
			{ 'neovim/nvim-lspconfig' }, -- Required
			{ 'williamboman/mason.nvim' }, -- Optional
			{ 'williamboman/mason-lspconfig.nvim' }, -- Optional

			-- Autocompletion
			{ 'hrsh7th/nvim-cmp' }, -- Required
			{ 'hrsh7th/cmp-nvim-lsp' }, -- Required

			-- Snippets
			{ 'L3MON4D3/LuaSnip' }, -- Required
		}
	}

	use 'prettier/vim-prettier'
	use "stevearc/oil.nvim"

	use { "ibhagwan/fzf-lua",
		-- optional for icon support
		requires = { "nvim-tree/nvim-web-devicons" }
	}
end)

--[[
Oil
-- ]]
require("oil").setup({
	view_options = {
		-- Show files and directories that start with "."
		show_hidden = true,
	}
})
vim.keymap.set("n", "-", require("oil").open, { desc = "Open parent directory" })

--[[
Copilot
-- ]]
vim.g.copilot_assume_mapped = true

--[[
Basics
--]]
vim.o.swapfile = false
vim.g.mapleader = " "
vim.o.relativenumber = true
vim.o.number = true
vim.o.termguicolors = true
vim.o.tabstop = 2

vim.keymap.set('n', '<leader>.', "@:", {})

-- Enable :find search across project
vim.opt.path:append { "**" }

--[[
LINES
--]]
require("bufferline").setup {}

--[[
THEME
--]]
vim.cmd('colorscheme moonfly')


--[[
FZF
--]]

local fzf = require('fzf-lua')
vim.keymap.set("n", "<leader>ff", fzf.files, {})
vim.keymap.set('n', '<leader>fr', fzf.resume, {})
vim.keymap.set('n', '<leader>fg', fzf.live_grep, {})

--[[
LSP
--]]
local lsp = require('lsp-zero').preset({
	name = 'minimal',
	set_lsp_keymaps = { preserve_mappings = false },
	manage_nvim_cmp = true,
	suggest_lsp_servers = true,
})

lsp.setup_nvim_cmp({
	mapping = lsp.defaults.cmp_mappings({
		['<Tab>'] = vim.NIL,
		['<S-Tab>'] = vim.NIL,
	})
})

vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format, {})
vim.keymap.set('n', '<leader>lr', ":LspRestart<cr>", {})
vim.opt.signcolumn = 'yes'
vim.g.lsp_zero_log_level = "verbose"

lsp.nvim_workspace()

lsp.setup()

--[[
Treesitter
--]]
require 'nvim-treesitter.configs'.setup {
	auto_install = true,
	highlight = {
		enable = true,
		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = false,
	},
}
