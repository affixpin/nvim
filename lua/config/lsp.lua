-- Default LSP keymaps (applied to all LSP-attached buffers)
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local bufnr = ev.buf

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

		vim.lsp.inline_completion.enable(true)

		vim.keymap.set({ "i", "n" }, "<C-l>", function()
			vim.lsp.inline_completion.get()
		end, {
			desc = "Get the current inline completion",
		})

		vim.keymap.set("i", "<C-n>", function()
			vim.lsp.inline_completion.select()
		end)

		vim.keymap.set("i", "<C-p>", function()
			vim.lsp.inline_completion.select({ count = -1 })
		end)
	end,
})

-- DAML BLOCK
pcall(vim.filetype.add, {
	extension = { daml = "daml" },
	pattern = { [".*%.daml"] = "daml" }, -- matches buffer names like "...foo.daml"
})

-- 1) Tree-sitter: treat DAML as Haskell (for better highlight coverage)
if vim.treesitter and vim.treesitter.language and vim.treesitter.language.register then
	pcall(vim.treesitter.language.register, "haskell", "daml")
end

-- 2) Optional: keep Haskell indentation for DAML buffers
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("daml_nvim_indent", { clear = true }),
	pattern = "daml",
	callback = function()
		-- Only set if function exists to avoid errors when haskell indent isn't present
		if vim.fn.exists("*GetHaskellIndent") == 1 then
			vim.bo.indentexpr = "GetHaskellIndent()"
			vim.b.did_indent = 1
		end
	end,
})
-- DAML BLOCK

vim.lsp.enable({
	"gopls",
	"lua-ls",
	"copilot",
	"remark",
	"daml",
	"ts",
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
