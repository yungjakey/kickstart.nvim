-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
-- Custom keymaps using real Option key (M stands for Meta/Alt/Option in Vim keybindings)
return {
    {
        "nvim-lua/plenary.nvim",
        config = function()
            -- ...existing code...
        end
    },

    -- Dracula theme with transparent background
    {
        "Mofiqul/dracula.nvim",
        priority = 1000, -- Make sure to load this before all the other start plugins
        config = function()
            -- Configure the Dracula theme with transparent background
            require("dracula").setup({
                transparent_bg = true,
                -- Enable the theme
                colors = {
                    bg = "NONE",
                },
                -- Override specific highlight groups
                overrides = {
                    -- Add any specific highlight overrides here
                    Normal = { bg = "NONE" },
                    NormalFloat = { bg = "NONE" },
                }
            })

            -- Set the colorscheme
            vim.cmd [[colorscheme dracula]]
        end,
    },

    -- Mode indicator with custom text
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            -- Configure mode indicator with custom icons and text
            local custom_mode = {
                normal = "𝔫 ᕕ( ᐛ )ᕗ ",
                insert = "𝔦 ᕙ(´ཀ`)ᕗ ",
                visual = "𝔳 (⌐■_■)⌐ ",
                select = "𝔰 ヽ(⇀.↼)ノ",
                command = "𝔠 (╯°□°)╯ ",
                replace = "𝔯 (ﾉ≧∇≦)ﾉ ",
                terminal = "𝔱 (>^.^<)",
                inactive = "𝔦 (╯︵╰,)",
            }

            require('lualine').setup {
                options = {
                    icons_enabled = true,
                    theme = 'dracula',
                    component_separators = { left = '', right = '' },
                    section_separators = { left = '', right = '' },
                    disabled_filetypes = {},
                    always_divide_middle = true,
                    globalstatus = true,
                },
                sections = {
                    lualine_a = {
                        {
                            'mode',
                            fmt = function(str)
                                local mode_map = {
                                    ['NORMAL'] = custom_mode.normal,
                                    ['INSERT'] = custom_mode.insert,
                                    ['VISUAL'] = custom_mode.visual,
                                    ['V-LINE'] = custom_mode.visual,
                                    ['V-BLOCK'] = custom_mode.visual,
                                    ['SELECT'] = custom_mode.select,
                                    ['S-LINE'] = custom_mode.select,
                                    ['S-BLOCK'] = custom_mode.select,
                                    ['COMMAND'] = custom_mode.command,
                                    ['REPLACE'] = custom_mode.replace,
                                    ['TERMINAL'] = custom_mode.terminal,
                                }
                                return mode_map[str] or custom_mode.inactive
                            end
                        }
                    },
                    lualine_b = { 'branch', 'diff', 'diagnostics' },
                    lualine_c = { 'filename' },
                    lualine_x = { 'encoding', 'fileformat', 'filetype' },
                    lualine_y = { 'progress' },
                    lualine_z = { 'location' }
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = { 'filename' },
                    lualine_x = { 'location' },
                    lualine_y = {},
                    lualine_z = {}
                },
                tabline = {},
                extensions = {}
            }
        end
    },

    -- Custom keymaps for quitting and buffer management
    {
        "folke/which-key.nvim",
        config = function()
            -- Normal mappings (no shift)
            -- Ctrl+q to quit
            vim.keymap.set('n', '<C-q>', ':q<CR>', { noremap = true, silent = true, desc = "Quit" })
            -- Ctrl+w to close buffer
            vim.keymap.set('n', '<C-w>', ':bd<CR>', { noremap = true, silent = true, desc = "Close buffer" })
            -- Ctrl+e to save and quit
            vim.keymap.set('n', '<C-e>', ':wq<CR>', { noremap = true, silent = true, desc = "Save and quit" })

            -- Force versions with Shift
            -- Ctrl+Shift+q to force quit
            vim.keymap.set('n', '<C-S-q>', ':q!<CR>', { noremap = true, silent = true, desc = "Force quit" })
            -- Ctrl+Shift+w to force close buffer
            vim.keymap.set('n', '<C-S-w>', ':bd!<CR>', { noremap = true, silent = true, desc = "Force close buffer" })
            -- Ctrl+Shift+e to force save and quit
            vim.keymap.set('n', '<C-S-e>', ':wq!<CR>', { noremap = true, silent = true, desc = "Force save and quit" })
        end
    }
}
