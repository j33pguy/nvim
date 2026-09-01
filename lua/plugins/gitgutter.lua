return {
  "airblade/vim-gitgutter",
  event = "VeryLazy",
  keys = {
    { "]h", "<Plug>(GitGutterNextHunk)", desc = "Next Hunk" },
    { "[h", "<Plug>(GitGutterPrevHunk)", desc = "Prev Hunk" },
    { "<leader>ghp", "<Plug>(GitGutterPreviewHunk)", desc = "Preview Hunk" },
    { "<leader>ghs", "<Plug>(GitGutterStageHunk)", desc = "Stage Hunk" },
    { "<leader>ghu", "<Plug>(GitGutterUndoHunk)", desc = "Undo Hunk" },
  },
  init = function()
    vim.g.gitgutter_map_keys = 0          -- disable defaults
    vim.g.gitgutter_sign_priority = 5     -- optional: lower than LSP/gitsigns
  end,
}
