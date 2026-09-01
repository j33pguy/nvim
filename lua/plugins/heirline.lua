-- lua/plugins/heirline.lua
return {
    "rebelot/heirline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local conditions = require("heirline.conditions")
        local utils = require("heirline.utils")

        local colors = {
            bg     = utils.get_highlight("Normal").bg,
            fg     = utils.get_highlight("Normal").fg,
            red    = "#ff005f",
            green  = "#5ff967",
            yellow = "#ffdd00",
            blue   = "#0088ff",
            purple = "#c526ff",
            cyan   = "#40e0d0",
            gray   = "#767c88",
        }

        local Space = { provider = " " }
        local Align = { provider = "%=" }

        local ViMode = {
            provider = function()
                local mode = vim.fn.mode(1):sub(1, 1):upper()
                return " " .. mode .. " "
            end,
            hl = function()
                local mode_color = {
                    n = colors.blue,
                    i = colors.green,
                    v = colors.yellow,
                    V = colors.yellow,
                    [""] = colors.yellow,
                    c = colors.red,
                    s = colors.purple,
                    S = colors.purple,
                    [""] = colors.purple,
                    R = colors.red,
                    r = colors.red,
                    ["!"] = colors.red,
                    t = colors.cyan,
                }
                return { fg = "black", bg = mode_color[vim.fn.mode()] or colors.gray, bold = true }
            end,
            update = { "ModeChanged" },
        }

        local FileIcon = {
            init = function(self)
                self.filename = vim.api.nvim_buf_get_name(0)
            end,
            provider = function(self)
                local icon = require("nvim-web-devicons").get_icon(self.filename) or ""
                return "  " .. icon .. "  "
            end,
            hl = function(self)
                local _, color = require("nvim-web-devicons").get_icon_color(self.filename)
                return { fg = color or colors.cyan }
            end,
        }

        local FileName = {
            provider = function(self)
                local fname = vim.fn.fnamemodify(self.filename, ":t")
                return fname == "" and "[No Name]" or fname
            end,
            hl = { fg = colors.cyan, bold = true },
        }

        local FileFlags = {
            {
                condition = function() return vim.bo.modified end,
                provider = "  ●  ",
                hl = { fg = colors.green },
            },
            {
                condition = function() return not vim.bo.modifiable or vim.bo.readonly end,
                provider = "    ",
                hl = { fg = colors.red },
            },
        }

        local Git = {
            condition = conditions.is_git_repo,
            init = function(self)
                self.status_dict = vim.b.gitsigns_status_dict or {}
            end,
            hl = { fg = colors.purple },
            {
                provider = function(self)
                    return "   " .. (self.status_dict.head or "") .. "  "
                end,
            },
            {
                provider = function(self)
                    local added = self.status_dict.added or 0
                    return added > 0 and ("   " .. added .. "  ") or ""
                end,
                hl = { fg = colors.green },
            },
            {
                provider = function(self)
                    local changed = self.status_dict.changed or 0
                    return changed > 0 and ("   " .. changed .. "  ") or ""
                end,
                hl = { fg = colors.yellow },
            },
            {
                provider = function(self)
                    local removed = self.status_dict.removed or 0
                    return removed > 0 and ("   " .. removed .. "  ") or ""
                end,
                hl = { fg = colors.red },
            },
        }

        local Diagnostics = {
            condition = conditions.has_diagnostics,
            static = {
                error_icon = "",
                warn_icon  = "",
                info_icon  = "",
                hint_icon  = "",
            },
            init = function(self)
                self.errors   = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
                self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
                self.info     = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
                self.hints    = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
            end,
            update = { "DiagnosticChanged", "BufEnter" },
            hl = { fg = colors.gray },
            {
                provider = function(self) return self.errors > 0 and
                    ("  " .. self.error_icon .. " " .. self.errors .. "  ") end,
                hl = { fg = colors.red },
            },
            {
                provider = function(self) return self.warnings > 0 and
                    ("  " .. self.warn_icon .. " " .. self.warnings .. "  ") end,
                hl = { fg = colors.yellow },
            },
            {
                provider = function(self) return self.info > 0 and ("  " .. self.info_icon .. " " .. self.info .. "  ") end,
                hl = { fg = colors.blue },
            },
            {
                provider = function(self) return self.hints > 0 and
                    ("  " .. self.hint_icon .. " " .. self.hints .. "  ") end,
                hl = { fg = colors.cyan },
            },
        }

        local LSP = {
            condition = conditions.lsp_attached,
            provider = function()
                local names = {}
                for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
                    table.insert(names, client.name)
                end
                return "   " .. table.concat(names, ",") .. "  "
            end,
            hl = { fg = colors.green },
        }

        local FileType = {
            provider = function() return "  " .. vim.bo.filetype:upper() .. "  " end,
            hl = { fg = colors.gray, bold = true },
        }

        local Position = {
            provider = "  %3l:%-2c %p%%  ",
            hl = { fg = colors.cyan },
        }

        local StatusLine = {
            ViMode,
            FileIcon,
            FileName,
            FileFlags,
            Align,
            Git,
            Align,
            Diagnostics,
            Align,
            LSP,
            FileType,
            Position,
        }

        require("heirline").setup({
            statusline = StatusLine,
            colors = colors,
        })

        vim.api.nvim_create_autocmd("ColorScheme", {
            callback = function() utils.on_colorscheme(colors) end,
        })
    end,
}
