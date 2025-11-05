--[[
Basics - Set these BEFORE loading plugins
--]]
vim.o.swapfile = false
vim.g.mapleader = " "
vim.o.relativenumber = true
vim.o.number = true
vim.o.termguicolors = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true

--[[
Lazy.nvim Bootstrap
--]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

--[[
Plugin Setup
--]]
require("lazy").setup({
	-- Core
	"github/copilot.vim",
	"tpope/vim-sleuth",
	"tpope/vim-unimpaired",
	"tpope/vim-abolish",
	"tpope/vim-sensible",
	"tpope/vim-fugitive",
	"nvim-lua/plenary.nvim",

	-- Lualine (replaces bufferline)
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					theme = "auto",
					component_separators = "|",
					section_separators = "",
				},
			})
		end,
	},

	-- Colorscheme
	{ "bluz71/vim-moonfly-colors", name = "moonfly" },

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPre", "BufNewFile" },
		build = ":TSUpdate",
		config = function()
			-- import nvim-treesitter plugin
			local treesitter = require("nvim-treesitter.configs")

			-- configure treesitter
			treesitter.setup({ -- enable syntax highlighting
				highlight = {
					enable = true,
				},
				-- enable indentation
				indent = { enable = true },
				-- ensure these language parsers are installed
				ensure_installed = {
					"json",
					"javascript",
					"typescript",
					"tsx",
					"yaml",
					"html",
					"css",
					"prisma",
					"markdown",
					"markdown_inline",
					"svelte",
					"graphql",
					"bash",
					"lua",
					"vim",
					"dockerfile",
					"gitignore",
					"query",
					"vimdoc",
					"c",
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<C-space>",
						node_incremental = "<C-space>",
						scope_incremental = false,
						node_decremental = "<bs>",
					},
				},
			})

			-- use bash parser for zsh files
			vim.treesitter.language.register("bash", "zsh")
		end,
	},
	{
		{
			{
				"williamboman/mason-lspconfig.nvim",
				opts = {},
				dependencies = {
					{
						"williamboman/mason.nvim",
						opts = {},
					},
					"neovim/nvim-lspconfig",
				},
			},
		},
	},

	-- Prettier
	"prettier/vim-prettier",

	-- Oil
	{
		"stevearc/oil.nvim",
		config = function()
			require("oil").setup({
				view_options = {
					show_hidden = true,
				},
			})
			vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory" })
		end,
	},

	-- FZF-Lua
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local fzf = require("fzf-lua")
			vim.keymap.set("n", "<leader>ff", fzf.files, {})
			vim.keymap.set("n", "<leader>fr", fzf.resume, {})
			vim.keymap.set("n", "<leader>fg", fzf.live_grep, {})
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-buffer", -- source for text in buffer
			"hrsh7th/cmp-path", -- source for file system paths
			{
				"L3MON4D3/LuaSnip",
				-- follow latest release.
				version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
				-- install jsregexp (optional!).
				build = "make install_jsregexp",
			},
			"saadparwaiz1/cmp_luasnip", -- for autocompletion
			"rafamadriz/friendly-snippets", -- useful snippets
			"onsails/lspkind.nvim", -- vs-code like pictograms
		},
		config = function()
			local cmp = require("cmp")

			local luasnip = require("luasnip")

			local lspkind = require("lspkind")

			-- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
			require("luasnip.loaders.from_vscode").lazy_load()

			cmp.setup({
				snippet = { -- configure how nvim-cmp interacts with snippet engine
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
					["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
					["<C-e>"] = cmp.mapping.abort(), -- close completion window
					["<CR>"] = cmp.mapping.confirm({ select = false }),
				}),
				-- sources for autocompletion
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" }, -- snippets
					{ name = "buffer" }, -- text within current buffer
					{ name = "path" }, -- file system paths
				}),

				-- configure lspkind for vs-code like pictograms in completion menu
				formatting = {
					format = lspkind.cmp_format({
						maxwidth = 50,
						ellipsis_char = "...",
					}),
				},
			})
		end,
	},
	{
		"hrsh7th/cmp-nvim-lsp",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "antosha417/nvim-lsp-file-operations", config = true },
			{ "folke/lazydev.nvim", opts = {} },
		},
		config = function()
			-- import cmp-nvim-lsp plugin
			local cmp_nvim_lsp = require("cmp_nvim_lsp")

			-- used to enable autocompletion (assign to every lsp server config)
			local capabilities = cmp_nvim_lsp.default_capabilities()

			vim.lsp.config("*", {
				capabilities = capabilities,
			})
		end,
	},
})

--[[
Additional Configuration
--]]

-- Copilot
vim.g.copilot_assume_mapped = true

-- General keymaps
vim.keymap.set("n", "<leader>.", "@:", { desc = "Repeat last command-line" })

vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, {})
vim.keymap.set("n", "<leader>lr", ":LspRestart<cr>", {})

-- Enable :find search across project
vim.opt.path:append({ "**" })

-- Theme
vim.cmd("colorscheme moonfly")

-- Default LSP keymaps (applied to all LSP-attached buffers)
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local bufnr = ev.buf
		local client = vim.lsp.get_client_by_id(ev.data.client_id)

		-- Helper: buffer-local keymap
		local map = function(mode, keys, func, desc)
			vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
		end

		-- === Navigation ===
		map("n", "gd", vim.lsp.buf.definition, "Goto Definition")
		map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
		map("n", "gr", vim.lsp.buf.references, "Goto References")
		map("n", "gI", vim.lsp.buf.implementation, "Goto Implementation")
		map("n", "gy", vim.lsp.buf.type_definition, "Goto Type Definition")

		-- === Info ===
		map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
		map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature Help")
		map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature Help (Insert)")

		-- === Actions ===
		map("n", "<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
		map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code Action")

		-- === Diagnostics ===
		map("n", "<leader>sd", vim.diagnostic.open_float, "Show Line Diagnostics")
		map("n", "[d", vim.diagnostic.goto_prev, "Prev Diagnostic")
		map("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")
		map("n", "<leader>dl", vim.diagnostic.setloclist, "Diagnostics to LocList")

		-- === Workspace ===
		map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "Add Workspace Folder")
		map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove Workspace Folder")
		map("n", "<leader>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, "List Workspace Folders")

		-- Optional: Format on save (if server supports)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_create_autocmd("BufWritePre", {
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({ bufnr = bufnr, async = false })
				end,
			})
		end
	end,
})
