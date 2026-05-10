-- lua/plugins/startify.lua
-- Hitchhiker's Guide to the Galaxy themed start screen

return {
    "mhinz/vim-startify",
    config = function()
        -- Custom ASCII art header - Hitchhiker's Guide "Don't Panic" logo
        vim.g.startify_custom_header = {
            [[                                                                    ]],
            [[      ██████╗  ██████╗ ███╗   ██╗██╗████████╗                        ]],
            [[      ██╔══██╗██╔═══██╗████╗  ██║╚═╝╚══██╔══╝                        ]],
            [[      ██║  ██║██║   ██║██╔██╗ ██║      ██║                           ]],
            [[      ██║  ██║██║   ██║██║╚██╗██║      ██║                           ]],
            [[      ██████╔╝╚██████╔╝██║ ╚████║      ██║                           ]],
            [[      ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝      ╚═╝                           ]],
            [[                                                                    ]],
            [[      ██████╗  █████╗ ███╗   ██╗██╗ ██████╗                          ]],
            [[      ██╔══██╗██╔══██╗████╗  ██║██║██╔════╝                          ]],
            [[      ██████╔╝███████║██╔██╗ ██║██║██║                               ]],
            [[      ██╔═══╝ ██╔══██║██║╚██╗██║██║██║                               ]],
            [[      ██║     ██║  ██║██║ ╚████║██║╚██████╗                          ]],
            [[      ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝ ╚═════╝                          ]],
            [[                                                                    ]],
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

        -- Create centered header function
        vim.api.nvim_create_autocmd("User", {
            pattern = "StartifyReady",
            callback = function()
                vim.wo.cursorline = true
            end,
        })

        -- Center the entire buffer content
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "startify",
            callback = function()
                vim.opt_local.fillchars = { eob = " " }
            end,
        })
    end,
}
