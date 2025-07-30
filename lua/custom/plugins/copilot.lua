return {
  'zbirenbaum/copilot.lua',
  event = 'InsertEnter',
  opts = {
    panel = { enabled = false },
    suggestion = {
      enabled = false,
      -- auto_trigger = true,
      -- hide_during_completion = vim.g.ai_cmp,
      -- keymap = {
      --   dismiss = '<M-S-CR>',
      --   accept = '<M-CR>',
      --   accept_line = '<M-k>',
      --   accept_word = '<M-l>',
      --   next = '<M-tab>',
      --   prev = '<M-S-tab>',
      -- },
    },
  },
}
