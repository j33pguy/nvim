return {
    "bignimbus/pop-punk.vim",
    lazy = false,    -- load immediately for colorscheme
    priority = 1000, -- load before other plugins
    config = function()
        vim.o.background = "dark"
        vim.cmd.colorscheme("pop-punk")
    end,
}
