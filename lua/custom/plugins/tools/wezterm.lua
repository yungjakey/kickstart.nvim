return {
    'zsh-sage/wezterm-send.nvim',
    cond = function()
        return vim.fn.executable('wezterm') == 1
    end,
    dependencies = {
        'willothy/wezterm.nvim',
        config = true
    },
    config = function()
        -- Keymap: Send current line to Wezterm
        vim.keymap.set('n', '<M-CR>', function()
            vim.cmd('WeztermSendJson ' .. vim.fn.shellescape(vim.fn.getline '.'))
        end, {
            desc = 'Send current line to Wezterm'
        })

        -- Keymap: Send selection to Wezterm as JSON
        vim.keymap.set('x', '<M-CR>', function()
            local selected_lines = vim.fn.getregion(vim.fn.getpos 'v', vim.fn.getpos '.')
            for _, line in ipairs(selected_lines) do
                vim.cmd('WeztermExecJson ' .. line .. '\n')
            end
        end, {
            desc = 'Send selection to Wezterm as JSON'
        })

        -- autocommands to set tab title
        vim.api.nvim_create_autocmd({'BufEnter'}, {
            callback = function(event)
                local title = 'vim'
                if event.file ~= '' then
                    title = string.format('vim: %s', vim.fs.basename(event.file))
                end

                vim.fn.system {'wezterm', 'cli', 'set-tab-title', title}
            end
        })

        vim.api.nvim_create_autocmd({'VimLeave'}, {
            callback = function()
                vim.fn.system {'wezterm', 'cli', 'set-tab-title', ''}
            end
        })
    end
}
