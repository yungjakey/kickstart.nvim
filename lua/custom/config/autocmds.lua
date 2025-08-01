-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'lua',
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2 -- or 4, whatever you prefer
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
  end,
})

vim.api.nvim_create_autocmd({ 'BufEnter' }, {
  callback = function(event)
    local title = 'vim'
    if event.file ~= '' then
      title = string.format('vim: %s', vim.fs.basename(event.file))
    end

    vim.fn.system { 'wezterm', 'cli', 'set-tab-title', title }
  end,
})

vim.api.nvim_create_autocmd({ 'VimLeave' }, {
  callback = function()
    vim.fn.system { 'wezterm', 'cli', 'set-tab-title', '' }
  end,
})

-- Set up the autocommand to create the keymap for specific buffer types
vim.api.nvim_create_autocmd('BufEnter', {
  group = vim.api.nvim_create_augroup('BufferKeymaps', { clear = true }),

  callback = function(ctx)
    local a = vim.api

    -- Check if buffer meets criteria for the 'q' keymap
    if
        not vim.bo[ctx.buf].modifiable or vim.bo[ctx.buf].buftype == 'nofile'
    -- Add more conditions here if needed:
    -- or vim.bo[ctx.buf].buftype == 'help'
    -- or vim.bo[ctx.buf].buftype == 'quickfix'
    -- or vim.tbl_contains({'help', 'qf', 'man'}, vim.bo[ctx.buf].filetype)
    then
      -- Create buffer-local keymap for 'q'
      vim.keymap.set('n', 'q', function()
        if #a.nvim_list_wins() > 1 then
          a.nvim_win_close(0, false) -- Close the window
        else
          vim.cmd.normal 'ga'        -- Show character info under cursor if last window
        end
      end, {
        buffer = ctx.buf,
        desc = 'Quit (or close/hide) buffer',
        silent = true,
      })
    end
  end,
})
