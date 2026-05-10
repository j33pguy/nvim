-- filename: neo-tree.lua
-- path: lua/plugins/neo-tree.lua

return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    keys = {
        { "<leader>nt", "<cmd>Neotree toggle<cr>", desc = "Toggle Neo-tree" },
    },
    opts = {
        close_if_last_window = true,
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,
        default_component_configs = {
            indent = { indent_size = 2, padding = 1, with_markers = true },
            icon = {
                folder_closed = "",
                folder_open = "",
                folder_empty = "",
                default = "",
                highlight = "NeoTreeFileIcon",
            },
            modified = { symbol = "[+] ", highlight = "NeoTreeModified" },
            git_status = {
                symbols = {
                    added     = "✚",
                    modified  = "",
                    deleted   = "✖",
                    renamed   = "󰁕",
                    untracked = "",
                    ignored   = "",
                    unstaged  = "󰄱",
                    staged    = "",
                    conflict  = "",
                },
            },
        },
        window = {
            width = 35,
            position = "left",
            mappings = {
                ["<space>"] = "toggle_node",
                ["<2-LeftMouse>"] = "open",
                ["<cr>"] = "open",
                ["o"] = "open",
                ["s"] = "open_split",
                ["v"] = "open_vsplit",
                ["t"] = "open_tabnew",
                ["a"] = "add",
                ["A"] = "add_directory",
                ["d"] = "delete",
                ["r"] = "rename",
                ["y"] = "copy_to_clipboard",
                ["x"] = "cut_to_clipboard",
                ["p"] = "paste_from_clipboard",
                ["c"] = "copy",
                ["m"] = "move",
                ["q"] = "close_window",
                ["R"] = "refresh",
                ["?"] = "show_help",
                ["H"] = "toggle_hidden",
                ["/"] = "fuzzy_finder",
            },
        },
        filesystem = {
            filtered_items = {
                hide_dotfiles = false,
                hide_gitignored = true,
                hide_by_name = { ".DS_Store", "thumbs.db" },
                never_show = { ".git" },
            },
            follow_current_file = { enabled = true, leave_dirs_open = true },
            use_libuv_file_watcher = true,
            hijack_netrw_behavior = "open_default",
        },
        buffers = { follow_current_file = { enabled = true } },
        git_status = { window = { position = "float" } },
    }
}
