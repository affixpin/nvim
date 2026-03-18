vim.keymap.set("n", "<leader>.", "@:", { desc = "Repeat last command-line" })
vim.opt.clipboard = "unnamedplus"

vim.keymap.set("n", "<leader>cp", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify(path, vim.log.levels.INFO, { title = "Path copied" })
end, { desc = "Copy absolute file path" })

vim.api.nvim_create_user_command("LspInfo", function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    vim.notify("No LSP clients attached", vim.log.levels.WARN)
    return
  end
  local names = vim.tbl_map(function(c) return c.name end, clients)
  vim.notify(table.concat(names, ", "), vim.log.levels.INFO)
end, { desc = "Show attached LSP clients" })

vim.api.nvim_create_user_command("Reload", function()
  vim.cmd("source ~/.config/nvim/init.lua")
  vim.notify("Config reloaded", vim.log.levels.INFO)
end, { desc = "Reload Neovim config" })
