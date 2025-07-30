return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
    view_options = {
      show_hidden = true,
      natural_order = true,
      is_always_hidden = function(name, _)
        return name == '..' or name == '.git'
      end,
    },
    float = {
      padding = 2,
      max_width = 0.75,
      max_height = 0.75,
      border = 'rounded',
      win_options = {
        winblend = 0,
      },
      get_win_title = nil,
      preview_split = 'auto',
      override = function(conf)
        return conf
      end,
    },
  },
  dependencies = { { 'echasnovski/mini.icons', opts = {} } },
  lazy = false,
  config = function(_, opts)
    local oil = require 'oil'
    vim.keymap.set('n', '<C-_>', oil.toggle_float, { desc = 'Open parent directory' })
    oil.setup(opts)
  end,
}
