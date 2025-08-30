return {
  'tomasky/bookmarks.nvim',
  event = 'VimEnter',
  config = function()
    require('bookmarks').setup {
      sign_priority = 8, --set bookmark sign priority to cover other sign
      save_file = vim.fn.expand '$HOME/.cache/bookmarks', -- bookmarks save file path
      keywords = {
        ['@t'] = '☑️', -- mark annotation startswith @t ,signs this icon as `Todo`
        ['@w'] = '⚠️', -- mark annotation startswith @w ,signs this icon as `Warn`
        ['@e'] = '🐞', -- mark annotation startswith @e ,signs this icon as `Error`
        ['@n'] = '📝', -- mark annotation startswith @n ,signs this icon as `Note`
      },
      on_attach = function(bufnr)
        local bm = require 'bookmarks'
        local map = vim.keymap.set
        -- map('n', 'mm', bm.bookmark_toggle, { desc = 'add/remove bookmark at line' })
        map('n', 'mm', bm.bookmark_ann, { desc = 'add/edit mark annotation at line' })
        map('n', 'mc', bm.bookmark_clean, { desc = 'clean all marks in local buffer' })
        map('n', 'mn', bm.bookmark_next, { desc = 'jump to next mark in local buffer' })
        map('n', 'mp', bm.bookmark_prev, { desc = 'jump to prev mark in local buffer' })
        map('n', 'ml', bm.bookmark_list, { desc = 'show marked list in quickfix window' })
        map('n', 'mx', bm.bookmark_clear_all, { desc = 'removes all bookmarks' })
      end,
    }
  end,
}
