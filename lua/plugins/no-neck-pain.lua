return {
    "shortcuts/no-neck-pain.nvim",
    version = "*",
    config = function()
        require("no-neck-pain").setup({
            width = 120,                                       -- target text width
            buffers = { colors = { background = "#000000" } }, -- optional
        })
    end,
    keys = {
        { "<leader>z", "<cmd>NoNeckPain<cr>", desc = "Toggle center" },
    },
}
