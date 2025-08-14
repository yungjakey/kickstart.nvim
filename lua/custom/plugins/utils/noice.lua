return {
  -- nvim-notify: configure first
  {
    'rcarriga/nvim-notify',
    event = 'VeryLazy',
    init = function()
      -- Make notify the default ASAP so Noice and others use it
      vim.notify = require 'notify'
    end,
    opts = function()
      local bg
      local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = 'Normal', link = false })
      if ok and hl and hl.bg then
        bg = string.format('#%06x', hl.bg)
      end
      return {
        background_colour = bg or '#1e1e1e',
        stages = 'fade_in_slide_out',
        merge_duplicates = true,
        -- q/Q inside notification popups:
        on_open = function(win)
          local buf = vim.api.nvim_win_get_buf(win)
          local map = function(lhs, rhs, desc)
            vim.keymap.set('n', lhs, rhs, { buffer = buf, silent = true, nowait = true, desc = desc })
          end
          map('q', '<cmd>close<cr>', 'Dismiss notification')
          map('Q', function()
            require('notify').dismiss { silent = true, pending = true }
          end, 'Dismiss ALL notifications')
        end,
      }
    end,
  },
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = { 'rcarriga/nvim-notify', 'MunifTanjim/nui.nvim' },
    opts = {
      lsp = {
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = false,
      },
    },
    config = function(_, opts)
      require('noice').setup(opts)
    end,
  },
}
