-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

require('opts')
require('maps')
require('my_lazy')

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- vim.api.nvim_create_autocmd({'BufEnter', 'BufWinEnter'}, {
--   callback = function(ev)
--     print(string.format('event fired: %s', vim.inspect(ev)))
--   end
-- })
--   vim.api.nvim_create_autocmd('SessionLoadPost', {
--     desc = 'Load oil buffers after a session is loaded',
--     -- group = aug,
--     -- pattern = '*',
--     callback = function(params)
--       if vim.g.SessionLoad ~= 1 then
--         return
--       end
--       local util = require('oil.util')
--       local scheme = util.parse_url(params.file)
--       if config.adapters[scheme] and vim.api.nvim_buf_line_count(params.buf) == 1 then
--         load_oil_buffer(params.buf)
--       end
--     end,
--   })
