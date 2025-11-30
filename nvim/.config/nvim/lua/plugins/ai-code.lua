return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    require('codecompanion').setup {
      sources = {
        per_filetype = {
          codecompanion = { 'codecompanion' },
        },
      },
      display = {
        chat = {
          icons = {
            chat_context = ' ',
            chat_fold = ' ',
          },
          fold_context = true,
        },
        action_palette = {
          width = 95,
          height = 10,
          prompt = 'Prompt ', -- Prompt used for interactive LLM calls
          provider = 'telescope',
          opts = {
            show_default_actions = true,
            show_default_prompt_library = true,
            title = 'CodeCompanion actions',
          },
        },
      },
      adapters = {
        acp = {
          gemini_cli = function()
            return require('codecompanion.adapters').extend('gemini_cli', {
              defaults = {
                auth_method = 'oauth-personal', -- "oauth-personal"|"gemini-api-key"|"vertex-ai"
              },
              env = {
                GEMINI_API_KEY = 'cmd:op read op://personal/Gemini_API/credential --no-newline',
              },
            })
          end,
        },
      },
      strategies = {
        chat = {
          adapters = { name = 'gemini', model = 'gemini-3-pro-preview' },
          send = {
            modes = { n = '<C-s>', i = '<C-s>' },
            opts = {},
          },
          close = {
            modes = { n = '<C-c>', i = '<C-c>' },
            opts = {},
          },
          variables = {
            ['buffer'] = {
              opts = {
                default_params = 'pin', -- or 'watch'
              },
            },
          },
          slash_commands = {
            ['file'] = {
              callback = 'strategies.chat.slash_commands.file',
              opts = {
                provider = 'telescope',
                contains_code = true,
              },
            },
            ['image'] = {
              callback = 'strategies.chat.slash_commands.catalog.image',
              enabled = function(opts)
                return opts.adapter.opts and opts.adapter.opts.vision == true
              end,
            },
          },
        },
      },
    }
  end,
}
