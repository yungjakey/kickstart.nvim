return {
  'akinsho/toggleterm.nvim',
  version = '*',
  opts = {
    direction = 'float',
    start_in_insert = true,
    shade_terminals = false,
    float_opts = {
      border = 'rounded',
      width = function()
        return math.floor(vim.o.columns * 0.70)
      end,
      height = function()
        return math.floor(vim.o.lines * 0.70)
      end,
    },
  },
  config = function(_, opts)
    require('toggleterm').setup(opts)

    -- Persistent terminal IDs
    local PY_ID, SH_ID, LUA_ID = 91, 92, 93

    -- Ensure the correct REPL exists (spawn in background) and return {id, trim_spaces}
    local function ensure_repl(ft)
      if ft == 'python' then
        -- IPython: keep indentation (trim=false). --no-autoindent avoids paste issues.
        vim.cmd(string.format([[%dTermExec direction=float open=0 cmd="ipython --no-autoindent"]], PY_ID))
        return PY_ID, false
      elseif ft == 'lua' then
        vim.cmd(string.format([[%dTermExec direction=float open=0 cmd="lua"]], LUA_ID))
        return LUA_ID, true
      else
        local sh = vim.o.shell ~= '' and vim.o.shell or 'bash'
        vim.cmd(string.format([[%dTermExec direction=float open=0 cmd="%s -i"]], SH_ID, sh))
        return SH_ID, true
      end
    end

    -- Send visual selection if present; otherwise send current line
    local function send_selection_or_line()
      local id, trim = ensure_repl(vim.bo.filetype)
      local mode = vim.fn.mode()
      local send = require('toggleterm').send_lines_to_terminal
      if mode == 'v' or mode == 'V' or mode == '\22' then
        send('visual_selection', trim, { args = id })
      else
        send('single_line', trim, { args = id })
      end
    end

    -- Keymaps:
    -- 1) Primary: Ctrl+Enter (requires CSI-u encoding in WezTerm; see note above)
    vim.keymap.set({ 'n', 'v' }, '<C-CR>', send_selection_or_line, { desc = 'REPL: send selection (or line) to REPL' })

    -- 2) Fallback if <C-CR> isn’t distinguishable in your terminal:
    vim.keymap.set({ 'n', 'v' }, '<leader>rs', send_selection_or_line, { desc = 'REPL: send selection (or line) [fallback]' })
  end,
}
