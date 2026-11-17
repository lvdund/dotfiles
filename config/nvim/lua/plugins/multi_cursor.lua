vim.pack.add({
  "https://github.com/jake-stewart/multicursor.nvim",
})

local mc = require("multicursor-nvim")

mc.setup()

-- While multi-cursor mode is active, Escape clears all secondary cursors.
mc.addKeymapLayer(function(layer_set)
  layer_set("n", "<Esc>", function()
    if mc.cursorsEnabled() then
      mc.clearCursors()
    else
      mc.enableCursors()
    end
  end)
end)

local function add_cursors_to_search_matches()
  local search = vim.fn.getreg("/")
  if search == "" then
    vim.notify("Search with / before enabling multi-cursor", vim.log.levels.WARN)
    return
  end

  mc.searchAllAddCursors()
end

vim.api.nvim_create_user_command("MultiCursor", add_cursors_to_search_matches, {
  desc = "Add a cursor to every match of the latest / search",
})

-- User commands must start with an uppercase letter, so expose the requested
-- lowercase :multi_cursor spelling as a command-line abbreviation.
vim.cmd([[cnoreabbrev <expr> multi_cursor getcmdtype() ==# ':' && getcmdline() ==# 'multi_cursor' ? 'MultiCursor' : 'multi_cursor']])
