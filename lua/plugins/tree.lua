return {
	"nvim-tree/nvim-tree.lua",
	config = function()
		require("nvim-tree").setup({})
		vim.api.nvim_create_user_command("T", "NvimTreeToggle", {})
	end,
}
