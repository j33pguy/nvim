-- filename: mason.lua
-- path: lua/plugins/mason.lua

return {
    "mason-org/mason.nvim",
    dependencies = {
        "mason-org/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
    },
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("mason").setup({
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        })

        local mason_lspconfig = require("mason-lspconfig")

        mason_lspconfig.setup({
            ensure_installed = { "lua_ls", "gopls" },
            automatic_installation = true,
        })

        -- shared on_attach and capabilities
        local on_attach = function(client, bufnr)
            local bufmap = function(mode, lhs, rhs, desc)
                vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
            end

            bufmap("n", "gd", vim.lsp.buf.definition, "Goto Definition")
            bufmap("n", "gr", vim.lsp.buf.references, "References")
            bufmap("n", "K", vim.lsp.buf.hover, "Hover")
            bufmap("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
            bufmap("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
        end

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
        if ok_cmp then
            capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
        end

        -- Configure language servers via vim.lsp.config (no require("lspconfig"))
        vim.lsp.config("lua_ls", {
            on_attach = on_attach,
            capabilities = capabilities,
            settings = {
                Lua = {
                    runtime = { version = "LuaJIT" },
                    diagnostics = { globals = { "vim" } },
                    workspace = { library = vim.api.nvim_get_runtime_file("", true) },
                    telemetry = { enable = false },
                },
            },
        })

        vim.lsp.config("gopls", {
            on_attach = on_attach,
            capabilities = capabilities,
            settings = {
                gopls = {
                    analyses = { unusedparams = true },
                    staticcheck = true,
                    gofumpt = true,
                    completeUnimported = true,
                    usePlaceholders = true,
                },
            },
        })

        -- Enable the servers; they will auto-attach to matching buffers
        vim.lsp.enable("lua_ls")
        vim.lsp.enable("gopls")
    end,
}
