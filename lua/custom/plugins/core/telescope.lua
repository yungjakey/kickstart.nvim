return {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {'nvim-lua/plenary.nvim', {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
            return vim.fn.executable 'make' == 1
        end
    }, {'nvim-telescope/telescope-ui-select.nvim'}, {
        'nvim-tree/nvim-web-devicons',
        enabled = vim.g.have_nerd_font
    }, -- load undo extension only in real Neovim (not VSCode)
    {
        'debugloop/telescope-undo.nvim',
        cond = function()
            return not vim.g.vscode
        end
    }},
    config = function()
        local telescope = require 'telescope'
        local actions = require 'telescope.actions'

        telescope.setup {
            defaults = {
                mappings = {
                    n = {
                        ['q'] = actions.close,
                        ['<esc>'] = actions.close
                    },
                    i = {
                        ['<C-c>'] = actions.close,
                        ['<esc>'] = actions.close
                    }
                }
            },
            extensions = {
                ['ui-select'] = require('telescope.themes').get_dropdown(),
                ['undo'] = {
                    layout_strategy = 'horizontal',
                    layout_config = {
                        preview_width = 0.85
                    },
                    entry_format = '($STAT) $TIME'
                }
            }
        }

        pcall(telescope.load_extension, 'fzf')
        pcall(telescope.load_extension, 'ui-select')

        local builtin = require 'telescope.builtin'
        vim.keymap.set('n', '<leader>sh', builtin.help_tags, {
            desc = '[S]earch [H]elp'
        })
        vim.keymap.set('n', '<leader>sk', builtin.keymaps, {
            desc = '[S]earch [K]eymaps'
        })
        vim.keymap.set('n', '<leader>sf', builtin.find_files, {
            desc = '[S]earch [F]iles'
        })
        vim.keymap.set('n', '<leader>ss', builtin.builtin, {
            desc = '[S]earch [S]elect Telescope'
        })
        vim.keymap.set('n', '<leader>sw', builtin.grep_string, {
            desc = '[S]earch current [W]ord'
        })
        vim.keymap.set('n', '<leader>sg', builtin.live_grep, {
            desc = '[S]earch [G]rep'
        })
        vim.keymap.set('n', '<leader>sd', builtin.diagnostics, {
            desc = '[S]earch [D]iagnostics'
        })
        vim.keymap.set('n', '<leader>sc', builtin.resume, {
            desc = '[S]earch [C]ontinue'
        })
        vim.keymap.set('n', '<leader>sr', builtin.oldfiles, {
            desc = '[S]earch [R]ecent Files'
        })
        vim.keymap.set('n', '<leader><leader>', builtin.buffers, {
            desc = '[ ] Find existing buffers'
        })
        vim.keymap.set('n', '<leader>/', function()
            builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
                winblend = 10,
                previewer = false
            })
        end, {
            desc = '[/] Fuzzily search in current buffer'
        })
        vim.keymap.set('n', '<leader>s/', function()
            builtin.live_grep {
                grep_open_files = true,
                prompt_title = 'Live Grep in Open Files'
            }
        end, {
            desc = '[S]earch [/] in Open Files'
        })
        vim.keymap.set('n', '<leader>sn', function()
            builtin.find_files {
                cwd = vim.fn.stdpath 'config'
            }
        end, {
            desc = '[S]earch [N]eovim files'
        })

        -- Smart undo history:
        -- - VSCode: open Local History picker (native, reliable)
        -- - Neovim: open telescope-undo
        if not vim.g.vscode then
            pcall(telescope.load_extension, 'undo')
            func = require('telescope').extensions.undo.undo
        else
            func = function()
                vim.fn.VSCodeNotify 'workbench.action.localHistory.showHistory'
            end
        end

        vim.keymap.set('n', '<leader>su', function()
            func()
        end, {
            desc = '[S]earch [U]ndo History',
            silent = true
        })
    end
}
