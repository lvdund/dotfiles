return {
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
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
      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }

      local capabilities = require('blink.cmp').get_lsp_capabilities()

      local servers = {
        dockerls = {},
        docker_compose_language_service = {},
        marksman = {},
        jsonls = {
          -- lazy-load schemastore when needed
          before_init = function(_, new_config)
            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
            vim.list_extend(new_config.settings.json.schemas, require('schemastore').json.schemas())
          end,
          settings = {
            json = {
              format = {
                enable = true,
              },
              validate = { enable = true },
            },
          },
        },
        yamlls = {
          -- Have to add this for yamlls to understand that we support line folding
          capabilities = {
            textDocument = {
              foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
              },
            },
          },
          -- lazy-load schemastore when needed
          before_init = function(_, new_config)
            new_config.settings.yaml.schemas = vim.tbl_deep_extend('force', new_config.settings.yaml.schemas or {}, require('schemastore').yaml.schemas())
          end,
          settings = {
            redhat = { telemetry = { enabled = false } },
            yaml = {
              keyOrdering = false,
              format = {
                enable = true,
              },
              validate = true,
              schemaStore = {
                -- Must disable built-in schemaStore support to use
                -- schemas from SchemaStore.nvim plugin
                enable = false,
                -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                url = '',
              },
            },
          },
        },
        clangd = {
          cmd = { '/usr/bin/clangd', '--background-index', '--clang-tidy', '--log=verbose' },
          init_options = {
            fallbackFlags = { '-std=c++20' },
          },
          filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto', 'h' },
          root_dir = require('lspconfig').util.root_pattern(
            '.clangd',
            '.clang-tidy',
            '.clang-format',
            'compile_commands.json',
            'compile_flags.txt',
            'configure.ac',
            '.git'
          ),
          single_file_support = true,
        },
        bacon_ls = {
          enabled = diagnostics == 'bacon-ls',
        },
        rust_analyzer = {
          enable = false,
        },
        ts_ls = {
          enabled = false,
        },
        vtsls = {
          -- explicitly add default filetypes, so that we can extend
          -- them in related extras
          filetypes = {
            'javascript',
            'javascriptreact',
            'javascript.jsx',
            'typescript',
            'typescriptreact',
            'typescript.tsx',
          },
          settings = {
            complete_function_calls = true,
            vtsls = {
              enableMoveToFileCodeAction = true,
              autoUseWorkspaceTsdk = true,
              experimental = {
                maxInlayHintLength = 30,
                completion = {
                  enableServerSideFuzzyMatch = true,
                },
              },
            },
            typescript = {
              updateImportsOnFileMove = { enabled = 'always' },
              suggest = {
                completeFunctionCalls = true,
              },
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = 'literals' },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
              },
            },
          },
        },
        eslint = {
          settings = {
            codeAction = {
              disableRuleComment = {
                enable = true,
                location = 'separateLine',
              },
              showDocumentation = {
                enable = true,
              },
            },
            codeActionOnSave = {
              enable = false,
              mode = 'all',
            },
            experimental = {
              useFlatConfig = false,
            },
            format = true,
            nodePath = '',
            onIgnoredFiles = 'off',
            packageManager = 'npm',
            problems = {
              shortenToSingleLine = false,
            },
            quiet = false,
            rulesCustomizations = {},
            run = 'onType',
            useESLintClass = false,
            validate = 'on',
            workingDirectory = {
              mode = 'location',
            },
          },
        },
        bashls = {},
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
        gopls = {
          -- settings = {
          --   gopls = {
          --     gofumpt = true,
          --     codelenses = {
          --       gc_details = false,
          --       generate = true,
          --       regenerate_cgo = true,
          --       run_govulncheck = true,
          --       test = true,
          --       tidy = true,
          --       upgrade_dependency = true,
          --       vendor = true,
          --     },
          --     hints = {
          --       assignVariableTypes = true,
          --       compositeLiteralFields = true,
          --       compositeLiteralTypes = true,
          --       constantValues = true,
          --       functionTypeParameters = true,
          --       parameterNames = true,
          --       rangeVariableTypes = true,
          --     },
          --     analyses = {
          --       nilness = true,
          --       unusedparams = true,
          --       unusedwrite = true,
          --       useany = true,
          --     },
          --     usePlaceholders = true,
          --     completeUnimported = true,
          --     staticcheck = true,
          --     directoryFilters = { '-.git', '-.vscode', '-.idea', '-.vscode-test', '-node_modules' },
          --     semanticTokens = true,
          --   },
          -- },
        },
      }

      -- local ensure_installed = vim.tbl_keys(servers or {})
      -- vim.list_extend(ensure_installed, {
      --   'stylua', -- Used to format Lua code
      -- })
      -- require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        ensure_installed = {},
        automatic_enable = true,
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }

      vim.diagnostic.config { virtual_text = false }
    end,
  },
}
