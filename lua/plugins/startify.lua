-- lua/plugins/startify.lua
-- Hitchhiker's Guide "Don't Panic" start screen, themed to match
-- ~/.config/fastfetch (same art, same pop-punk gradient, same tagline)

return {
    "mhinz/vim-startify",
    config = function()
        -- Header mirrors fastfetch/dontpanic.txt
        -- startify renders one blank line above the header, so with no
        -- leading blank here the art occupies buffer lines 2-17
        vim.g.startify_custom_header = {
            [[██████╗  ██████╗ ███╗   ██╗██╗████████╗]],
            [[██╔══██╗██╔═══██╗████╗  ██║╚═╝╚══██╔══╝]],
            [[██║  ██║██║   ██║██╔██╗ ██║      ██║]],
            [[██║  ██║██║   ██║██║╚██╗██║      ██║]],
            [[██████╔╝╚██████╔╝██║ ╚████║      ██║]],
            [[╚═════╝  ╚═════╝ ╚═╝  ╚═══╝      ╚═╝]],
            [[]],
            [[██████╗  █████╗ ███╗   ██╗██╗ ██████╗]],
            [[██╔══██╗██╔══██╗████╗  ██║██║██╔════╝]],
            [[██████╔╝███████║██╔██╗ ██║██║██║]],
            [[██╔═══╝ ██╔══██║██║╚██╗██║██║██║]],
            [[██║     ██║  ██║██║ ╚████║██║╚██████╗]],
            [[╚═╝     ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝ ╚═════╝]],
            [[]],
            [[     ·  calm is not a mindset,  ·]],
            [[     ·  calm is infrastructure  ·]],
            [[]],
        }

        -- Gradient from fastfetch config.jsonc: DON'T pink→magenta ($1-$4),
        -- PANIC bright→deep teal ($5-$8), tagline gray ($9)
        local palette = {
            { cterm = 213, gui = "#ff87ff" }, -- $1
            { cterm = 207, gui = "#ff5fff" }, -- $2
            { cterm = 201, gui = "#ff00ff" }, -- $3
            { cterm = 165, gui = "#d700ff" }, -- $4
            { cterm = 123, gui = "#87ffff" }, -- $5
            { cterm = 51,  gui = "#00ffff" }, -- $6
            { cterm = 44,  gui = "#00d7d7" }, -- $7
            { cterm = 37,  gui = "#00afaf" }, -- $8
            { cterm = 103, gui = "#8787af" }, -- $9
        }

        -- buffer line → palette index, same per-line mapping as dontpanic.txt
        local line_colors = {
            [2] = 1, [3] = 2, [4] = 2, [5] = 3, [6] = 3, [7] = 4,
            [9] = 5, [10] = 6, [11] = 6, [12] = 7, [13] = 7, [14] = 8,
            [16] = 9, [17] = 9,
        }

        -- Startify lists configuration
        vim.g.startify_lists = {
            { type = 'files',     header = {'   Recent Files'} },
            { type = 'dir',       header = {'   Current Directory: ' .. vim.fn.getcwd()} },
            { type = 'sessions',  header = {'   Sessions'} },
            { type = 'bookmarks', header = {'   Bookmarks'} },
        }

        -- Bookmarks
        vim.g.startify_bookmarks = {
            { c = '~/.config/nvim/init.lua' },
            { p = '~/.config/nvim/lua/plugins/' },
        }

        -- Session settings
        vim.g.startify_session_autoload = 0
        vim.g.startify_session_persistence = 1

        -- Other settings
        vim.g.startify_change_to_vcs_root = 1
        vim.g.startify_fortune_use_unicode = 1
        vim.g.startify_enable_special = 0
        vim.g.startify_files_number = 8

        -- Custom indices for entries
        vim.g.startify_custom_indices = { 'a', 's', 'd', 'f', 'g', 'h', 'l', 'z', 'x', 'v' }

        -- Center the startify screen
        vim.g.startify_custom_header = vim.fn['startify#center'](vim.g.startify_custom_header)

        -- Use startify's center function for lists
        vim.g.startify_relative_path = 1

        vim.api.nvim_create_autocmd("User", {
            pattern = "StartifyReady",
            callback = function()
                vim.wo.cursorline = true
            end,
        })

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "startify",
            callback = function()
                vim.opt_local.fillchars = { eob = " " }
                -- Paint the header gradient. Deferred so it lands after
                -- startify's own syntax file loads; syntax matches are
                -- buffer-local so nothing leaks into opened files.
                vim.schedule(function()
                    for i, c in ipairs(palette) do
                        vim.api.nvim_set_hl(0, "StartifyDontPanic" .. i, {
                            fg = c.gui,
                            ctermfg = c.cterm,
                        })
                    end
                    for line, idx in pairs(line_colors) do
                        vim.cmd(string.format(
                            [[syntax match StartifyDontPanic%d /\%%%dl.*/]],
                            idx, line
                        ))
                    end
                end)
            end,
        })
    end,
}
