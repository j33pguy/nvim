-- filename: comment.lua
-- path: lua/plugins/comment.lua

return {
    "preservim/nerdcommenter",
    event = "VeryLazy",
    init = function()
        -- don't load nerdcommenter default mappings; we'll define our own
        vim.g.NERDCreateDefaultMappings = 0
        -- add a space after comment delimiters
        vim.g.NERDSpaceDelims = 1
        -- trim trailing whitespace when uncommenting
        vim.g.NERDTrimTrailingWhitespace = 1
    end,
    config = function()
        -- Normal + visual: toggle comment on selection / line
        vim.keymap.set({ "n", "x" }, "cc", "<Plug>NERDCommenterToggle", { desc = "Comment toggle" })
        -- Normal + visual: uncomment
        vim.keymap.set({ "n", "x" }, "cu", "<Plug>NERDCommenterUncomment", { desc = "Uncomment" })
        -- Normal + visual: append comment at end of line
        vim.keymap.set({ "n", "x" }, "cA", "<Plug>NERDCommenterAppend", { desc = "Comment at EOL" })
        -- Normal + visual: "sexy" (boxed) comments
        vim.keymap.set({ "n", "x" }, "cs", "<Plug>NERDCommenterSexy", { desc = "Fancy comment" })
    end,
}
