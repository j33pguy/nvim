-- filename: which-key.lua
-- path: lua/plugins/which-key.lua

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",          -- or "classic" / "helix"
    delay = 200,
    plugins = {
      marks = true,
      registers = true,
      spelling = { enabled = true, suggestions = 9 },
      presets = {
        operators = true,
        motions = true,
        text_objects = true,
        windows = true,
        nav = true,
        z = true,
        g = true,
      },
    },
    win = {
      no_overlap = true,
      padding = { 1, 2 },
      title = true,
      title_pos = "center",
    },
    layout = {
      width = { min = 20 },
      spacing = 3,
    },
    icons = {
      mappings = true,
    },
    show_help = true,
    show_keys = true,
  },
  keys = {
    { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Buffer Local Keymaps" },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)

    wk.add({
      { "<leader>f", group = "Git / Floaterm" },
      { "<leader>g", group = "Go / Git hunk" },
      { "<leader>n", group = "Neo-tree / Neogen" },
      { "<leader>t", group = "Trouble / Tagbar / TODO" },
      { "<leader>s", group = "Search (Telescope)" },
      { "<leader>c", group = "Code / Comments" },
      { "<leader>u", group = "Undo / History" },
      { "<leader>x", group = "Extras (TODO)" },
    })
  end,
}
