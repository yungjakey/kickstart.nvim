return {
    'folke/trouble.nvim',
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = 'Trouble',
    keys = {{
        '<leader>xx',
        '<cmd>Trouble diagnostics toggle focus=true<cr>',
        desc = 'Diagnostics (Trouble)'
    }, {
        '<leader>xX',
        '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
        desc = 'Buffer Diagnostics (Trouble)'
    }, {
        '<leader>xs',
        '<cmd>Trouble symbols toggle focus=false<cr>',
        desc = 'Symbols (Trouble)'
    }, {
        '<leader>xl',
        '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
        desc = 'LSP Definitions / references / ... (Trouble)'
    }, {
        '<leader>xL',
        '<cmd>Trouble loclist toggle<cr>',
        desc = 'Location List (Trouble)'
    }, {
        '<leader>xQ',
        '<cmd>Trouble qflist toggle<cr>',
        desc = 'Quickfix List (Trouble)'
    }, {
        '<leader>xt',
        '<cmd>Trouble toggle<cr>',
        desc = 'Trouble Toggle'
    }, {
        '<leader>x<leader>',
        '<cmd>lua vim.diagnostic.open_float()<CR>',
        desc = 'Show diagnostics for current line'

    }, {
        '<leader>xy',
        '<cmd>lua vim.fn.setreg("+", vim.diagnostic.get(0, {lnum = vim.fn.line(".") - 1})[1].message)<CR>',
        desc = 'Yank diagnostic message'
    }, {
        '<leader>xn',
        '<cmd>Trouble next<cr>',
        desc = 'Next Trouble'
    }, {
        '<leader>xp',
        '<cmd>Trouble previous<cr>',
        desc = 'Previous Trouble'
    }}
}
