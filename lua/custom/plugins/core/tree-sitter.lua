return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'go',
        'gomod',
        'gosum',
        'python',
        'json',
        'yaml',
        'dockerfile',
        'terraform',
        'make',
        'comment',
        'regex',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
        'sql',
        'jinja',
      },
      auto_install = true,
      highlight = { enable = true, additional_vim_regex_highlighting = { 'ruby' } },
      indent = { enable = true, disable = { 'ruby' } },
      incremental_selection = {
        enable = true,
        keymaps = { init_selection = '<CR>', node_incremental = '<CR>', scope_incremental = '<S-CR>', node_decremental = '<BS>' },
      },
      textobjects = {
        select = {
          enable = true,
          keymaps = {
            ['aa'] = '@parameter.outer',
            ['ia'] = '@parameter.inner',
            ['aF'] = '@function.outer',
            ['iF'] = '@function.inner',
            ['aC'] = '@class.outer',
            ['iC'] = '@class.inner',
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = { [']p'] = '@parameter.outer', [']a'] = '@assignment.outer', [']]'] = '@class.outer', [']f'] = '@function.outer' },
          goto_next_end = { [']S'] = '@parameter.outer', [']A'] = '@assignment.outer', [']['] = '@class.outer', [']F'] = '@function.outer' },
          goto_previous_start = { ['[s'] = '@parameter.outer', ['[a'] = '@assignment.outer', ['[['] = '@class.outer', ['[f'] = '@function.outer' },
          goto_previous_end = { ['[P'] = '@parameter.outer', ['[A'] = '@assignment.outer', ['[]'] = '@class.outer', ['[F'] = '@function.outer' },
        },
        swap = {
          enable = true,
          swap_next = { ['<leader>xp'] = '@parameter.inner', ['<leader>xf'] = '@function.outer' },
          swap_previous = { ['<leader>xP'] = '@parameter.inner', ['<leader>xF'] = '@function.outer' },
        },
      },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
      local ts_repeat_move = require 'nvim-treesitter.textobjects.repeatable_move'
      vim.keymap.set({ 'n', 'x', 'o' }, ';', ts_repeat_move.repeat_last_move_next, { noremap = true, silent = true })
      vim.keymap.set({ 'n', 'x', 'o' }, ',', ts_repeat_move.repeat_last_move_previous, { noremap = true, silent = true })
      vim.treesitter.language.register('sql', 'j2sql')
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    event = 'VeryLazy', -- Ensure it's loaded early
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },
}
