-- filename: autocmds.lua
-- path: lua/autocmds.lua

local api = vim.api
local lsp = vim.lsp
local cmd = vim.cmd

-- format on save via attached LSP
api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
        if lsp.buf_is_attached(0) then
            lsp.buf.format({ async = false })
        end
    end,
})

-- Trim trailing whitespace on save
api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
        cmd([[ %s/\s\+$//e ]])
    end,
})

-- Insert filename/path header for new files by filetype
api.nvim_create_autocmd("BufNewFile", {
    pattern = "*",
    callback = function()
        -- only operate on truly empty new buffers
        if vim.fn.line("$") > 1 or vim.fn.getline(1) ~= "" then
            return
        end

        local ft = vim.bo.filetype
        local comment_prefix_by_ft = {
            lua = "--",
            go = "//",
            python = "#",
            sh = "#",
            bash = "#",
            javascript = "//",
            typescript = "//",
            javascriptreact = "//",
            typescriptreact = "//",
        }

        local prefix = comment_prefix_by_ft[ft]
        if not prefix then
            return
        end

        local filename = vim.fn.expand("%:t")
        local filepath = vim.fn.expand("%")

        vim.api.nvim_buf_set_lines(0, 0, 0, false, {
            string.format("%s filename: %s", prefix, filename),
            string.format("%s path: %s", prefix, filepath),
            "",
        })
    end,
})
