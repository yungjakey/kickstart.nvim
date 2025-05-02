-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
-- Custom keymaps using real Option key (M stands for Meta/Alt/Option in Vim keybindings)
return {
    {
        "nvim-lua/plenary.nvim",
        config = function()
            -- ESC to enter insert mode
            vim.keymap.set('n', '<Esc>', 'i', { desc = 'Enter insert mode' })

            -- Option+q to quit
            vim.keymap.set('n', '<M-q>', ':q<CR>', { desc = 'Quit', silent = true })

            -- Option+Shift+q to force quit
            vim.keymap.set('n', '<M-Q>', ':q!<CR>', { desc = 'Force quit', silent = true })

            -- Option+w to save
            vim.keymap.set('n', '<M-w>', ':w<CR>', { desc = 'Save', silent = true })

            -- Option+Shift+w to force save
            vim.keymap.set('n', '<M-W>', ':w!<CR>', { desc = 'Force save', silent = true })

            -- Option+e to save and quit
            vim.keymap.set('n', '<M-e>', ':wq<CR>', { desc = 'Save and quit', silent = true })

            -- Option+Shift+e to force save and quit
            vim.keymap.set('n', '<M-E>', ':wq!<CR>', { desc = 'Force save and quit', silent = true })

            -- Option+r to reload buffer
            vim.keymap.set('n', '<M-r>', ':e<CR>', { desc = 'Reload current buffer', silent = true })

            -- Option+Shift+r to reload config
            vim.keymap.set('n', '<M-R>', function()
                dofile(vim.env.MYVIMRC)
                vim.notify('Config reloaded', vim.log.levels.INFO)
            end, { desc = 'Reload config', silent = true })
        end
    }
}
