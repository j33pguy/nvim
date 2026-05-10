-- lua/plugins/neogen.lua


return {
    "danymat/neogen",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    keys = {
        { "<leader>nf", function() require("neogen").generate() end,                  desc = "Generate Annotation" },
        { "<leader>nc", function() require("neogen").generate({ type = "file" }) end, desc = "File Comment" },
        { "<leader>nT", function() require("neogen").generate({ type = "type" }) end, desc = "Type/Class Comment" },
        { "<leader>nm", function() require("neogen").generate({ type = "func" }) end, desc = "Function Comment" },
    },
    opts = {
        snippet_engine = "luasnip", -- or "nvim" / "snippy"
    },
}
