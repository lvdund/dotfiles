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
