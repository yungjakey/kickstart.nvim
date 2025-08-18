return {{
    'folke/trouble.nvim',
    opts = {
        modes = {
            preview_float = {
                mode = "diagnostics",
                preview = {
                    type = "float",
                    relative = "editor",
                    border = "rounded",
                    title = "Preview",
                    title_pos = "center",
                    position = {0, -2},
                    size = {
                        width = 0.3,
                        height = 0.3
                    },
                    zindex = 200
                }
            },
            -- Custom mode for TODO comments integration
            todo = {
                mode = "todo",
                filter = {
                    tag = {"TODO", "HACK", "WARN", "PERF", "NOTE", "TEST"}
                }
            }
        }
    },
    cmd = 'Trouble',
    keys = { -- Original keymaps
    {
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
        "<leader>dr",
        "<cmd>Trouble lsp_references toggle focus=true<cr>",
        desc = "LSP References (Trouble)"
    }, {
        "<leader>dd",
        "<cmd>Trouble lsp_definitions toggle focus=true<cr>",
        desc = "LSP Definitions (Trouble)"
    }, {
        "<leader>di",
        "<cmd>Trouble lsp_implementations toggle focus=true<cr>",
        desc = "LSP Implementations (Trouble)"
    }, {
        "<leader>dt",
        "<cmd>Trouble lsp_type_definitions toggle focus=true<cr>",
        desc = "LSP Types (Trouble)"
    }, {"<leader>dq", function()
        vim.diagnostic.setqflist({
            open = false
        })
        vim.cmd("Trouble qflist toggle focus=true")
    end, {
        desc = "Quickfix (Diagnostics → Trouble)"
    }}, {
        '<leader>dl',
        function()
            vim.diagnostic.setloclist({
                open = false
            }) -- window-local list
            vim.cmd('Trouble loclist toggle focus=true')
        end,
        desc = 'Location List (Diagnostics → Trouble)'
    }, {
        '<leader>dn',
        function()
            require('trouble').next({
                mode = 'diagnostics',
                jump = true
            })
        end,
        desc = 'Trouble Next'
    }, {
        '<leader>dp',
        function()
            require('trouble').prev({
                mode = 'diagnostics',
                jump = true
            })
        end,
        desc = 'Trouble Prev'
    }}
}, {
    'folke/todo-comments.nvim',
    dependencies = {'nvim-lua/plenary.nvim'},
    cmd = {'TodoTrouble', 'TodoTelescope', 'TodoLocList', 'TodoQuickFix'},
    event = {'BufReadPost', 'BufNewFile'},
    opts = {
        signs = true, -- show icons in the signs column
        sign_priority = 8, -- sign priority
        keywords = {
            FIX = {
                icon = " ", -- icon used for the sign, and in search results
                color = "error", -- can be a hex color, or a named color (see below)
                alt = {"FIXME", "BUG", "FIXIT", "ISSUE"} -- a set of other keywords that all map to this FIX keywords
            },
            TODO = {
                icon = " ",
                color = "info"
            },
            HACK = {
                icon = " ",
                color = "warning"
            },
            WARN = {
                icon = " ",
                color = "warning",
                alt = {"WARNING", "XXX"}
            },
            PERF = {
                icon = " ",
                alt = {"OPTIM", "PERFORMANCE", "OPTIMIZE"}
            },
            NOTE = {
                icon = " ",
                color = "hint",
                alt = {"INFO"}
            },
            TEST = {
                icon = "⏲ ",
                color = "test",
                alt = {"TESTING", "PASSED", "FAILED"}
            }
        },
        gui_style = {
            fg = "NONE", -- The gui style to use for the fg highlight group.
            bg = "BOLD" -- The gui style to use for the bg highlight group.
        },
        merge_keywords = true, -- when true, custom keywords will be merged with the defaults
        highlight = {
            multiline = true, -- enable multine todo comments
            multiline_pattern = "^.", -- lua pattern to match the next multiline from the start of the matched keyword
            multiline_context = 10, -- extra lines of context to show around a multiline comment
            before = "", -- "fg" or "bg" or empty
            keyword = "wide", -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
            after = "fg", -- "fg" or "bg" or empty
            pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlighting (vim regex)
            comments_only = true, -- uses treesitter to match keywords in comments only
            max_line_len = 400, -- ignore lines longer than this
            exclude = {} -- list of file types to exclude highlighting
        },
        colors = {
            error = {"DiagnosticError", "ErrorMsg", "#DC2626"},
            warning = {"DiagnosticWarn", "WarningMsg", "#FBBF24"},
            info = {"DiagnosticInfo", "#2563EB"},
            hint = {"DiagnosticHint", "#10B981"},
            default = {"Identifier", "#7C3AED"},
            test = {"Identifier", "#FF006E"}
        },
        search = {
            command = "rg",
            args = {"--color=never", "--no-heading", "--with-filename", "--line-number", "--column"},
            pattern = [[\b(KEYWORDS):]] -- ripgrep regex
        }
    },
    keys = {{
        ']t',
        function()
            require('todo-comments').jump_next()
        end,
        desc = 'Next todo comment'
    }, {
        '[t',
        function()
            require('todo-comments').jump_prev()
        end,
        desc = 'Previous todo comment'
    }, {
        '<leader>tt',
        '<cmd>Trouble todo<cr>',
        desc = 'TODO (Trouble)'
    }, {
        '<leader>tT',
        '<cmd>Trouble todo toggle win.position=right<cr>',
        desc = 'TODO (Trouble Right)'
    }}
}}
