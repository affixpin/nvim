-- Mapping util
local function map(mode, lhs, rhs, opts)
  local options = { noremap=true, silent=true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

--[[
Packer Plugins 
--]]

require('packer').startup(function(use)
	-- Home Screen
	use 'echasnovski/mini.nvim'

	-- Theme
	use 'folke/tokyonight.nvim'

	-- Package manager
	use 'wbthomason/packer.nvim'

	-- Icons
	use 'ryanoasis/vim-devicons'

	-- Git
	use 'tpope/vim-fugitive'

	-- Search
	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.1',
		requires = { {'nvim-lua/plenary.nvim'} }
	}

	-- File explorer
	use {
		'nvim-tree/nvim-tree.lua',
		requires = {
			'nvim-tree/nvim-web-devicons', -- optional, for file icons
		},
		tag = 'nightly' -- optional, updated every week. (see issue #1193)
	}

	-- LSP presets
	use 'neovim/nvim-lspconfig'

	-- Syntax
	use 'prettier/vim-prettier'
	use 'leshill/vim-json'
	use 'jparise/vim-graphql'
	use 'zsh-users/zsh-syntax-highlighting'
	use 'tomlion/vim-solidity'
end)

require('mini.cursorword').setup()
require('mini.completion').setup()
require('mini.indentscope').setup()
require('mini.starter').setup()
require('mini.animate').setup()
require('mini.pairs').setup()
require('mini.tabline').setup()
require('mini.statusline').setup()

--[[
Basics
--]]

vim.g.mapleader = " "
vim.g.netrw_liststyle = 3
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.relativenumber = true



--[[
Files Manager
--]]

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

map('n', '-', ':NvimTreeToggle<CR>')
map('n', '<leader>-', ':NvimTreeFocus<CR>')

require("nvim-tree").setup()

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

--[[
Theme
--]]

vim.cmd "autocmd vimenter * ++nested colorscheme tokyonight-night"

--[[
LSP
--]]

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)

-- used to skip rebinding on non-lsp files
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

--[[
TypeScript
--]]
require('lspconfig')['tsserver'].setup{
    on_attach = on_attach
}

vim.opt.wildignore:append { "*.d.ts", "**/node_modules/**", "**/build/**", "**/dist/**", "**/.git/**" }
-- Enable :find search across project
vim.opt.path:append { "**" }
