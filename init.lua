--[[
Basics - Set these BEFORE loading plugins
--]]
vim.o.swapfile = false
vim.o.autoread = true
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
	"tpope/vim-sleuth",
	"tpope/vim-unimpaired",
	"tpope/vim-abolish",
	"tpope/vim-sensible",
	"tpope/vim-fugitive",

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
				ensure_installed = {},
				sync_install = true,
				auto_install = true,
				ignore_install = {},
				modules = {},

				highlight = {
					enable = true,
				},
			})

			-- use bash parser for zsh files
			vim.treesitter.language.register("bash", "zsh")
		end,
	},

	-- Prettier
	"prettier/vim-prettier",

	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					-- Go
					go = { "goimports", "gofmt" },

					-- Lua
					lua = { "stylua" },

					-- Web technologies
					javascript = { "prettier" },
					typescript = { "prettier" },
					javascriptreact = { "prettier" },
					typescriptreact = { "prettier" },
					json = { "prettier" },
					jsonc = { "prettier" },
					yaml = { "prettier" },
					markdown = { "prettier" },
					html = { "prettier" },
					css = { "prettier" },
					scss = { "prettier" },

					-- Shell
					sh = { "shfmt" },
					bash = { "shfmt" },
				},
				format_on_save = {
					timeout_ms = 500,
					lsp_format = "fallback",
				},
			})

			vim.api.nvim_create_user_command("F", function(args)
				local range = nil
				if args.count ~= -1 then
					local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
					range = {
						start = { args.line1, 0 },
						["end"] = { args.line2, end_line:len() },
					}
				end
				require("conform").format({ async = true, lsp_format = "fallback", range = range })
			end, { range = true })
		end,
	},

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
		"saghen/blink.cmp",
		dependencies = { "rafamadriz/friendly-snippets" },
		version = "1.*",

		opts = {
			signature = { enabled = true },
			keymap = { preset = "default" },

			appearance = {
				-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},

			cmdline = {
				enabled = false,
				completion = { menu = { auto_show = true } },
				keymap = {
					["<CR>"] = { "accept_and_enter", "fallback" },
				},
			},

			-- (Default) Only show the documentation popup when manually triggered
			completion = { documentation = { auto_show = true } },

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},

			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		opts_extend = { "sources.default" },
	},
	{
		"mason-org/mason.nvim",
		opts = {
			ensure_installed = {
				-- LSP servers (matching your vim.lsp.enable() config)
				"lua-language-server", -- Lua LSP
				"gopls",           -- Go LSP

				-- Formatters (for conform.nvim and general use)
				"stylua",
				"goimports",
				-- Note: gofmt comes with Go installation, not managed by Mason

				"prettier",

				-- Linters and diagnostics
				"golangci-lint",
				"eslint_d",
				"luacheck", -- Lua linting
			},
		},
		config = function(_, opts)
			-- PATH is handled by core.mason-path for consistency
			require("mason").setup(opts)
			-- Auto-install ensure_installed tools with better error handling
			local mr = require("mason-registry")
			local function ensure_installed()
				for _, tool in ipairs(opts.ensure_installed) do
					if mr.has_package(tool) then
						local p = mr.get_package(tool)
						if not p:is_installed() then
							vim.notify("Mason: Installing " .. tool .. "...", vim.log.levels.INFO)
							p:install():once("closed", function()
								if p:is_installed() then
									vim.notify("Mason: Successfully installed " .. tool, vim.log.levels.INFO)
								else
									vim.notify("Mason: Failed to install " .. tool, vim.log.levels.ERROR)
								end
							end)
						end
					else
						vim.notify("Mason: Package '" .. tool .. "' not found", vim.log.levels.WARN)
					end
				end
			end

			if mr.refresh then
				mr.refresh(ensure_installed)
			else
				ensure_installed()
			end
		end,
	},
})

--[[
Additional Configuration
--]]

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

vim.lsp.enable({
	"gopls",
	"lua-ls",
})

vim.diagnostic.config({
	virtual_text = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = true,
		header = "",
		prefix = "",
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚 ",
			[vim.diagnostic.severity.WARN] = "󰀪 ",
			[vim.diagnostic.severity.INFO] = "󰋽 ",
			[vim.diagnostic.severity.HINT] = "󰌶 ",
		},
		numhl = {
			[vim.diagnostic.severity.ERROR] = "ErrorMsg",
			[vim.diagnostic.severity.WARN] = "WarningMsg",
		},
	},
})
