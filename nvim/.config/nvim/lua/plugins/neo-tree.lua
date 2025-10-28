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
    { '\\', '<Cmd>Neotree position=float reveal_force_cwd<CR>', desc = 'Neotree toggle', silent = true },
  },
  opts = {
    default_component_configs = {
      container = {
        enable_character_fade = true,
      },
      git_status = {
        symbols = {
          -- Change type
          added = '✚ ',
          modified = '',
          deleted = '✖ ',
          renamed = '󰁕',
          -- Status type
          untracked = '',
          ignored = ' ',
          unstaged = '✗',
          staged = ' ',
          conflict = ' ',
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
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_hidden = false,
        hide_by_name = {},
        hide_by_pattern = {},
        always_show = { '.gitignored' },
        always_show_by_pattern = { '.env*' },
      },
      follow_current_file = {
        enabled = true,
        leave_dirs_open = true,
      },
    },
    commands = {
      -- -- Override delete to use trash instead of rm
      -- delete = function(state)
      --   local inputs = require 'neo-tree.ui.inputs'
      --   local path = state.tree:get_node().path
      --   local msg = 'Are you sure you want to trash ' .. path
      --   inputs.confirm(msg, function(confirmed)
      --     if not confirmed then
      --       return
      --     end
      --
      --     vim.fn.system { 'trash', vim.fn.fnameescape(path) }
      --     require('neo-tree.sources.manager').refresh(state.name)
      --   end)
      -- end,
    },
  },
}
