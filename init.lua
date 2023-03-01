--[[
Packer Plugins
--]]
require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'

	use "github/copilot.vim"

	use 'tpope/vim-unimpaired'
	use 'tpope/vim-vinegar'
	use 'tpope/vim-sensible'
	use 'tpope/vim-fugitive'
	use 'tpope/vim-rhubarb'

	use 'akinsho/bufferline.nvim'

	use({
		'bluz71/vim-moonfly-colors',
		as = 'moonfly'
	})

	use {
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate'
	}

	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.1',
		requires = { { 'nvim-lua/plenary.nvim' } }
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
end)

--[[
Basics
--]]
vim.g.mapleader = " "
vim.o.relativenumber = true
vim.o.number = true
vim.o.termguicolors = true

vim.opt.wildignore:append { "*.d.ts", "**/node_modules/**", "**/build/**", "**/dist/**", "**/.git/**" }
-- Enable :find search across project
vim.opt.path:append { "**" }

--[[
THEME
--]]
vim.cmd('colorscheme moonfly')

--[[
LINES
--]]
require("bufferline").setup {}

--[[
Telescope
--]]
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

--[[
Fugitive
--]]
local function diffSplitInNewTab()
	vim.cmd('tabnew')
	vim.cmd('Gdiffsplit')
end

vim.keymap.set('n', '<leader>gs', diffSplitInNewTab, {})

-- quickfix next item, close current tab
vim.keymap.set('n', '<leader>gt', function()
	vim.cmd('tabc')
	diffSplitInNewTab()
end, {})

--[[
LSP
--]]
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format, {})

local lsp = require('lsp-zero').preset({
	name = 'minimal',
	set_lsp_keymaps = true,
	manage_nvim_cmp = true,
	suggest_lsp_servers = true,
})

lsp.setup_nvim_cmp({
	mapping = lsp.defaults.cmp_mappings({
		['<Enter>'] = vim.NIL,
		['<Ctrl-u>'] = vim.NIL,
		['<Ctrl-f>'] = vim.NIL,
		['<Ctrl-d>'] = vim.NIL,
		['<Ctrl-b>'] = vim.NIL,
		['<Tab>'] = vim.NIL,
		['<S-Tab>'] = vim.NIL,
	})
})

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
