-- filename: treesitter.lua
-- path: lua/plugins/treesitter.lua

return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    branch = "main", -- or remove if you want latest
    config = function()
        local ok, configs = pcall(require, "nvim-treesitter.configs")
        if not ok then
            return
        end

        configs.setup({
            ensure_installed = { "lua", "vim", "vimdoc", "go", "python", "bash", "markdown" },
            highlight = { enable = true },
            indent = { enable = true },
        })
    end,
}
