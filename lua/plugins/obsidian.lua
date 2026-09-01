-- filename: obsidian.lua
-- path: lua/plugins/obsidian.lua

-- Floating scratch window for vault capture without leaving the current
-- buffer or cwd. Toggle: same key saves the note and closes the float;
-- a different obsidian command reuses the open float.
local float = { win = nil, cmd = nil }

-- write the float's note if it holds modified file contents;
-- returns false when the write fails (caller leaves the float open)
local function save_float_buf()
  local buf = vim.api.nvim_win_get_buf(float.win)
  if vim.bo[buf].buftype ~= "" or not vim.bo[buf].modified then
    return true
  end
  local ok, err = pcall(vim.api.nvim_buf_call, buf, function()
    vim.cmd("write")
  end)
  if not ok then
    vim.notify("obsidian float: write failed: " .. tostring(err), vim.log.levels.ERROR)
  end
  return ok
end

local function toggle_float(obsidian_cmd)
  if float.win and vim.api.nvim_win_is_valid(float.win) then
    if not save_float_buf() then
      return
    end
    if float.cmd == obsidian_cmd then
      vim.api.nvim_win_close(float.win, true)
      float.win, float.cmd = nil, nil
    else
      vim.api.nvim_set_current_win(float.win)
      float.cmd = obsidian_cmd
      vim.cmd(obsidian_cmd)
    end
    return
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = "wipe"
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  float.win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    border = "rounded",
    title = " obsidian ",
    title_pos = "center",
  })
  float.cmd = obsidian_cmd
  vim.cmd(obsidian_cmd)
end

return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  ft = "markdown",
  cmd = "Obsidian",
  keys = {
    { "<leader>oo", "<cmd>Obsidian quick_switch<cr>",     desc = "Quick switch note" },
    { "<leader>od", "<cmd>Obsidian today<cr>",            desc = "Daily note (today)" },
    { "<leader>oy", "<cmd>Obsidian yesterday<cr>",        desc = "Daily note (yesterday)" },
    { "<leader>om", "<cmd>Obsidian tomorrow<cr>",         desc = "Daily note (tomorrow)" },
    { "<leader>oD", "<cmd>Obsidian dailies<cr>",          desc = "Browse daily notes" },
    { "<leader>on", "<cmd>Obsidian new<cr>",              desc = "New note" },
    { "<leader>oN", "<cmd>Obsidian new_from_template<cr>", desc = "New note from template" },
    { "<leader>os", "<cmd>Obsidian search<cr>",           desc = "Search vault" },
    { "<leader>ot", "<cmd>Obsidian tags<cr>",             desc = "Browse tags" },
    { "<leader>oT", "<cmd>Obsidian template<cr>",         desc = "Insert template" },
    { "<leader>ob", "<cmd>Obsidian backlinks<cr>",        desc = "Backlinks" },
    { "<leader>ol", "<cmd>Obsidian links<cr>",            desc = "Links in note" },
    { "<leader>oc", "<cmd>Obsidian toggle_checkbox<cr>",  desc = "Toggle checkbox" },
    { "<leader>or", "<cmd>Obsidian rename<cr>",           desc = "Rename note (updates backlinks)" },
    { "<leader>op", "<cmd>Obsidian paste_img<cr>",        desc = "Paste image" },
    { "<leader>og", "<cmd>Obsidian open<cr>",             desc = "Open in Obsidian app" },
    { "<leader>of", function() toggle_float("Obsidian today") end, desc = "Float daily note (toggle)" },
    { "<leader>oq", function() toggle_float("Obsidian new") end,   desc = "Float quick note (toggle)" },
    { "<leader>oe", ":Obsidian extract_note<cr>", mode = "v", desc = "Extract selection to new note" },
    { "<leader>ok", ":Obsidian link<cr>",         mode = "v", desc = "Link selection to existing note" },
    { "<leader>oK", ":Obsidian link_new<cr>",     mode = "v", desc = "Link selection to new note" },
  },
  opts = {
    legacy_commands = false,
    workspaces = {
      { name = "main", path = "~/Documents/Main" },
    },
    -- mirrors the vault's .obsidian/daily-notes.json
    daily_notes = {
      folder = "60 - Journal/Daily Debrief",
      date_format = "YYYY/MM/D",
      workdays_only = false,
    },
    -- mirrors the vault's .obsidian/templates.json
    templates = {
      folder = "Templates",
      date_format = "MM-DD-YYYY",
    },
    picker = { name = "telescope.nvim" },
    -- vault uses human-readable filenames, not zettel ids
    note_id_func = function(title)
      if title and title ~= "" then
        return title
      end
      return tostring(os.time())
    end,
    -- frontmatter is managed by the Obsidian app / Hermes conventions; don't rewrite it on save
    frontmatter = { enabled = false },
  },
}
