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
        -- go.nvim's own default is false. Its snips/go.lua:173 does
        --   local is_in_function = require('go.ts.go').in_func()
        -- i.e. it CALLS in_func at module-load time (and line 218 then tries to
        -- call the boolean result). Under Neovim 0.12 that load-time call trips
        -- the new assert in vim.treesitter.get_node and throws on every Go file.
        -- Upstream master still has the typo. Re-enable when it's fixed.
        luasnip = false,
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
