return {
  {
    'NeogitOrg/neogit',
    cmd = 'Neogit',
    dependencies = { 'nvim-lua/plenary.nvim' }, -- required by neogit
    opts = {
      -- keep defaults minimal; tweak later if you want
      disable_hint = false,
      -- you can adjust popup/display kinds here if you prefer
      -- e.g. popup = { kind = "split" },
    },
    keys = {
      {
        '<leader>gg',
        function()
          require('neogit').open {
            kind = 'split',
          }
        end,
        desc = 'Git: Neogit status (split)',
      },
      {
        '<leader>gc',
        function()
          require('neogit').open { 'commit' }
        end,
        desc = 'Git: Commit popup',
      },
      {
        '<leader>gl',
        function()
          require('neogit').open { 'log' }
        end,
        desc = 'Git: Log popup',
      },
      {
        '<leader>gP',
        function()
          require('neogit').open { 'push' }
        end,
        desc = 'Git: Push popup',
      },
      {
        '<leader>gF',
        function()
          require('neogit').open { 'fetch' }
        end,
        desc = 'Git: Fetch popup',
      },
      {
        '<leader>gb',
        function()
          require('neogit').open { 'branch' }
        end,
        desc = 'Git: Branch popup',
      },
    },
  }, -- 2) Gitsigns: per-buffer hunks, blame, diff
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      signs = {
        add = {
          text = '┃',
        },
        change = {
          text = '┃',
        },
        delete = {
          text = '_',
        },
        topdelete = {
          text = '‾',
        },
        changedelete = {
          text = '~',
        },
        untracked = {
          text = '┆',
        },
      },
      signs_staged_enable = true,
      current_line_blame = false, -- toggle via <leader>gB
      -- word_diff = true,        -- enable if you like intra-line diff
    },
    keys = { -- Hunks
      {
        '<leader>gs',
        function()
          require('gitsigns').stage_hunk()
        end,
        desc = 'Git: stage hunk',
      },
      {
        '<leader>gr',
        function()
          require('gitsigns').reset_hunk()
        end,
        desc = 'Git: reset hunk',
      },
      {
        '<leader>gS',
        function()
          require('gitsigns').stage_buffer()
        end,
        desc = 'Git: stage buffer',
      },
      {
        '<leader>gR',
        function()
          require('gitsigns').reset_buffer()
        end,
        desc = 'Git: reset buffer',
      },
      {
        '<leader>gp',
        function()
          require('gitsigns').preview_hunk()
        end,
        desc = 'Git: preview hunk',
      }, -- Blame / Diff
      {
        '<leader>gx',
        function()
          require('gitsigns').blame_line {
            full = true,
          }
        end,
        desc = 'Git: blame line (popup)',
      },
      {
        '<leader>gX',
        function()
          require('gitsigns').toggle_current_line_blame()
        end,
        desc = 'Git: toggle inline blame',
      },
      {
        '<leader>gd',
        function()
          require('gitsigns').diffthis()
        end,
        desc = 'Git: diff vs index',
      },
      {
        '<leader>gD',
        function()
          require('gitsigns').diffthis '~'
        end,
        desc = 'Git: diff vs ~',
      },
    },
  },
}
