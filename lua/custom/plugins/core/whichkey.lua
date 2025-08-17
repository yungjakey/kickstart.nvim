return {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
        delay = 0,
        icons = {
            mappings = vim.g.have_nerd_font,
            keys = vim.g.have_nerd_font and {} or {
                Up = '<Up> ',
                Down = '<Down> ',
                Left = '<Left> ',
                Right = '<Right> ',
                C = '<C-…> ',
                M = '<M-…> ',
                D = '<D-…> ',
                S = '<S-…> ',
                CR = '<CR> ',
                Esc = '<Esc> ',
                ScrollWheelDown = '<ScrollWheelDown> ',
                ScrollWheelUp = '<ScrollWheelUp> ',
                NL = '<NL> ',
                BS = '<BS> ',
                Space = '<Space> ',
                Tab = '<Tab> ',
                F1 = '<F1>',
                F2 = '<F2>',
                F3 = '<F3>',
                F4 = '<F4>',
                F5 = '<F5>',
                F6 = '<F6>',
                F7 = '<F7>',
                F8 = '<F8>',
                F9 = '<F9>',
                F10 = '<F10>',
                F11 = '<F11>',
                F12 = '<F12>'
            }
        },
        spec = {{
            '<leader>s',
            group = '[S]earch'
        }, {
            '<leader>t',
            group = '[T]oggle'
        }, {
            '<leader>g',
            group = '[G]it'
        }, {
            '<leader>d',
            group = '[D]iagnostics'
        }, {
            '<leader>o',
            group = '[O]pen'
        }, {
            '<leader>m',
            group = '[M]olten'
        }, {
            '<leader>l',
            group = '[L]sp'
        }, {
            '<leader>q',
            group = '[Q] Dadbod SQL'
        }, {
            '<leader>x',
            group = '[X] Swap'
        }, {
            '<leader>.',
            group = '[.] Sessions'
        }}
    }
}
