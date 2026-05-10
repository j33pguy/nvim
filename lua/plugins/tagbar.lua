return {
  "preservim/tagbar",
  cmd = "TagbarToggle",
  keys = {
    { "<leader>tb", "<cmd>TagbarToggle<cr>", desc = "Toggle Tagbar" },
  },
  config = function()
    vim.g.tagbar_ctags_bin = "/opt/homebrew/bin/ctags"
    vim.g.tagbar_width = 30
    vim.g.tagbar_sort = 0          -- sort by order in file
    vim.g.tagbar_compact = 1
  end,
}
