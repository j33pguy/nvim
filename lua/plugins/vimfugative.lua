-- filename: vimfugative.lua
-- path: lua/plugins/vimfugative.lua

return {
  "tpope/vim-fugitive",
  cmd = { "Git", "G", "Gdiff", "Gstatus", "Gblame" },
  keys = {
    { "<leader>fs", "<cmd>Git<cr>",          desc = "Git Status" },
    { "<leader>fc", "<cmd>Git commit<cr>",   desc = "Git Commit" },
    { "<leader>fp", "<cmd>Git push<cr>",     desc = "Git Push" },
    { "<leader>fl", "<cmd>Git pull<cr>",     desc = "Git Pull" },
    { "<leader>fd", "<cmd>Gdiffsplit<cr>",   desc = "Git Diff" },
    { "<leader>fb", "<cmd>Git blame<cr>",    desc = "Git Blame" },
    { "<leader>fa", "<cmd>Git add %<cr>",    desc = "Git Add Current" },
  },
}
