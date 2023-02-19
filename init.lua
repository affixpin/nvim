--[[
Packer Plugins
--]]
require('packer').startup(function(use)
	use "github/copilot.vim"

	use {
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate'
	}

	use 'tpope/vim-unimpaired'
	use 'nvim-lualine/lualine.nvim'

	use 'akinsho/bufferline.nvim'

	use({
	    'rose-pine/neovim',
	    as = 'rose-pine'
	})

	use 'wbthomason/packer.nvim'

	use 'tpope/vim-fugitive'

	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.1',
		requires = { { 'nvim-lua/plenary.nvim' } }
	}

	use {
		'nvim-tree/nvim-tree.lua',
		requires = {
			'nvim-tree/nvim-web-devicons', -- optional, for file icons
		},
		tag = 'nightly' -- optional, updated every week. (see issue #1193)
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
	use 'leshill/vim-json'
	use 'jparise/vim-graphql'
	use 'zsh-users/zsh-syntax-highlighting'
	use 'tomlion/vim-solidity'
end)

require("rose-pine").setup()

local highlights = require('rose-pine.plugins.bufferline')
require('bufferline').setup({ highlights = highlights })

require('lualine').setup()



require 'nvim-treesitter.configs'.setup {
	-- A list of parser names, or "all"
	ensure_installed = { "help", "javascript", "typescript", "c", "lua", "rust" },

	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = false,

	-- Automatically install missing parsers when entering buffer
	-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
	auto_install = true,

	highlight = {
		-- `false` will disable the whole extension
		enable = true,

		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = false,
	},
}


--[[
Basics
--]]
vim.g.mapleader = " "
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.relativenumber = true
vim.opt.termguicolors = true


--[[
Files Manager
--]]
-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.api.nvim_set_keymap('n', '-', ':NvimTreeToggle<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>-', ':NvimTreeFocus<CR>', {})

require("nvim-tree").setup()

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

--[[
LSP
--]]
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
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

-- (Optional) Configure lua language server for neovim
lsp.nvim_workspace()

lsp.setup()

vim.opt.wildignore:append { "*.d.ts", "**/node_modules/**", "**/build/**", "**/dist/**", "**/.git/**" }
-- Enable :find search across project
vim.opt.path:append { "**" }
vim.cmd('colorscheme rose-pine')
