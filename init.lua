--[[
Packer Plugins 
--]]

require('packer').startup(function(use)
	-- Package manager
	use 'wbthomason/packer.nvim'

	-- GIT
	use 'tpope/vim-fugitive'

	-- Theme
	use 'morhetz/gruvbox'

	-- File explorer
	use 'tpope/vim-vinegar'

	-- LSP presets
	use 'neovim/nvim-lspconfig'

	-- Syntax
	use 'prettier/vim-prettier'
	use 'jparise/vim-graphql'
	use 'zsh-users/zsh-syntax-highlighting'
	use 'tomlion/vim-solidity'
end)

--[[
Basics
--]]

vim.g.mapleader = " "
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.relativenumber = true

--[[
Theme
--]]

vim.cmd "autocmd vimenter * ++nested colorscheme gruvbox"

--[[
LSP
--]]

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

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
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

--[[
TypeScript
--]]
require('lspconfig')['tsserver'].setup{
    on_attach = on_attach
}

vim.opt.wildignore:append { "*.d.ts", "**/node_modules/**", "**/build/**", "**/dist/**" }
-- Enable :find search across project
vim.opt.path:append { "**" }
