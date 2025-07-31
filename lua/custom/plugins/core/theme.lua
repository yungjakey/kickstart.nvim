-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
-- Custom keymaps using real Option key (M stands for Meta/Alt/Option in Vim keybindings)
return {
  -- Dracula theme with transparent background
  {
    'Mofiqul/dracula.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins
    config = function()
      -- Configure the Dracula theme with transparent background
      require('dracula').setup {
        transparent_bg = true,
        -- Enable the theme
        colors = {
          bg = 'NONE',
        },
        -- Override specific highlight groups
        overrides = {
          -- Add any specific highlight overrides here
          Normal = { bg = 'NONE' },
          NormalFloat = { bg = 'NONE' },
        },
      }

      -- Set the colorscheme
      vim.cmd [[colorscheme dracula]]
    end,
  },

  -- Mode indicator with custom text
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      -- Configure mode indicator with custom icons and text
      local custom_mode = {
        normal = '𝔫 ᕕ( ᐛ )ᕗ ',
        insert = '𝔦 ᕙ(´ཀ`)ᕗ ',
        visual = '𝔳 (⌐■_■)⌐ ',
        select = '𝔰 ヽ(⇀.↼)ノ',
        command = '𝔠 (╯°□°)╯ ',
        replace = '𝔯 (>^.^<)',
        terminal = '𝔱 (ﾉ≧∇≦)ﾉ ',
        inactive = '𝔵 (╯︵╰,)',
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
              end,
            },
          },
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = { 'filename' },
          lualine_x = { 'encoding', 'fileformat', 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { 'filename' },
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        extensions = {},
      }
    end,
  },
}
