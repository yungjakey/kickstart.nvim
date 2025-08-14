-- lua/custom/utils/yank_to_file.lua
local M = {}

local function get_last_yank()
  -- Prefer real “last yank” (0), then unnamed, then system clipboards
  for _, r in ipairs { '0', '"', '+', '*' } do
    local s = vim.fn.getreg(r)
    if s and s ~= '' then
      return s
    end
  end
end

local function set_ft_from_fence(buf, text)
  -- If yank begins with ```lang, set filetype accordingly
  local lang = text:match '^```(%w+)' or text:match '\n```(%w+)'
  if not lang then
    return
  end
  local map = { js = 'javascript', ts = 'typescript', yml = 'yaml', md = 'markdown' }
  vim.bo[buf].filetype = map[lang] or lang
end

local function put_text_in_current_buf(text)
  local buf = vim.api.nvim_get_current_buf()
  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(text, '\n', { plain = true }))
  vim.api.nvim_win_set_cursor(0, { 1, 1 })
  set_ft_from_fence(buf, text)
end

--- Open a new buffer/untitled and fill it with the last yank.
--- opts = { vscode_untitled = true|false, detect_ft = true|false }
function M.new_from_yank(opts)
  opts = opts or {}
  local text = get_last_yank()
  if not text then
    vim.notify('No yank found in registers 0/"/*/+', vim.log.levels.WARN)
    return
  end

  if vim.g.vscode and opts.vscode_untitled then
    -- Use VS Code’s native Untitled editor and defer write to avoid race
    vim.fn.VSCodeNotify 'workbench.action.files.newUntitledFile'
    vim.defer_fn(function()
      put_text_in_current_buf(text)
    end, 30)
  else
    vim.cmd.enew()
    put_text_in_current_buf(text)
  end
end

function M.new_named_from_yank()
  local text = get_last_yank()
  if not text then
    vim.notify('No yank found', vim.log.levels.WARN)
    return
  end
  local name = vim.fn.input 'New file name: '
  if name == '' then
    return M.new_from_yank()
  end
  vim.cmd('edit ' .. vim.fn.fnameescape(name))
  put_text_in_current_buf(text)
end

return M
