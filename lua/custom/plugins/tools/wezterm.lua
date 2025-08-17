return {
  'zsh-sage/wezterm-send.nvim',
  dependencies = {
    'willothy/wezterm.nvim',
    config = true,
  },
  config = function()
    -- Set up wezterm-send if needed
    -- require("wezterm-send").setup() -- Uncomment if the plugin requires setup

    -- Keymap: Send current line to Wezterm
    vim.keymap.set('n', '<M-CR>', function()
      vim.cmd('WeztermSendJson ' .. vim.fn.shellescape(vim.fn.getline '.'))
    end, { desc = 'Send current line to Wezterm' })

    -- Keymap: Send selection to Wezterm as JSON
    vim.keymap.set('x', '<M-CR>', function()
      local selected_lines = vim.fn.getregion(vim.fn.getpos 'v', vim.fn.getpos '.')
      for _, line in ipairs(selected_lines) do
        vim.cmd('WeztermExecJson ' .. line .. '\n')
      end
    end, { desc = 'Send selection to Wezterm as JSON' })
  end,
}
