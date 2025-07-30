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
