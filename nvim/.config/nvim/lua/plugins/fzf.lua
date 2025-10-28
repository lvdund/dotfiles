return {
  {
    'ibhagwan/fzf-lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = {
      -- Find files
      { '<leader>sf', '<cmd>FzfLua files<cr>', desc = 'Find Files' },
      { '<leader>sg', '<cmd>FzfLua live_grep<cr>', desc = 'Live Grep' },
      { '<leader>ss', '<cmd>FzfLua resume<cr>', desc = 'Resume Last Search' },
      { '<leader>sd', '<cmd>FzfLua diagnostics_document<cr>', desc = 'Document Diagnostics' },
      { '<leader>sD', '<cmd>FzfLua diagnostics_workspace<cr>', desc = 'Workspace Diagnostics' },

      -- LSP bindings
      { 'gd', '<cmd>FzfLua lsp_definitions<cr>', desc = 'Go to Definition' },
      { 'gD', '<cmd>FzfLua lsp_declarations<cr>', desc = 'Go to Declaration' },
      { 'grr', '<cmd>FzfLua lsp_references<cr>', desc = 'Find References' },
      { 'gri', '<cmd>FzfLua lsp_implementations<cr>', desc = 'Go to Implementation' },
      { 'grt', '<cmd>FzfLua lsp_typedefs<cr>', desc = 'Go to Type Definition' },
      { 'gra', '<cmd>FzfLua lsp_code_action<cr>', desc = 'Code Actions' },
      { 'grn', vim.lsp.buf.rename, desc = 'Rename' },
      { 'gro', '<cmd>FzfLua lsp_document_symbols<cr>', desc = 'Document Symbols' },

      -- other
      { '<leader>sn', ':Noice history<CR>', desc = 'List Notifications' },
      { '<leader>scc', ':TodoFzfLua<CR>', desc = 'List all TODO' },
      {
        '<leader>scn',
        function()
          require('todo-comments').jump_next()
        end,
        desc = '[N]ext TODO',
      },
      {
        '<leader>scp',
        function()
          require('todo-comments').jump_prev()
        end,
        desc = '[N]ext TODO',
      },
    },
    opts = function(_, opts)
      local fzf = require 'fzf-lua'
      local actions = fzf.actions

      -- Default keymaps for fzf UI
      fzf.config.defaults.keymap = {
        fzf = {
          ['ctrl-q'] = 'select-all+accept', -- send all to quickfix
          ['tab'] = 'toggle', -- toggle selection
          ['shift-tab'] = 'toggle-all', -- toggle all
          ['ctrl-a'] = 'select-all', -- select all
          ['ctrl-d'] = 'deselect-all', -- deselect all
        },
      }

      -- Actions for file and grep pickers
      fzf.config.defaults.actions = {
        files = {
          ['default'] = actions.file_edit,
          ['ctrl-x'] = actions.file_split,
          ['ctrl-v'] = actions.file_vsplit,
          -- ['ctrl-h'] = actions.toggle_hidden,
          ['alt-q'] = actions.file_sel_to_qf,
        },
        grep = {
          ['default'] = actions.file_edit,
          ['ctrl-x'] = actions.file_split,
          ['ctrl-v'] = actions.file_vsplit,
          -- ['ctrl-h'] = actions.toggle_hidden,
          ['alt-q'] = actions.file_sel_to_qf,
        },
      }

      -- Window configuration
      opts.winopts = {
        width = 0.85,
        height = 0.85,
        preview = {
          default = 'builtin',
          layout = 'vertical',
          vertical = 'down:55%',
          hidden = 'nohidden',
          scrollchars = { '┃', '' },
        },
      }

      -- Files picker: always show hidden files
      opts.files = {
        prompt = 'Files ❯ ',
        file_icons = true,
        git_icons = true,
        color_icons = true,
        find_opts = [[-type f -not -path '*/\.git/*' -printf '%P\n']],
        fd_opts = [[--color=never --type f --hidden --follow --exclude .git]],
        rg_opts = [[--files --hidden --follow -g '!.git']],
        hidden = true, -- always show hidden files
      }

      -- Grep pickers: always search hidden files
      opts.grep = {
        prompt = 'Grep ❯ ',
        input_prompt = 'Grep For ❯ ',
        file_icons = true,
        git_icons = true,
        rg_opts = table.concat({
          '--follow',
          '--column',
          '--line-number',
          '--smart-case',
          '--max-columns=4096',
          '--hidden',
          '--glob=!**/.git/**',
        }, ' '),
        no_ignore = true,
        hidden = true,
        rg_glob = true,
        glob_flag = '--iglob',
        glob_separator = '%s%-%-',
      }

      -- Live grep
      opts.live_grep = {
        prompt = 'Live Grep ❯ ',
        rg_opts = opts.grep.rg_opts,
        hidden = true,
      }

      -- LSP pickers with custom prompts
      opts.lsp = {
        prompt_postfix = '❯ ',
        symbols = {
          prompt_postfix = '❯ ',
          symbol_icons = {
            File = '󰈔',
            Module = '󰏗 ',
            Namespace = '󰌗 ',
            Package = '󰏗 ',
            Class = '󰠱 ',
            Method = '󰆧 ',
            Property = '󰜢 ',
            Field = '󰇽 ',
            Constructor = '󰆧 ',
            Enum = '󰒻 ',
            Interface = '󰜰 ',
            Function = '󰊕',
            Variable = '󰫧 ',
            Constant = '󰏿 ',
            String = '󰉿 ',
            Number = '󰎠 ',
            Boolean = '󰨙 ',
            Array = '󰅪 ',
            Object = '󰅩 ',
            Key = '󰌋 ',
            Null = '󰟢 ',
            EnumMember = '󰒻 ',
            Struct = '󰌗 ',
            Event = '󱐋 ',
            Operator = '󰆕 ',
            TypeParameter = '󰊄 ',
          },
        },
        -- Individual LSP picker prompts
        code_actions = { prompt = 'Code Actions ❯ ' },
        definitions = { prompt = 'Definitions ❯ ' },
        declarations = { prompt = 'Declarations ❯ ' },
        implementations = { prompt = 'Implementations ❯ ' },
        references = { prompt = 'References ❯ ' },
        type_definitions = { prompt = 'Type Definitions ❯ ' },
        document_symbols = { prompt = 'Document Symbols ❯ ' },
        workspace_symbols = { prompt = 'Workspace Symbols ❯ ' },
        dynamic_workspace_symbols = { prompt = 'Dynamic Symbols ❯ ' },
      }

      -- Diagnostics pickers
      opts.diagnostics = {
        prompt = 'Diagnostics ❯ ',
        file_icons = true,
        git_icons = false,
        color_icons = true,
        diag_icons = true,
      }

      -- Git pickers with icons
      opts.git = {
        files = {
          prompt = 'Git Files ❯ ',
          file_icons = true,
          git_icons = true,
          color_icons = true,
        },
        status = {
          prompt = 'Git Status ❯ ',
          file_icons = true,
          git_icons = true,
          color_icons = true,
        },
        commits = { prompt = 'Git Commits ❯ ' },
        branches = { prompt = 'Git Branches ❯ ' },
      }

      -- Resume picker
      opts.resume = {
        prompt = 'Resume ❯ ',
      }

      -- Help window configuration
      opts.help_open_win = function(buf, enter, wopts)
        wopts = wopts or {}
        wopts.relative = 'editor'
        wopts.anchor = 'NW'
        wopts.row = 1
        wopts.col = 2
        wopts.width = math.floor(vim.o.columns * 0.5)
        wopts.height = math.floor(vim.o.lines * 0.4)
        wopts.border = 'single'
        return vim.api.nvim_open_win(buf, enter, wopts)
      end

      -- Apply final configuration
      return vim.tbl_deep_extend('force', opts, {
        { 'default-title' },
        fzf_colors = true,
      })
    end,
  },
}
