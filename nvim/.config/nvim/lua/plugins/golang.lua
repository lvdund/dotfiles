return {
  {
    'maxandron/goplements.nvim',
    ft = 'go',
    opts = {
      prefix = {
        interface = 'implemented by: ',
        struct = 'implements: ',
      },
      display_package = true,
      namespace_name = 'goplements',
      highlight = 'Goplements',
    },
  },
  {
    'edolphin-ydf/goimpl.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    init = function()
      vim.keymap.set('n', '<leader>im', function()
        require('telescope').extensions.goimpl.goimpl()
      end, { desc = '' })
    end,
    config = function()
      require('telescope').load_extension 'goimpl'
    end,
    ft = 'go',
  },
  -- {
  --   'hrsh7th/nvim-cmp',
  --   dependencies = {
  --     'Snikimonkd/cmp-go-pkgs',
  --   },
  --   config = function()
  --     local cmp = require 'cmp'
  --
  --     cmp.setup {
  --       sources = {
  --         { name = 'go_pkgs' },
  --       },
  --       -- to use . and / in urls
  --       matching = { disallow_symbol_nonprefix_matching = false },
  --     }
  --   end,
  -- },
  {
    'zgs225/gomodifytags.nvim',
    cmd = { 'GoAddTags', 'GoRemoveTags', 'GoInstallModifyTagsBin' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('gomodifytags').setup() -- Optional: You can add any specific configuration here if needed.
    end,
  },
}
