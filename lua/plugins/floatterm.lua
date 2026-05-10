return {
    "nvzone/floaterm",
    dependencies = { "nvzone/volt" },
    cmd = "FloatermToggle",
    keys = {
        { "<leader>ft", "<cmd>FloatermToggle<cr>", desc = "Toggle Floaterm" },
    },
    opts = {
        border = true,
        height = 0.8, -- use numbers, not { h = 0.8 }
        width  = 0.9, -- use numbers, not { w = 0.9 }
    },
}
