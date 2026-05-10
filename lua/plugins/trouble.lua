-- lua/plugins/trouble.lua

return {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    keys = {
        { "<leader>tt", "<cmd>Trouble diagnostics toggle<cr>",              desc = "Toggle Trouble" },
        { "<leader>tw", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics" },
        { "<leader>tq", "<cmd>Trouble quickfix toggle<cr>",                 desc = "Quickfix" },
        { "<leader>tl", "<cmd>Trouble loclist toggle<cr>",                  desc = "Loclist" },
        { "<leader>tr", "<cmd>Trouble lsp_references toggle<cr>",           desc = "LSP References" },
    },
    opts = {
        auto_preview = true,
        auto_fold = false,
        auto_close = false,
        use_diagnostic_signs = true,
        signs = {
            error = " ",
            warning = " ",
            hint = " ",
            information = " ",
        },
        modes = {
            diagnostics = {
                mode = "diagnostics",
                preview = { type = "float", relative = "cursor", focusable = false },
            },
        },
        win = {
            position = "bottom",
            size = 10,
        },
    },
}
