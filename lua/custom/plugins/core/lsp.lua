return {{'b0o/schemastore.nvim'}, {
    'folke/lazydev.nvim',
    ft = 'lua',
    dependencies = {{
        'justinsgithub/wezterm-types',
        lazy = true
    }},
    opts = {
        library = {{
            path = '${3rd}/luv/library',
            words = {'vim%.uv'}
        }, {
            path = 'wezterm-types',
            modes = {'wezterm'}
        }, 'LazyVim'}
    }
}, {
    'neovim/nvim-lspconfig',
    dependencies = {{
        'mason-org/mason.nvim',
        opts = {}
    }, 'mason-org/mason-lspconfig.nvim', 'WhoIsSethDaniel/mason-tool-installer.nvim', {
        'j-hui/fidget.nvim',
        opts = {}
    }, 'saghen/blink.cmp'},
    config = function()
        --  This function gets run when an LSP attaches to a particular buffer.
        --    That is to say, every time a new file is opened that is associated with
        --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
        --    function will be executed to configure the current buffer
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-attach', {
                clear = true
            }),
            callback = function(event)
                -- NOTE: Remember that Lua is a real programming language, and as such it is possible
                -- to define small helper and utility functions so you don't have to repeat yourself.
                --
                -- In this case, we create a function that lets us more easily define mappings specific
                -- for LSP related items. It sets the mode, buffer and description for us each time.
                local map = function(keys, func, desc, mode)
                    mode = mode or 'n'
                    vim.keymap.set(mode, keys, func, {
                        buffer = event.buf,
                        desc = 'LSP: ' .. desc
                    })
                end

                -- Rename the variable under your cursor.
                --  Most Language Servers support renaming across files, etc.
                map('<leader>ln', vim.lsp.buf.rename, '[N]ew name')

                -- Execute a code action, usually your cursor needs to be on top of an error
                -- or a suggestion from your LSP for this to activate.
                map('<leader>la', vim.lsp.buf.code_action, '[A]ction', {'n', 'x'})

                -- Find references for the word under your cursor.
                map('<leader>lr', require('telescope.builtin').lsp_references, '[R]eferences')

                -- Jump to the implementation of the word under your cursor.
                --  Useful when your language has ways of declaring types without an actual implementation.
                map('<leader>li', require('telescope.builtin').lsp_implementations, '[I]mplementation')

                -- Jump to the definition of the word under your cursor.
                --  This is where a variable was first declared, or where a function is defined, etc.
                --  To jump back, press <C-t>.
                map('<leader>ld', require('telescope.builtin').lsp_definitions, '[D]efinition')

                -- WARN: This is not Goto Definition, this is Goto Declaration.
                --  For example, in C this would take you to the header.
                map('<leader>lD', vim.lsp.buf.declaration, '[D]eclaration')

                -- Fuzzy find all the symbols in your current document.
                --  Symbols are things like variables, functions, types, etc.
                map('<leader>ls', require('telescope.builtin').lsp_document_symbols, '[S]ymbols')

                -- Fuzzy find all the symbols in your current workspace.
                --  Similar to document symbols, except searches over your entire project.
                map('<leader>lw', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace Symbols')

                -- Jump to the type of the word under your cursor.
                --  Useful when you're not sure what type a variable is and you want to see
                --  the definition of its *type*, not where it was *defined*.
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
                            bufnr = bufnr
                        })
                    end
                end

                -- The following two autocommands are used to highlight references of the
                -- word under your cursor when your cursor rests there for a little while.
                --    See `:help CursorHold` for information about when this is executed
                --
                -- When you move your cursor, the highlights will be cleared (the second autocommand).
                local client = vim.lsp.get_client_by_id(event.data.client_id)
                if client and
                    client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
                    local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', {
                        clear = false
                    })
                    vim.api.nvim_create_autocmd({'CursorHold', 'CursorHoldI'}, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.document_highlight
                    })

                    vim.api.nvim_create_autocmd({'CursorMoved', 'CursorMovedI'}, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.clear_references
                    })

                    vim.api.nvim_create_autocmd('LspDetach', {
                        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', {
                            clear = true
                        }),
                        callback = function(event2)
                            vim.lsp.buf.clear_references()
                            vim.api.nvim_clear_autocmds {
                                group = 'kickstart-lsp-highlight',
                                buffer = event2.buf
                            }
                        end
                    })
                end

                -- The following code creates a keymap to toggle inlay hints in your
                -- code, if the language server you are using supports them
                -- This may be unwanted, since they displace some of your code
                if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
                    map('<leader>lh', function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled {
                            bufnr = event.buf
                        })
                    end, '[H]ints')
                end
            end
        })

        -- Diagnostic Config
        -- See :help vim.diagnostic.Opts
        vim.diagnostic.config {
            update_in_insert = false,
            severity_sort = true,
            float = {
                border = 'rounded',
                source = 'if_many'
            },
            underline = {
                severity = vim.diagnostic.severity.ERROR
            },
            signs = vim.g.have_nerd_font and {
                text = {
                    [vim.diagnostic.severity.ERROR] = '󰅚 ',
                    [vim.diagnostic.severity.WARN] = '󰀪 ',
                    [vim.diagnostic.severity.INFO] = '󰋽 ',
                    [vim.diagnostic.severity.HINT] = '󰌶 '
                }
            } or {},
            virtual_text = false
            -- virtual_text = {
            --   source = 'if_many',
            --   spacing = 2,
            --   format = function(diagnostic)
            --     local diagnostic_message = {
            --       [vim.diagnostic.severity.ERROR] = diagnostic.message,
            --       [vim.diagnostic.severity.WARN] = diagnostic.message,
            --       [vim.diagnostic.severity.INFO] = diagnostic.message,
            --       [vim.diagnostic.severity.HINT] = diagnostic.message,
            --     }
            --     return diagnostic_message[diagnostic.severity]
            --   end,
            -- },
        }

        -- LSP servers and clients are able to communicate to each other what features they support.
        --  By default, Neovim doesn't support everything that is in the LSP specification.
        --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
        --  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
        local capabilities = require('blink.cmp').get_lsp_capabilities()

        -- Enable the following language servers
        --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
        --
        --  Add any additional override configuration in the following tables. Available keys are:
        --  - cmd (table): Override the default command used to start the server
        --  - filetypes (table): Override the default list of associated filetypes for the server
        --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
        --  - settings (table): Override the default settings passed when initializing the server.
        --        For example, to see the options for `lua-language-server`, you could go to: https://luals.github.io/wiki/settings/
        local servers = {
            -- clangd = {},
            gopls = {
                settings = {
                    gopls = {
                        analyses = {
                            unusedparams = true,
                            shadow = true
                        },
                        staticcheck = true,
                        gofumpt = true,
                        usePlaceholders = true
                    }
                }
            },

            -- Python
            pyright = {
                filetypes = {'python'}, -- Fix: should be 'python', not 'py'
                root_dir = require('lspconfig.util').root_pattern('pyproject.toml', 'setup.cfg', 'setup.py',
                    'requirements.txt', '.git'),
                settings = {
                    python = {
                        analysis = {
                            typeCheckingMode = 'basic',
                            autoSearchPaths = true,
                            useLibraryCodeForTypes = true,
                            autoImportCompletions = true
                        }
                    }
                }
            },
            -- sql
            sqls = {
                filetypes = {'sql', 'j2sql'}
            },

            -- jinja
            jinja_lsp = {
                filetypes = {'j2', 'jinja2', 'j2sql'},
                settings = {
                    jinja = {
                        autoFormat = true,
                        autoComplete = true,
                        autoCompleteOnTagClose = true
                    }
                }
            },

            -- Shell/Bash
            ['bashls'] = {
                filetypes = {'sh', 'bash', 'zsh', 'env'},
                settings = {
                    bashIde = {
                        globPattern = vim.env.GLOB_PATTERN or '*@(.sh|.inc|.bash|.zsh|.command|.env)'
                    },
                    -- filetypes = { 'bash', 'sh', 'zsh', '.env' },
                    root_dir = function(fname)
                        return vim.fs.dirname(vim.fs.find('.git', {
                            path = fname,
                            upward = true
                        })[1])
                    end,
                    single_file_support = true
                }
            },

            ['lua_ls'] = {
                settings = {
                    Lua = {
                        runtime = {
                            version = 'LuaJIT'
                        },
                        -- diagnostics = { globals = { "vim" } },
                        workspace = {
                            -- checkThirdParty = false,
                            library = {vim.env.VIMRUNTIME}
                        },
                        completion = {
                            callSnippet = 'Replace',
                            trigger = {
                                show_on_backspace = true
                            }
                        }
                    }
                }
            },

            -- JSON
            ['jsonls'] = {
                settings = {
                    schemaStore = {
                        -- You must disable built-in schemaStore support if you want to use
                        -- this plugin and its advanced options like `ignore`.
                        enable = false,
                        -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                        url = ''
                    },
                    json = {
                        schemas = require('schemastore').json.schemas(),
                        validate = {
                            enable = true
                        },
                        format = {
                            enable = false
                        } -- Let prettierd handle formatting
                    }
                }
            },

            -- YAML
            ['yamlls'] = {
                settings = {
                    yaml = {
                        schemaStore = {
                            -- You must disable built-in schemaStore support if you want to use
                            -- this plugin and its advanced options like `ignore`.
                            enable = false,
                            -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                            url = ''
                        },
                        -- schemas = require('schemastore').yaml.schemas(),
                        schemas = {
                            ['https://raw.githubusercontent.com/docker/compose/master/compose/config/compose_spec.json'] = 'docker-compose*.{yml,yaml}',
                            ['https://json.schemastore.org/kustomization.json'] = 'kustomization.{yml,yaml}',
                            ['https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json'] = 'argocd-application.yaml',
                            ['https://www.schemastore.org/databricks-asset-bundles.json'] = '{databricks, db}.*.{yml,yaml}'
                        },
                        validate = true,
                        completion = true,
                        hover = true,
                        format = {
                            enable = false
                        } -- Let prettierd handle formatting
                    }
                }
            },

            -- toml

            taplo = {
                cmd = {vim.fn.exepath 'taplo', 'lsp', 'stdio'}, -- ← resolves to 0.10 on PATH
                filetypes = {'toml'},
                settings = {},
                root_dir = require('lspconfig.util').root_pattern('*.toml', '.git'),
                single_file_support = true
            },

            -- Markdown
            marksman = {
                filetypes = {'md'}
            },

            -- tofu
            ['tofu-ls'] = {
                filetypes = {'tf', 'hcl', 'tfvars'},
                settings = {
                    tofu = {
                        format = {
                            enable = true
                        },
                        validate = {
                            enable = true
                        }
                    }
                }
            },

            -- Docker
            ['dockerls'] = {}
        }

        -- Ensure the servers and tools above are installed
        --
        -- To check the current status of installed tools and/or manually install
        -- other tools, you can run
        --    :Mason
        --
        -- You can press `g?` for help in this menu.
        --
        -- `mason` had to be setup earlier: to configure its options see the
        -- `dependencies` table for `nvim-lspconfig` above.
        --
        -- You can add other tools here that you want Mason to install
        -- for you, so that they are available from within Neovim.
        local ensure_installed = vim.tbl_keys(servers or {})
        vim.list_extend(ensure_installed, { -- Formatters & Fixers
        'ruff', 'goimports', 'shfmt', 'stylua', 'prettierd', 'fixjson', 'yamlfix', 'sqlfmt', 'djlint', -- Linters
        'golangci-lint', 'shellcheck', 'luacheck', 'jsonlint', 'yamllint', -- 'taplo',
        'markdownlint', 'tflint', 'hadolint', 'actionlint', 'sqlfluff', -- lsp
        'gopls', 'bash-language-server', 'lua-language-server', 'json-lsp', 'yaml-language-server', 'marksman',
        'tofu-ls', 'dockerfile-language-server', 'gh-actions-language-server', 'sqls', 'jinja-lsp'})
        require('mason-tool-installer').setup {
            ensure_installed = ensure_installed
        }

        require('mason-lspconfig').setup {
            ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
            automatic_installation = false,
            automatic_enable = {
                exclude = {'ruff', 'taplo'} -- Prevent ruff LSP from auto-enabling
            },
            handlers = {function(server_name)
                local server = servers[server_name] or {}
                -- This handles overriding only values explicitly passed
                -- by the server configuration above. Useful when disabling
                -- certain features of an LSP (for example, turning off formatting for ts_ls)
                server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
                require('lspconfig')[server_name].setup(server)
            end}
        }
    end
}}
