-- lua/plugins/todo-comments.lua
return {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "TodoQuickFix", "TodoLocList", "TodoTelescope" },
    keys = {
        { "]t",         function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
        { "[t",         function() require("todo-comments").jump_prev() end, desc = "Prev todo comment" },
        { "<leader>xq", "<cmd>TodoQuickFix<cr>",                             desc = "Todo (QuickFix)" },
        { "<leader>xl", "<cmd>TodoLocList<cr>",                              desc = "Todo (LocList)" },
        { "<leader>xt", "<cmd>TodoTelescope<cr>",                            desc = "Todo (Telescope)" },
    },
    opts = {
        signs = true,
        keywords = {
            FIX  = { icon = "律", color = "error", alt = { "FIXME", "BUG", "ISSUE" } },
            TODO = { icon = " ", color = "info" },
            HACK = { icon = " ", color = "warning" },
            WARN = { icon = " ", color = "warning", alt = { "WARNING" } },
            PERF = { icon = " ", alt = { "PERFORMANCE", "OPTIMIZE" } },
            NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        },
    },
}
