-- claude-tutor: bridge Neovim → local `claude` CLI (Claude Max plan, no API key).
--
-- - One-shot binds (<leader>ah/ae/af/aw/at) run `claude -p <prompt>` and show
--   the response in a floating window. Each is independent — no conversation state.
-- - Interactive binds (<leader>ac chat, <leader>aq quiz) open `claude` in a
--   terminal split, with an optional seed message for the quiz.
-- - Project CLAUDE.md + .claude/tutor-prompt.md enforce tutor mode automatically;
--   claude reads them from CWD.

local M = {}

local function find_project_root()
  local current = vim.fn.expand("%:p:h")
  if current == "" then current = vim.fn.getcwd() end
  local search = current
  for _ = 1, 20 do
    if vim.fn.filereadable(search .. "/CLAUDE.md") == 1
       or vim.fn.isdirectory(search .. "/.claude") == 1 then
      return search
    end
    local parent = vim.fn.fnamemodify(search, ":h")
    if parent == search then break end
    search = parent
  end
  return vim.fn.getcwd()
end

local function get_visual_selection()
  local s_line = vim.fn.line("'<")
  local e_line = vim.fn.line("'>")
  if s_line == 0 or e_line == 0 then return nil end
  local lines = vim.fn.getline(s_line, e_line)
  if type(lines) == "string" then lines = { lines } end
  if #lines == 0 then return nil end
  return table.concat(lines, "\n"), s_line, e_line
end

local function get_context(scope)
  local bufnr = vim.api.nvim_get_current_buf()
  local filepath = vim.api.nvim_buf_get_name(bufnr)
  local rel = vim.fn.fnamemodify(filepath, ":.")

  if scope == "selection" then
    local sel, s, e = get_visual_selection()
    if sel and sel ~= "" then
      return rel, sel, ("lines %d-%d"):format(s, e)
    end
    local lnum = vim.api.nvim_win_get_cursor(0)[1]
    local line = vim.api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, false)[1] or ""
    return rel, line, ("line %d"):format(lnum)
  end

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  return rel, table.concat(lines, "\n"), "whole file"
end

local function open_float(title)
  local buf = vim.api.nvim_create_buf(false, true)
  local width = math.min(110, math.floor(vim.o.columns * 0.85))
  local height = math.min(32, math.floor(vim.o.lines * 0.7))
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = " " .. title .. " ",
    title_pos = "center",
  })
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].filetype = "markdown"
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "thinking…" })
  vim.bo[buf].modifiable = false
  vim.keymap.set("n", "q",     "<cmd>close<cr>", { buffer = buf, silent = true })
  vim.keymap.set("n", "<esc>", "<cmd>close<cr>", { buffer = buf, silent = true })
  return buf, win
end

function M.run_claude(prompt, scope)
  local filepath, content, location = get_context(scope)
  local lang = vim.bo.filetype ~= "" and vim.bo.filetype or "text"
  local full_prompt = ("%s\n\nFile: `%s`\nContext: %s\n\n```%s\n%s\n```"):format(
    prompt, filepath, location, lang, content
  )
  local buf, _ = open_float("claude · tutor")
  local root = find_project_root()
  vim.system(
    { "claude", "-p", full_prompt },
    { text = true, cwd = root },
    function(result)
      vim.schedule(function()
        if not vim.api.nvim_buf_is_valid(buf) then return end
        local output
        if result.code ~= 0 then
          output = ("claude exited with code %d\n\nstderr:\n%s"):format(
            result.code, result.stderr or ""
          )
        else
          output = result.stdout or "(no output)"
        end
        local lines = vim.split(output, "\n", { plain = true })
        vim.bo[buf].modifiable = true
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        vim.bo[buf].modifiable = false
      end)
    end
  )
end

function M.open_chat(seed)
  local root = find_project_root()
  vim.cmd("botright split")
  vim.cmd("resize " .. math.floor(vim.o.lines * 0.45))
  local cmd
  if seed and seed ~= "" then
    cmd = ("cd %s && claude %s"):format(
      vim.fn.shellescape(root), vim.fn.shellescape(seed)
    )
  else
    cmd = ("cd %s && claude"):format(vim.fn.shellescape(root))
  end
  -- fullscreen (alt-screen) renderer: nvim's terminal emulator can't keep up
  -- with claude's default scrollback renderer (doubled input box, ghost UI)
  vim.fn.termopen(cmd, { env = { CLAUDE_CODE_NO_FLICKER = "1" } })
  vim.cmd("startinsert")
end

function M.quiz_current_file()
  local filepath, content, _ = get_context("file")
  local seed = ("quiz me on this file to verify i actually understand it. " ..
    "ask 3-5 questions ONE AT A TIME, waiting for my answer before the next one. " ..
    "cover: why this data structure, time complexity, edge cases, alternative approaches, " ..
    "and have me explain the code in plain english as if in a code review. " ..
    "if i get one wrong, nudge me to the right answer — do not just tell me. " ..
    "end when you are satisfied i could re-derive this cold tomorrow.\n\n" ..
    "file: %s\n\n```python\n%s\n```"):format(filepath, content)
  M.open_chat(seed)
end

_G.ClaudeTutor = M

return {
  dir = vim.fn.stdpath("config"),
  name = "claude-tutor",
  lazy = false,
  keys = {
    { "<leader>ac", function() M.open_chat() end, mode = "n", desc = "Claude: chat panel" },
    {
      "<leader>ah",
      function()
        M.run_claude(
          "give me a single nudge here — do not write code, do not name the bug, just one question that helps me see it",
          "selection"
        )
      end,
      mode = { "n", "v" },
      desc = "Claude: hint (nudge)",
    },
    {
      "<leader>ae",
      function()
        M.run_claude(
          "trace through what my code does with a small concrete input — show me each step. do not fix it",
          "selection"
        )
      end,
      mode = { "n", "v" },
      desc = "Claude: trace my code",
    },
    {
      "<leader>af",
      function()
        M.run_claude(
          "look at this whole file — the docstring is the problem, my code so far is below it. " ..
          "give me one nudge about my approach or direction. do not write code. do not name the algorithm. " ..
          "if i haven't started, ask what data structure i think fits and why",
          "file"
        )
      end,
      mode = "n",
      desc = "Claude: file-level nudge",
    },
    {
      "<leader>aw",
      function()
        M.run_claude(
          "explain the concept i am trying to use here in 2-3 sentences, then ask me how i would apply it to this problem",
          "selection"
        )
      end,
      mode = { "n", "v" },
      desc = "Claude: explain concept",
    },
    {
      "<leader>at",
      function()
        M.run_claude(
          "ask me to describe in plain english what this problem is asking for, before i write any code",
          "file"
        )
      end,
      mode = "n",
      desc = "Claude: think out loud first",
    },
    {
      "<leader>aq",
      function() M.quiz_current_file() end,
      mode = "n",
      desc = "Claude: comprehension quiz",
    },
  },
}
