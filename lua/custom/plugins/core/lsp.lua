return {
  -- schema store & types
  'b0o/schemastore.nvim',
  'https://github.com/DrKJeff16/wezterm-types',

  -- Lua type hints / libraries
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    dependencies = {
      {
        'https://github.com/DrKJeff16/wezterm-types', -- correct owner/name
        lazy = true,
      },
    },
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        { path = 'wezterm-types', mods = { 'wezterm' } },
        { path = '~/.config/hammerspoon/Spoons/EmmyLua.spoon/annotations', words = { 'hs' } },
        'LazyVim',
      },
    },
  },

  -- LSP setup
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      'saghen/blink.cmp',
    },
    config = function()
      -- Keymaps per buffer on attach
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('<leader>ln', vim.lsp.buf.rename, '[N]ew name')
          map('<leader>la', vim.lsp.buf.code_action, '[A]ction', { 'n', 'x' })
          map('<leader>lr', require('telescope.builtin').lsp_references, '[R]eferences')
          map('<leader>li', require('telescope.builtin').lsp_implementations, '[I]mplementation')
          map('<leader>ld', require('telescope.builtin').lsp_definitions, '[D]efinition')
          map('<leader>lD', vim.lsp.buf.declaration, '[D]eclaration')
          map('<leader>ls', require('telescope.builtin').lsp_document_symbols, '[S]ymbols')
          map('<leader>lw', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace Symbols')
          map('<leader>lt', require('telescope.builtin').lsp_type_definitions, '[T]ype Definition')

          -- 0.11 API compat shim
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          local client = vim.lsp.get_client_by_id(event.data.client_id)

          -- highlight references
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local g = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf, group = g, callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf, group = g, callback = vim.lsp.buf.clear_references,
            })
            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(ev2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = ev2.buf }
              end,
            })
          end

          -- toggle inlay hints
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>lh', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[H]ints')
          end
        end,
      })

      -- Diagnostics
      vim.diagnostic.config {
        update_in_insert = false,
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN]  = '󰀪 ',
            [vim.diagnostic.severity.INFO]  = '󰋽 ',
            [vim.diagnostic.severity.HINT]  = '󰌶 ',
          },
        } or {},
        virtual_text = false,
      }

      -- Capabilities (blink.cmp)
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- Servers
      local servers = {
        gopls = {
          filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
          settings = {
            gopls = {
              analyses = { unusedparams = true, shadow = true },
              staticcheck = true, gofumpt = true, usePlaceholders = true,
            },
          },
        },

        pyright = {
          filetypes = { 'python', 'py' },
          root_dir = require('lspconfig.util').root_pattern('pyproject.toml', 'setup.cfg', 'setup.py', 'requirements.txt', '.git'),
          settings = {
            python = {
              analysis = {
                typeCheckingMode = 'basic',
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                autoImportCompletions = true,
              },
            },
          },
        },

        sqls = { filetypes = { 'sql', 'j2sql' } },

        jinja_lsp = {
          filetypes = { 'j2', 'jinja2', 'j2sql' },
          settings = { jinja = { autoFormat = true, autoComplete = true, autoCompleteOnTagClose = true } },
        },

        bashls = {
          filetypes = { 'sh', 'bash', 'env' },
          settings = { bashIde = { globPattern = vim.env.GLOB_PATTERN or '*@(.sh|.inc|.bash|.command|.env)' } },
        },

        lua_ls = {
          filetypes = { 'lua' }, -- must be a list
          settings = {
            Lua = {
              runtime = { version = 'LuaJIT' },
              workspace = { checkThirdParty = false },
              completion = { callSnippet = 'Replace' },
            },
          },
        },

        jsonls = {
          filetypes = { 'json', 'jsonc', 'json5' },
          settings = {
            schemaStore = { enable = false, url = '' },
            json = {
              schemas = require('schemastore').json.schemas(),
              validate = { enable = true },
              format = { enable = false },
            },
          },
        },

        yamlls = {
          settings = {
            yaml = {
              schemaStore = { enable = false, url = '' },
              schemas = {
                ['https://raw.githubusercontent.com/docker/compose/master/compose/config/compose_spec.json'] = 'docker-compose*.{yml,yaml}',
                ['https://json.schemastore.org/kustomization.json'] = 'kustomization.{yml,yaml}',
                ['https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json'] = 'argocd-application.yaml',
                ['https://www.schemastore.org/databricks-asset-bundles.json'] = '{databricks,db}.*.{yml,yaml}',
              },
              validate = true, completion = true, hover = true, format = { enable = false },
            },
          },
        },

        taplo = {
          cmd = { vim.fn.exepath 'taplo', 'lsp', 'stdio' },
          filetypes = { 'toml' },
          root_dir = require('lspconfig.util').root_pattern('*.toml', '.git'),
          single_file_support = true,
        },

        marksman = { filetypes = { 'markdown', 'md' } },

        ['tofu-ls'] = {
          filetypes = { 'tf', 'hcl', 'tfvars' },
          settings = { tofu = { format = { enable = true }, validate = { enable = true } } },
        },

        dockerls = {},
      }

      -- Install tools & servers
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        -- formatters/linters
        'ruff', 'goimports', 'shfmt', 'stylua', 'prettierd', 'fixjson', 'yamlfix', 'sqlfmt', 'djlint',
        'golangci-lint', 'shellcheck', 'luacheck', 'jsonlint', 'yamllint', 'markdownlint', 'tflint',
        'hadolint', 'actionlint', 'sqlfluff',
        -- LSP servers
        'gopls', 'bash-language-server', 'lua-language-server', 'json-lsp', 'yaml-language-server',
        'marksman', 'tofu-ls', 'dockerfile-language-server', 'gh-actions-language-server', 'sqls', 'jinja-lsp',
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      -- IMPORTANT WORKAROUND: force full sync to avoid 0.11.x diff bug
      -- See: https://github.com/neovim/neovim/issues/33224
      local lspconfig = require('lspconfig')
      require('mason-lspconfig').setup {
        ensure_installed = {},
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            server.flags = vim.tbl_deep_extend('force', { allow_incremental_sync = false }, server.flags or {})
            lspconfig[server_name].setup(server)
          end,
        },
      }
    end,
  },
}
