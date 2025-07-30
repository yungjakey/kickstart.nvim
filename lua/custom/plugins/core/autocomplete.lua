return {
    {
        "zbirenbaum/copilot.lua",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                suggestion = { enabled = false },
                panel = { enabled = false },
            })
        end,
    },
    {
        "giuxtaposition/blink-cmp-copilot",
        after = "copilot.lua"
    },
    { -- Autocompletion
        'saghen/blink.cmp',
        event = 'VimEnter',
        version = '1.*',
        dependencies = {
            {
                'L3MON4D3/LuaSnip',
                version = '2.*',
                build = (function()
                    if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then return end
                    return 'make install_jsregexp'
                end)(),
                dependencies = {},
                opts = {},
            },
            'folke/lazydev.nvim',
        },
        opts = {
            keymap = { preset = 'enter', ['<M-ESC>'] = { 'hide' }, ['<M-CR>'] = { 'show', 'show_documentation', 'hide_documentation' } },
            appearance = { nerd_font_variant = 'mono', kind_icons = { Copilot = '', Text = '󰉿', Method = '󰊕', Function = '󰊕', Constructor = '󰒓', Field = '󰜢', Variable = '󰆦', Property = '󰖷', Class = '󱡠', Interface = '󱡠', Struct = '󱡠', Module = '󰅩', Unit = '󰪚', Value = '󰦨', Enum = '󰦨', EnumMember = '󰦨', Keyword = '󰻾', Constant = '󰏿', Snippet = '󱄽', Color = '󰏘', File = '󰈔', Reference = '󰬲', Folder = '󰉋', Event = '󱐋', Operator = '󰪚', TypeParameter = '󰬛', } },
            completion = { documentation = { auto_show = false, auto_show_delay_ms = 500 }, menu = { max_height = 15, direction_priority = { 'n', 's' }, scrollbar = false } },
            sources = {
                default = { 'lazydev', 'lsp', 'path', 'snippets', 'copilot' },
                providers = {
                    lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
                    copilot = {
                        name = 'copilot',
                        module = 'blink-cmp-copilot',
                        score_offset = 100,
                        async = true,
                        transform_items = function(
                            _, items)
                            local CompletionItemKind = require('blink.cmp.types').CompletionItemKind
                            local kind_idx = #CompletionItemKind + 1
                            CompletionItemKind[kind_idx] = 'Copilot'
                            for _, item in ipairs(items) do item.kind = kind_idx end
                            return items
                        end,
                    },
                },
            },
            snippets = { preset = 'luasnip' },
            fuzzy = { implementation = 'lua' },
            signature = { enabled = true },
        },
    },
}
