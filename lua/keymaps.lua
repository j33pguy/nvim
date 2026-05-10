-- filename: keymaps.lua
-- path: lua/keymaps.lua

-- Pane navigation with Ctrl + hjkl
vim.keymap.set({ "n", "t" }, "<C-h>", "<C-w>h", { desc = "Go left" })
vim.keymap.set({ "n", "t" }, "<C-j>", "<C-w>j", { desc = "Go down" })
vim.keymap.set({ "n", "t" }, "<C-k>", "<C-w>k", { desc = "Go up" })
vim.keymap.set({ "n", "t" }, "<C-l>", "<C-w>l", { desc = "Go right" })

-- LSP formatting
vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { desc = "Format Document" })

-- Diagnostics navigation
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Line diagnostics" })
