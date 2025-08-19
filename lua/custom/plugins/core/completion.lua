return {
  {
    'zbirenbaum/copilot.lua',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup {
        suggestion = {
          enabled = false,
        },
        panel = {
          enabled = false,
        },
      }
    end,
  },
  {
    'giuxtaposition/blink-cmp-copilot',
    dependencies = 'copilot.lua',
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
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {},
        opts = {},
      },
      'folke/lazydev.nvim',
      'rafamadriz/friendly-snippets',
    },
    opts = {
      keymap = {
        preset = 'super-tab',
      },
      cmdline = {
        keymap = { preset = 'inherit' },
        completion = { menu = { auto_show = true } },
      },
      signature = { enabled = true },

      appearance = {
        nerd_font_variant = 'mono',
        kind_icons = {
          copilot = '',
          Text = '󰉿',
          Method = '󰊕',
          Function = '󰊕',
          Constructor = '󰒓',
          Field = '󰜢',
          Variable = '󰆦',
          Property = '󰖷',
          Class = '󱡠',
          Interface = '󱡠',
          Struct = '󱡠',
          Module = '󰅩',
          Unit = '󰪚',
          Value = '󰦨',
          Enum = '󰦨',
          EnumMember = '󰦨',
          Keyword = '󰻾',
          Constant = '󰏿',
          Snippet = '󱄽',
          Color = '󰏘',
          File = '󰈔',
          Reference = '󰬲',
          Folder = '󰉋',
          Event = '󱐋',
          Operator = '󰪚',
          TypeParameter = '󰬛',
          dadbod = '󰆼',
        },
      },
      completion = {
        trigger = {
          show_on_backspace = true,
        },
        ghost_text = {
          enabled = true,
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500,
        },
        menu = {
          max_height = 15,
          direction_priority = { 'n', 's' },
          scrollbar = false,
        },
      },
      sources = {
        default = { 'lsp', 'path', 'lazydev', 'snippets', 'buffer', 'copilot' },
        per_filetype = {
          j2sql = { 'vim-dadbod-completion', 'lsp', 'buffer', 'copilot' },
          sql = { 'vim-dadbod-completion', 'lsp', 'buffer', 'copilot' },
        },
        providers = {
          ['lazydev'] = {
            name = 'lazydev',
            module = 'lazydev.integrations.blink',
            score_offset = 100,
          },
          ['vim-dadbod-completion'] = {
            name = 'Dadbod',
            module = 'vim_dadbod_completion.blink',
            score_offset = 110,
          },
          ['copilot'] = {
            name = 'copilot',
            module = 'blink-cmp-copilot',
            score_offset = 90,
            async = true,
            transform_items = function(_, items)
              local CompletionItemKind = require('blink.cmp.types').CompletionItemKind
              local kind_idx = #CompletionItemKind + 1
              CompletionItemKind[kind_idx] = 'Copilot'
              for _, item in ipairs(items) do
                item.kind = kind_idx
              end
              return items
            end,
          },
        },
      },
      snippets = {
        preset = 'luasnip',
      },
      fuzzy = {
        implementation = 'lua',
      },
      signature = {
        enabled = true,
      },
    },
    config = function(_, opts)
      require('blink.cmp').setup(opts)
    end,
  },
}
