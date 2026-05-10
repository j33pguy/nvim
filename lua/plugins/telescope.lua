-- filename: telescope.lua
-- path: lua/plugins/telescope.lua

return {
	"nvim-telescope/telescope.nvim",
	branch = "master",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		{ "<leader>sf", "<cmd>Telescope find_files<cr>",             desc = "Find Files" },
		{ "<leader>sh", "<cmd>Telescope find_files hidden=true<cr>", desc = "Find Hidden Files" },
		{ "<leader>sg", "<cmd>Telescope live_grep<cr>",              desc = "Live Grep" },
		{ "<leader>sw", "<cmd>Telescope grep_string<cr>",            desc = "Grep Word" },
	},
	opts = {
		defaults = {
			layout_strategy = "horizontal",
			mappings = {
				i = { ["<C-j>"] = "move_selection_next", ["<C-k>"] = "move_selection_previous" },
			},
		},
	},
}
