return {
  {
    -- GitHub Copilot (inline only; blink handles menu)
    'zbirenbaum/copilot.lua',
    event = 'InsertEnter',
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
    },
  },

  {
    -- Copilot as a blink.cmp source
    'giuxtaposition/blink-cmp-copilot',
    lazy = true,
    dependencies = { 'zbirenbaum/copilot.lua' },
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
        opts = {},
      },
      'folke/lazydev.nvim',
      'justingsgithub/wezterm-types',
      'rafamadriz/friendly-snippets',
    },

    ---@type blink.cmp.Config
    opts = function()
      ------------------------------------------------------------------------
      -- helpers
      ------------------------------------------------------------------------
      local copilot_kind_idx -- cached after first compute

      local function ensure_copilot_kind()
        if copilot_kind_idx then
          return copilot_kind_idx
        end
        local ok, types = pcall(require, 'blink.cmp.types')
        if not ok or type(types) ~= 'table' or type(types.CompletionItemKind) ~= 'table' then
          return nil
        end
        local K = types.CompletionItemKind
        local idx = #K + 1
        K[idx] = 'Copilot'
        K['Copilot'] = idx -- optional reverse lookup
        copilot_kind_idx = idx
        return idx
      end

      -- git root for .gitignore path completion; fall back to buffer dir
      local function git_root_or_bufdir(bufnr)
        local filedir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ':p:h')
        local cmd = { 'git', '-C', filedir, 'rev-parse', '--show-toplevel' }
        local out = vim.system and vim.system(cmd, { text = true }):wait() or { code = 1, stdout = '' }
        if out and out.code == 0 and out.stdout and out.stdout ~= '' then
          return vim.trim(out.stdout)
        end
        return filedir ~= '' and filedir or vim.fn.getcwd()
      end

      ------------------------------------------------------------------------
      -- options
      ------------------------------------------------------------------------
      return {
        keymap = { preset = 'super-tab' },

        -- Cmdline: make :e, :w, etc. complete files/dirs
        cmdline = {
          keymap = { preset = 'inherit' },
          completion = { menu = { auto_show = true } },
          sources = function()
            local t = vim.fn.getcmdtype()
            if t == ':' then
              return { 'cmdline', 'path' }
            elseif t == '/' or t == '?' then
              return { 'buffer' }
            end
            return {}
          end,
        },

        signature = { enabled = true },

        appearance = {
          nerd_font_variant = 'mono',
          kind_icons = {
            -- make sure the Copilot kind name is present
            Copilot = '',
            copilot = '', -- harmless duplicate alias
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
          trigger = { show_on_backspace = true },
          ghost_text = { enabled = true },
          documentation = { auto_show = true, auto_show_delay_ms = 500 },
          menu = {
            max_height = 15,
            direction_priority = { 'n', 's' },
            scrollbar = false,
          },
        },

        sources = {
          default = { 'lsp', 'path', 'lazydev', 'snippets', 'buffer', 'copilot' },
          per_filetype = {
            j2sql = { 'vim-dadbod-completion', 'lsp', 'snippets', 'buffer', 'copilot' },
            sql = { 'vim-dadbod-completion', 'lsp', 'snippets', 'buffer', 'copilot' },
            gitignore = { 'path', 'buffer', 'copilot' },
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
              score_offset = 100,
            },

            -- Path provider (shows .config, etc.)
            path = {
              min_keyword_length = 0,
              score_offset = 80,
              opts = {
                show_hidden_files_by_default = true, -- show dotfiles
                get_cwd = function(ctx)
                  if vim.bo[ctx.bufnr].filetype == 'gitignore' then
                    return git_root_or_bufdir(ctx.bufnr)
                  end
                  return vim.fn.getcwd()
                end,
              },
            },

            -- Copilot provider
            copilot = {
              name = 'copilot',
              module = 'blink-cmp-copilot',
              score_offset = 90,
              async = true,
              transform_items = function(_, items)
                local idx = ensure_copilot_kind()
                if not idx then
                  return items
                end
                for _, item in ipairs(items) do
                  item.kind = idx
                end
                return items
              end,
            },
          },
        },

        snippets = { preset = 'luasnip' },
        fuzzy = { implementation = 'lua' },
      }
    end,

    config = function(_, opts)
      require('blink.cmp').setup(opts)

      -- .gitignore QoL: treat special chars as separators so path trigger works
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'gitignore',
        callback = function()
          vim.opt_local.isfname:remove '!'
          vim.opt_local.isfname:remove '*'
          vim.opt_local.isfname:remove '?'
        end,
      })
    end,
  },
}
