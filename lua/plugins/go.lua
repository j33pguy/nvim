-- filename: go.lua
-- path: lua/plugins/go.lua

return {
    "ray-x/go.nvim",
    dependencies = { "ray-x/guihua.lua", "neovim/nvim-lspconfig", "nvim-treesitter/nvim-treesitter", "mfussenegger/nvim-dap" },
    ft = { "go", "gomod", "gowork" },
    build = ":lua require('go.install').update_all_sync()",
    opts = {
        diagnostic = { enable = true },
        goimports = "gopls",
        gofmt = "gopls",
        lsp_cfg = false, -- use your lsp.lua for gopls
        lsp_gofumpt = true,
        lsp_keymaps = true,
        dap_debug = true,
        luasnip = true,
        textobjects = true,
        trouble = true,
        test_runner = "go",
    },
    keys = {
        { "<leader>gr",  "<cmd>GoRun<cr>",        desc = "Go Run" },
        { "<leader>gt",  "<cmd>GoTest<cr>",       desc = "Go Test" },
        { "<leader>gtf", "<cmd>GoTestFunc<cr>",   desc = "Go Test Func" },
        { "<leader>gf",  "<cmd>GoFmt<cr>",        desc = "Go Fmt" },
        { "<leader>ga",  "<cmd>GoAlt<cr>",        desc = "Go Alt File" },
        { "<leader>gi",  "<cmd>GoIfErr<cr>",      desc = "Go If Err" },
        { "<leader>gD",  "<cmd>GoDebug<cr>",      desc = "Go Debug" },
        { "<leader>gT",  "<cmd>GoDebug -t<cr>",   desc = "Go Debug Test" },
        { "<leader>gS",  "<cmd>GoFillStruct<cr>", desc = "Go Fill Struct" },
        { "<leader>gtg", "<cmd>GoAddTag<cr>",     desc = "Go Add Tag" },
    },
    config = function(_, opts)
        require("go").setup(opts)
    end,
}
