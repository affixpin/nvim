--[[
Packer Plugins
--]]
require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'

	use "github/copilot.vim"

	use 'tpope/vim-sleuth'
	use 'tpope/vim-unimpaired'
	use 'tpope/vim-abolish'
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
		'nvim-telescope/telescope.nvim',
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

	use "folke/which-key.nvim"

	use({
		"jackMort/ChatGPT.nvim",
		commit = '8820b99c',
		config = function()
			require("chatgpt").setup({
				-- optional configuration
			})
		end,
		requires = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim"
		}
	})
end)

--[[
WhichKey
-- ]]
local wk = require("which-key")
wk.register({}, {})

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

vim.keymap.set('n', '<leader>.', "@:", {})

vim.opt.wildignore:append { "*.d.ts", "**/node_modules/**", "**/lib/**", "**/build/**", "**/dist/**", "**/.git/**" }
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
LSP
--]]
local lsp = require('lsp-zero').preset({
	name = 'minimal',
	set_lsp_keymaps = {preserve_mappings = false},
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
vim.opt.signcolumn = 'yes'

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
