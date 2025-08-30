-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    -- { '<leader>nf', '<Cmd>Neotree position=float reveal<CR>', desc = '[N]eoTree [F]loat', silent = true },
    -- { '<leader>nl', '<Cmd>Neotree position=left reveal<CR>', desc = '[N]eoTree [L]eft', silent = true },
    -- { '\\', '<Cmd>Neotree toggle<CR>', desc = 'Neotree toggle', silent = true },
    { '\\', '<Cmd>Neotree position=float reveal<CR>', desc = 'Neotree toggle', silent = true },
  },
  opts = {
    default_component_configs = {
      container = {
        enable_character_fade = true,
      },
      git_status = {
        symbols = {
          -- Change type
          added = '✚',
          modified = '',
          deleted = '✖',
          renamed = '󰁕',
          -- Status type
          untracked = '',
          ignored = ' ',
          unstaged = '✗',
          staged = ' ',
          conflict = '',
        },
      },
    },
    source_selector = {
      lualine = false,
    },
    filesystem = {
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
      filtered_items = {
        visible = true, -- when true, they will just be displayed differently than normal items
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_hidden = true, -- only works on Windows for hidden files/directories
        hide_by_name = {},
        hide_by_pattern = {},
        always_show = { '.gitignored' },
        always_show_by_pattern = { '.env*' },
        never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
          --".DS_Store",
          --"thumbs.db"
        },
        never_show_by_pattern = { -- uses glob style patterns
          --".null-ls_*",
        },
      },
      follow_current_file = {
        enabled = false, -- This will find and focus the file in the active buffer every time
        --               -- the current file is changed while the tree is open.
        leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
      },
    },
    commands = {
      -- Override delete to use trash instead of rm
      delete = function(state)
        local inputs = require 'neo-tree.ui.inputs'
        local path = state.tree:get_node().path
        local msg = 'Are you sure you want to trash ' .. path
        inputs.confirm(msg, function(confirmed)
          if not confirmed then
            return
          end

          vim.fn.system { 'trash', vim.fn.fnameescape(path) }
          require('neo-tree.sources.manager').refresh(state.name)
        end)
      end,
    },
  },
}
