return {
  {
    'NMAC427/guess-indent.nvim',
  },
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {},
  },
  {
    'ya2s/nvim-cursorline',
    config = function()
      require('nvim-cursorline').setup {
        cursorline = {
          enable = true,
          timeout = 300,
          number = false,
        },
        cursorword = {
          enable = true,
          min_length = 3,
          hl = { underline = true },
        },
      }
    end,
  },
  {
    'karb94/neoscroll.nvim',
    opts = function()
      local neoscroll = require 'neoscroll'
      local keymap = {
        ['<PageUp>'] = function()
          neoscroll.scroll(-0.2, { move_cursor = false, duration = 70 })
        end,
        ['<PageDown>'] = function()
          neoscroll.scroll(0.2, { move_cursor = false, duration = 70 })
        end,
      }

      for key, func in pairs(keymap) do
        vim.keymap.set({ 'n', 'v', 'x', 'i' }, key, func)
      end
    end,
  },
  {
    'mawkler/refjump.nvim',
    event = 'LspAttach', -- Uncomment to lazy load
    opts = {
      keymaps = {
        enable = true,
        next = ']r', -- Keymap to jump to next LSP reference
        prev = '[r', -- Keymap to jump to previous LSP reference
      },
      highlights = {
        enable = true, -- Highlight the LSP references on jump
        auto_clear = true, -- Automatically clear highlights when cursor moves
      },
      integrations = {
        demicolon = {
          enable = true, -- Make `]r`/`[r` repeatable with `;`/`,` using demicolon.nvim
        },
      },
      verbose = true, -- Print message if no reference is found
    },
  },
  {
    'jake-stewart/multicursor.nvim',
    branch = '1.0',
    config = function()
      local mc = require 'multicursor-nvim'
      mc.setup()

      local set = vim.keymap.set

      -- Add or skip cursor above/below the main cursor.
      -- set({ 'n', 'x' }, '<up>', function()
      --   mc.lineAddCursor(-1)
      -- end)
      -- set({ 'n', 'x' }, '<down>', function()
      --   mc.lineAddCursor(1)
      -- end)
      -- set({ 'n', 'x' }, '<leader><up>', function()
      --   mc.lineSkipCursor(-1)
      -- end)
      -- set({ 'n', 'x' }, '<leader><down>', function()
      --   mc.lineSkipCursor(1)
      -- end)

      -- Add or skip adding a new cursor by matching word/selection
      set({ 'n', 'x' }, 'cn', function()
        mc.matchAddCursor(1)
      end)
      set({ 'n', 'x' }, 'cs', function()
        mc.matchSkipCursor(1)
      end)
      set({ 'n', 'x' }, 'cN', function()
        mc.matchAddCursor(-1)
      end)
      set({ 'n', 'x' }, 'cS', function()
        mc.matchSkipCursor(-1)
      end)

      -- Add and remove cursors with control + left click.
      -- set('n', '<c-leftmouse>', mc.handleMouse)
      -- set('n', '<c-leftdrag>', mc.handleMouseDrag)
      -- set('n', '<c-leftrelease>', mc.handleMouseRelease)

      -- Disable and enable cursors.
      set({ 'n', 'x' }, '<c-c>', mc.toggleCursor)

      -- Mappings defined in a keymap layer only apply when there are
      -- multiple cursors. This lets you have overlapping mappings.
      mc.addKeymapLayer(function(layerSet)
        -- Select a different cursor as the main one.
        layerSet({ 'n', 'x' }, '<left>', mc.prevCursor)
        layerSet({ 'n', 'x' }, '<right>', mc.nextCursor)

        -- Delete the main cursor.
        layerSet({ 'n', 'x' }, '<leader>x', mc.deleteCursor)

        -- Enable and clear cursors using escape.
        layerSet('n', '<esc>', function()
          if not mc.cursorsEnabled() then
            mc.enableCursors()
          else
            mc.clearCursors()
          end
        end)
      end)

      -- Customize how cursors look.
      local hl = vim.api.nvim_set_hl
      hl(0, 'MultiCursorCursor', { reverse = true })
      hl(0, 'MultiCursorVisual', { link = 'Visual' })
      hl(0, 'MultiCursorSign', { link = 'SignColumn' })
      hl(0, 'MultiCursorMatchPreview', { link = 'Search' })
      hl(0, 'MultiCursorDisabledCursor', { reverse = true })
      hl(0, 'MultiCursorDisabledVisual', { link = 'Visual' })
      hl(0, 'MultiCursorDisabledSign', { link = 'SignColumn' })
    end,
  },
}
