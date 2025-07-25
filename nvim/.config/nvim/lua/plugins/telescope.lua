return {
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
      'tomasky/bookmarks.nvim',
    },
    config = function()
      local pickers = require 'telescope.pickers'
      local finders = require 'telescope.finders'
      local actions = require 'telescope.actions'
      local make_entry = require 'telescope.make_entry'
      local conf = require('telescope.config').values

      local select_one_or_multi = function(prompt_bufnr)
        local picker = require('telescope.actions.state').get_current_picker(prompt_bufnr)
        local multi = picker:get_multi_selection()
        if not vim.tbl_isempty(multi) then
          require('telescope.actions').close(prompt_bufnr)
          for _, j in pairs(multi) do
            if j.path ~= nil then
              vim.cmd(string.format('%s %s', 'edit', j.path))
            end
          end
        else
          require('telescope.actions').select_default(prompt_bufnr)
        end
      end

      -- Example 1: search "func" only in file comments.lua
      -- func  *ents.lua
      -- Example 2: search "func" only in folder plugins
      -- func  **/plugins/**
      local live_multigrep = function(opts)
        opts = opts or {}
        opts.cwd = opts.cwd or vim.uv.cwd()

        local finder = finders.new_async_job {
          command_generator = function(prompt)
            if not prompt or prompt == '' then
              return nil
            end

            local pieces = vim.split(prompt, '  ')
            local args = { 'rg' }
            if pieces[1] then
              table.insert(args, '-e')
              table.insert(args, pieces[1])
            end

            if pieces[2] then
              table.insert(args, '-g')
              table.insert(args, pieces[2])
            end

            ---@diagnostic disable-next-line: deprecated
            return vim.tbl_flatten {
              args,
              {
                '--hidden',
                '--color=never',
                '--no-heading',
                '--with-filename',
                '--line-number',
                '--column',
                '--smart-case',
              },
            }
          end,
          entry_maker = make_entry.gen_from_vimgrep(opts),
          cwd = opts.cwd,
        }

        pickers
          .new(opts, {
            debounce = 100,
            prompt_title = 'Multi Grep',
            finder = finder,
            previewer = conf.grep_previewer(opts),
            sorter = require('telescope.sorters').empty(),
          })
          :find()
      end

      require('telescope').setup {
        defaults = {
          mappings = {
            n = {
              ['<C-w>'] = actions.send_selected_to_qflist + actions.open_qflist,
            },
            i = {
              ['<CR>'] = select_one_or_multi,
              ['<C-w>'] = actions.send_selected_to_qflist + actions.open_qflist,
              ['<C-S-d>'] = actions.delete_buffer,
            },
          },
          vimgrep_arguments = {
            'rg',
            '--hidden',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
          },
          layout_strategy = 'vertical',
          layout_config = {
            horizontal = {
              preview_width = 0.6,
              width = 0.85,
            },
            vertical = {
              preview_height = 0.6,
              height = 0.85,
            },
          },
          prompt_prefix = ' ',
          selection_caret = ' ',
          -- open files in the first window that is an actual file.
          -- use the current window if no other window is available.
          get_selection_window = function()
            local wins = vim.api.nvim_list_wins()
            table.insert(wins, 1, vim.api.nvim_get_current_win())
            for _, win in ipairs(wins) do
              local buf = vim.api.nvim_win_get_buf(win)
              if vim.bo[buf].buftype == '' then
                return win
              end
            end
            return 0
          end,
        },
        pickers = {
          find_files = {
            find_command = function()
              if 1 == vim.fn.executable 'rg' then
                return { 'rg', '--files', '--color', 'never', '-g', '!.git' }
              elseif 1 == vim.fn.executable 'fd' then
                return { 'fd', '--type', 'f', '--color', 'never', '-E', '.git' }
              elseif 1 == vim.fn.executable 'fdfind' then
                return { 'fdfind', '--type', 'f', '--color', 'never', '-E', '.git' }
              elseif 1 == vim.fn.executable 'find' and vim.fn.has 'win32' == 0 then
                return { 'find', '.', '-type', 'f' }
              elseif 1 == vim.fn.executable 'where' then
                return { 'where', '/r', '.', '*' }
              end
            end,
            hidden = true, -- Show dotfiles
            follow = true, -- Follow symlinks
          },
        },
        extensions = {
          fzf = {},
          ['ui-select'] = {
            require('telescope.themes').get_dropdown {},
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
      pcall(require('telescope').load_extension, 'bookmarks')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>st', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', live_multigrep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>ss', builtin.resume, { desc = '[S]earch Re[s]ume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', 'sb', builtin.buffers, { desc = '[S]earch existing [B]uffers' })
      vim.keymap.set('n', '<leader>sp', ':Telescope projects<CR>', { desc = '[S]earch [P]rojects' })
      vim.keymap.set('n', '<leader>sm', ':Telescope bookmarks list<CR>', { desc = '[S]earch Book[M]arks' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 20,
          previewer = true,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>sb', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch in Open [B]uffers' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },
  {
    'ahmedkhalf/project.nvim',
    config = function()
      require('telescope').load_extension 'projects'
      require('project_nvim').setup {
        patterns = { '.git', '_darcs', '.hg', '.bzr', '.svn', 'Makefile', 'package.json', 'go.mod' },
        show_hidden = true,
      }
    end,
  },
}
