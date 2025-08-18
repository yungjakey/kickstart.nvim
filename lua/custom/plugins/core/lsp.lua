return {
  'b0o/schemastore.nvim',
  'justingsgithub/wezterm-types',
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    dependencies = {
      {
        'justinsgithub/wezterm-types',
        lazy = true,
      },
    },
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },

        -- Load the wezterm types when the `wezterm` module is required
        { path = 'wezterm-types', mods = { 'wezterm' } },

        -- Load Hammerspoon EmmyLua annotations when `hs` is found
        { path = '~/.config/hammerspoon/Spoons/EmmyLua.spoon/annotations', words = { 'hs' } },

        'LazyVim',
      },
    },
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      {
        'mason-org/mason.nvim',
        opts = {},
      },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      {
        'j-hui/fidget.nvim',
        opts = {},
      },
      'saghen/blink.cmp',
    },
    config = function()
      --  This function gets run when an LSP attaches to a particular buffer.
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', {
          clear = true,
        }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, {
              buffer = event.buf,
              desc = 'LSP: ' .. desc,
            })
          end

          -- Rename the variable under your cursor.
          map('<leader>ln', vim.lsp.buf.rename, '[N]ew name')

          -- Execute a code action, usually your cursor needs to be on top of an error
          map('<leader>la', vim.lsp.buf.code_action, '[A]ction', { 'n', 'x' })

          -- Find references for the word under your cursor.
          map('<leader>lr', require('telescope.builtin').lsp_references, '[R]eferences')

          -- Jump to the implementation of the word under your cursor.
          map('<leader>li', require('telescope.builtin').lsp_implementations, '[I]mplementation')

          -- Jump to the definition of the word under your cursor.
          map('<leader>ld', require('telescope.builtin').lsp_definitions, '[D]efinition')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          map('<leader>lD', vim.lsp.buf.declaration, '[D]eclaration')

          -- Fuzzy find all the symbols in your current document.
          map('<leader>ls', require('telescope.builtin').lsp_document_symbols, '[S]ymbols')

          -- Fuzzy find all the symbols in your current workspace.
          map('<leader>lw', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace Symbols')

          -- Jump to the type of the word under your cursor.
          map('<leader>lt', require('telescope.builtin').lsp_type_definitions, '[T]ype Definition')

          -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
          ---@param client vim.lsp.Client
          ---@param method vim.lsp.protocol.Method
          ---@param bufnr? integer some lsp support methods only in specific files
          ---@return boolean
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, {
                bufnr = bufnr,
              })
            end
          end

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', {
              clear = false,
            })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', {
                clear = true,
              }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds {
                  group = 'kickstart-lsp-highlight',
                  buffer = event2.buf,
                }
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>lh', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled {
                bufnr = event.buf,
              })
            end, '[H]ints')
          end
        end,
      })

      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config {
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = 'rounded',
          source = 'if_many',
        },
        underline = {
          severity = vim.diagnostic.severity.ERROR,
        },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = false,
      }

      -- LSP servers and clients are able to communicate to each other what features they support.
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- Enable the following language servers
      local servers = {
        gopls = {
          settings = {
            gopls = {
              analyses = {
                unusedparams = true,
                shadow = true,
              },
              staticcheck = true,
              gofumpt = true,
              usePlaceholders = true,
            },
          },
        },

        -- Python
        pyright = {
          filetypes = { 'python' },
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

        -- SQL
        sqls = {
          filetypes = { 'sql', 'j2sql' },
        },

        -- Jinja
        jinja_lsp = {
          filetypes = { 'j2', 'jinja2', 'j2sql' },
          settings = {
            jinja = {
              autoFormat = true,
              autoComplete = true,
              autoCompleteOnTagClose = true,
            },
          },
        },

        -- Shell/Bash
        bashls = {
          filetypes = { 'sh', 'bash', 'zsh', 'env' },
          settings = {
            bashIde = {
              globPattern = vim.env.GLOB_PATTERN or '*@(.sh|.inc|.bash|.zsh|.command|.env)',
            },
          },
          root_dir = function(fname)
            return vim.fs.dirname(vim.fs.find('.git', {
              path = fname,
              upward = true,
            })[1])
          end,
          single_file_support = true,
        },

        -- Lua Language Server - minimal config, let lazydev handle the rest
        lua_ls = {
          settings = {
            Lua = {
              runtime = {
                version = 'LuaJIT',
              },
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },

        -- JSON
        jsonls = {
          settings = {
            schemaStore = {
              enable = false,
              url = '',
            },
            json = {
              schemas = require('schemastore').json.schemas(),
              validate = {
                enable = true,
              },
              format = {
                enable = false,
              },
            },
          },
        },

        -- YAML
        yamlls = {
          settings = {
            yaml = {
              schemaStore = {
                enable = false,
                url = '',
              },
              schemas = {
                ['https://raw.githubusercontent.com/docker/compose/master/compose/config/compose_spec.json'] = 'docker-compose*.{yml,yaml}',
                ['https://json.schemastore.org/kustomization.json'] = 'kustomization.{yml,yaml}',
                ['https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json'] = 'argocd-application.yaml',
                ['https://www.schemastore.org/databricks-asset-bundles.json'] = '{databricks, db}.*.{yml,yaml}',
              },
              validate = true,
              completion = true,
              hover = true,
              format = {
                enable = false,
              },
            },
          },
        },

        -- TOML
        taplo = {
          cmd = { vim.fn.exepath 'taplo', 'lsp', 'stdio' },
          filetypes = { 'toml' },
          settings = {},
          root_dir = require('lspconfig.util').root_pattern('*.toml', '.git'),
          single_file_support = true,
        },

        -- Markdown
        marksman = {
          filetypes = { 'markdown', 'md' },
        },

        -- OpenTofu/Terraform
        ['tofu-ls'] = {
          filetypes = { 'tf', 'hcl', 'tfvars' },
          settings = {
            tofu = {
              format = {
                enable = true,
              },
              validate = {
                enable = true,
              },
            },
          },
        },

        -- Docker
        dockerls = {},
      }

      -- Ensure the servers and tools above are installed
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        -- Formatters & Fixers
        'ruff',
        'goimports',
        'shfmt',
        'stylua',
        'prettierd',
        'fixjson',
        'yamlfix',
        'sqlfmt',
        'djlint',
        -- Linters
        'golangci-lint',
        'shellcheck',
        'luacheck',
        'jsonlint',
        'yamllint',
        'markdownlint',
        'tflint',
        'hadolint',
        'actionlint',
        'sqlfluff',
        -- LSP servers
        'gopls',
        'bash-language-server',
        'lua-language-server',
        'json-lsp',
        'yaml-language-server',
        'marksman',
        'tofu-ls',
        'dockerfile-language-server',
        'gh-actions-language-server',
        'sqls',
        'jinja-lsp',
      })

      require('mason-tool-installer').setup {
        ensure_installed = ensure_installed,
      }

      require('mason-lspconfig').setup {
        ensure_installed = {},
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },
}
