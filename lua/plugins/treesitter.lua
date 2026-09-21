-- filename: treesitter.lua
-- path: lua/plugins/treesitter.lua

return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    branch = "master", -- legacy branch; "main" removed nvim-treesitter.configs, which this config uses
    config = function()
        local ok, configs = pcall(require, "nvim-treesitter.configs")
        if not ok then
            return
        end

        -- nvim-treesitter master ships queries/python/highlights.scm with
        -- "except*" in the keyword.exception list, but no tree-sitter-python
        -- revision emits that token -- upstream models except groups as plain
        -- "except". The whole python highlights query therefore fails to parse
        -- and python silently falls back to regex highlighting. Strip the one
        -- bad token out of whatever upstream currently ships; this turns into a
        -- no-op the moment the query is corrected.
        local qf = vim.api.nvim_get_runtime_file("queries/python/highlights.scm", false)[1]
        if qf then
            local src = table.concat(vim.fn.readfile(qf), "\n")
            local patched, n = src:gsub('%s*"except%*"', "")
            if n > 0 then
                vim.treesitter.query.set("python", "highlights", patched)
            end
        end

        configs.setup({
            ensure_installed = { "lua", "vim", "vimdoc", "go", "python", "bash", "markdown" },
            highlight = { enable = true },
            indent = { enable = true },
        })
    end,
}
