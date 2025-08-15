return {
    'folke/trouble.nvim',
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = 'Trouble',
    keys = {{
        '<leader>dx',
        '<cmd>Trouble diagnostics toggle focus=true<cr>',
        desc = 'Diagnostics (Trouble)'
    }, {
        '<leader>dX',
        '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
        desc = 'Buffer Diagnostics (Trouble)'
    }, {
        '<leader>ds',
        '<cmd>Trouble symbols toggle focus=false<cr>',
        desc = 'Symbols (Trouble)'
    }, {
        '<leader>dl',
        '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
        desc = 'LSP Definitions / references / ... (Trouble)'
    }, {
        '<leader>dL',
        '<cmd>Trouble loclist toggle<cr>',
        desc = 'Location List (Trouble)'
    }, {
        '<leader>dQ',
        '<cmd>Trouble qflist toggle<cr>',
        desc = 'Quickfix List (Trouble)'
    }, {
        '<leader>dt',
        '<cmd>Trouble toggle<cr>',
        desc = 'Trouble Toggle'
    }, {
        '<leader>d<leader>',
        '<cmd>lua vim.diagnostic.open_float()<CR>',
        desc = 'Show diagnostics for current line'

    }, {
        '<leader>dy',
        '<cmd>lua vim.fn.setreg("+", vim.diagnostic.get(0, {lnum = vim.fn.line(".") - 1})[1].message)<CR>',
        desc = 'Yank diagnostic message'
    }, {
        '<leader>dn',
        '<cmd>Trouble next<cr>',
        desc = 'Next Trouble'
    }, {
        '<leader>dp',
        '<cmd>Trouble previous<cr>',
        desc = 'Previous Trouble'
    }, {
        '<leader>dq',
        '<cmd>lua vim.diagnostic.setloclist()<CR>',
        desc = 'Quickfix list'
    }}
}
