return {
  'folke/persistence.nvim',
  event = 'BufReadPre', -- this will only start session saving when an actual file was opened
  opts = {
    -- add any custom options here
  },
  config = function(_, opts)
    require('persistence').setup(opts)

    -- Automatically load the last session when Neovim starts
    -- vim.api.nvim_create_autocmd('VimEnter', {
    --  callback = function()
    --    require('persistence').load()
    --  end,
    -- })
    -- load the session for the current directory
    vim.keymap.set('n', '<leader>..', function()
      require('persistence').load()
    end, {
      desc = 'Load session for current directory',
    })

    -- select a session to load
    vim.keymap.set('n', '<leader>.s', function()
      require('persistence').select()
    end, {
      desc = 'Select session to load',
    })

    -- stop Persistence => session won't be saved on exit
    vim.keymap.set('n', '<leader>.x', function()
      require('persistence').stop()
    end, {
      desc = 'Stop Persistence',
    })
  end,
}
