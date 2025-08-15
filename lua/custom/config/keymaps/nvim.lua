-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`
-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- delete word backwards
vim.keymap.set('i', '<M-BS>', '<C-w>')

vim.keymap.set('n', '<leader>p', vim.api.nvim_buf_get_name(0), {
    desc = 'Get filepath'
}) -- select all

-- _select all
vim.keymap.set('n', '<C-a>', 'gg<S-v>G', {
    desc = 'Select all'
})

-- opencode
vim.keymap.set('n', '<leader>oc', ':vsplit | term opencode<CR>', {
    desc = 'Open code in right split (40%)'
})

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, {
    desc = 'Open diagnostic [Q]uickfix list'
})

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', {
    desc = 'Exit terminal mode'
})
vim.keymap.set('n', '<leader><C-q>', ':q<CR>', {
    noremap = true,
    silent = true,
    desc = 'Quit'
})
vim.keymap.set('n', '<leader><C-w>', ':w<CR>', {
    noremap = true,
    silent = true,
    desc = 'Close buffer'
})
vim.keymap.set('n', '<leader><C-S-q>', ':q!<CR>', {
    noremap = true,
    silent = true,
    desc = 'Force quit'
})
vim.keymap.set('n', '<leader><C-S-w>', ':wq!<CR>', {
    noremap = true,
    silent = true,
    desc = 'Force close buffer'
})
-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', {
    desc = 'Move focus to the left window'
})
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', {
    desc = 'Move focus to the right window'
})
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', {
    desc = 'Move focus to the lower window'
})
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', {
    desc = 'Move focus to the upper window'
})

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
vim.keymap.set('n', '<C-S-h>', '<C-w>H', {
    desc = 'Move window to the left'
})
vim.keymap.set('n', '<C-S-l>', '<C-w>L', {
    desc = 'Move window to the right'
})
vim.keymap.set('n', '<C-S-j>', '<C-w>J', {
    desc = 'Move window to the lower'
})
vim.keymap.set('n', '<C-S-k>', '<C-w>K', {
    desc = 'Move window to the upper'
})

-- local functions = require 'custom.config.functions'
-- vim.keymap.set('n', '<leader>yn', function()
--   functions.new_from_yank { vscode_untitled = false }
-- end, { desc = 'New file from last yank' })
-- vim.keymap.set('n', '<leader>yN', functions.new_named_from_yank, { desc = 'New *named* file from last yank' })
