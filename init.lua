-- Packer Plugins
require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'
	use 'morhetz/gruvbox'
	use 'neovim/nvim-lspconfig'
	use {
    'kosayoda/nvim-lightbulb',
    requires = 'antoinemadec/FixCursorHold.nvim',
	}
end)

-- Basics
vim.g.mapleader = " "
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.relativenumber = true
vim.g.cursorhold_updatetime = 100

-- Theme
vim.cmd "autocmd vimenter * ++nested colorscheme gruvbox"

-- Code action bulb
vim.cmd [[autocmd CursorHold,CursorHoldI * lua require('nvim-lightbulb').update_lightbulb()]]

-- LSP 
local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
end

require'lspconfig'.tsserver.setup{
	on_attach = on_attach
}

local keymap = vim.keymap.set
keymap('n', '[d', vim.diagnostic.goto_prev, opts)
keymap('n', ']d', vim.diagnostic.goto_next, opts)
keymap('n', 'ga', vim.lsp.buf.code_action, bufopts)
keymap('n', 'gr', vim.lsp.buf.rename, bufopts)
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)

