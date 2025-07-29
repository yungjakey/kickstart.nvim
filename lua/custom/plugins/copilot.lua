return {
  {
    'github/copilot.vim',
    lazy = false,
    config = function() -- Mapping tab is already used in NvChad
      vim.keymap.set('i', '<C-CR>', 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false
      })
      vim.keymap.set('i', '<C-Right>', '<Plug>(copilot-accept-word)')
      vim.keymap.set('i', '<C-Down>', '<Plug>(copilot-accept-line)')
      vim.g.copilot_no_tab_map = true    -- Disable tab mapping
      vim.g.copilot_assume_mapped = true -- Assume that the mapping is already done
    end,
  },
}
