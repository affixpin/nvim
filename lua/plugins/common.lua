return {
	"tpope/vim-sleuth",
	"tpope/vim-unimpaired",
	"tpope/vim-abolish",
	"tpope/vim-sensible",
	"tpope/vim-fugitive",
	{
		"bluz71/vim-moonfly-colors",
		name = "moonfly",
		init = function()
			vim.cmd("colorscheme moonfly")
		end,
	},
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
}
