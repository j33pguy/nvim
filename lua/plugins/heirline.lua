-- lua/plugins/heirline.lua
return {
    "rebelot/heirline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local conditions = require("heirline.conditions")
        local utils = require("heirline.utils")

        -- pulled from the active colorscheme so the statusline follows
        -- `omarchy theme set`. components reference these by name.
        local function setup_colors()
            local hl = function(name) return utils.get_highlight(name) end
            return {
                bg     = hl("Normal").bg or "black",
                fg     = hl("Normal").fg,
                red    = hl("DiagnosticError").fg,
                green  = hl("String").fg,
                yellow = hl("DiagnosticWarn").fg,
                blue   = vim.g.terminal_color_4 or hl("DiagnosticInfo").fg,
                purple = hl("Directory").fg,
                cyan   = hl("Function").fg,
                gray   = hl("LineNr").fg,
            }
        end

        local Space = { provider = " " }
        local Align = { provider = "%=" }

        local ViMode = {
            provider = function()
                local mode = vim.fn.mode(1):sub(1, 1):upper()
                return " " .. mode .. " "
            end,
            hl = function()
                local mode_color = {
                    n = "blue",
                    i = "green",
                    v = "yellow",
                    V = "yellow",
                    [""] = "yellow",
                    c = "red",
                    s = "purple",
                    S = "purple",
                    [""] = "purple",
                    R = "red",
                    r = "red",
                    ["!"] = "red",
                    t = "cyan",
                }
                return { fg = "bg", bg = mode_color[vim.fn.mode()] or "gray", bold = true }
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
                return { fg = color or "cyan" }
            end,
        }

        local FileName = {
            provider = function(self)
                local fname = vim.fn.fnamemodify(self.filename, ":t")
                return fname == "" and "[No Name]" or fname
            end,
            hl = { fg = "cyan", bold = true },
        }

        local FileFlags = {
            {
                condition = function() return vim.bo.modified end,
                provider = "  ●  ",
                hl = { fg = "green" },
            },
            {
                condition = function() return not vim.bo.modifiable or vim.bo.readonly end,
                provider = "    ",
                hl = { fg = "red" },
            },
        }

        local Git = {
            condition = conditions.is_git_repo,
            init = function(self)
                self.status_dict = vim.b.gitsigns_status_dict or {}
            end,
            hl = { fg = "purple" },
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
                hl = { fg = "green" },
            },
            {
                provider = function(self)
                    local changed = self.status_dict.changed or 0
                    return changed > 0 and ("   " .. changed .. "  ") or ""
                end,
                hl = { fg = "yellow" },
            },
            {
                provider = function(self)
                    local removed = self.status_dict.removed or 0
                    return removed > 0 and ("   " .. removed .. "  ") or ""
                end,
                hl = { fg = "red" },
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
            hl = { fg = "gray" },
            {
                provider = function(self) return self.errors > 0 and
                    ("  " .. self.error_icon .. " " .. self.errors .. "  ") end,
                hl = { fg = "red" },
            },
            {
                provider = function(self) return self.warnings > 0 and
                    ("  " .. self.warn_icon .. " " .. self.warnings .. "  ") end,
                hl = { fg = "yellow" },
            },
            {
                provider = function(self) return self.info > 0 and ("  " .. self.info_icon .. " " .. self.info .. "  ") end,
                hl = { fg = "blue" },
            },
            {
                provider = function(self) return self.hints > 0 and
                    ("  " .. self.hint_icon .. " " .. self.hints .. "  ") end,
                hl = { fg = "cyan" },
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
            hl = { fg = "green" },
        }

        local FileType = {
            provider = function() return "  " .. vim.bo.filetype:upper() .. "  " end,
            hl = { fg = "gray", bold = true },
        }

        local Position = {
            provider = "  %3l:%-2c %p%%  ",
            hl = { fg = "cyan" },
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
            opts = { colors = setup_colors },
        })

        vim.api.nvim_create_autocmd("ColorScheme", {
            group = vim.api.nvim_create_augroup("heirline_colors", { clear = true }),
            callback = function() utils.on_colorscheme(setup_colors) end,
        })
    end,
}
