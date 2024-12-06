-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set({ 'n', 'v' }, 'ö', ':')
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('', 'ö', ':', { desc = 'Open Command' })

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })


vim.keymap.set('i', '<M-BS>', '<C-W>', { silent = true, desc = 'Delete last word' })
vim.keymap.set('n', '<Tab>', '>>', { silent = true, desc = 'Indent' })
vim.keymap.set('n', '<S-Tab>', '<<', { silent = true, desc = 'Dedent' })
vim.keymap.set('v', '<Tab>', '>', { silent = true, desc = 'Indent' })
vim.keymap.set('v', '<S-Tab>', '<', { silent = true, desc = 'Dedent' })
-- vim.keymap.set('n', 'asdf', '', { callback = function()
-- local Popup = require('nui.popup')
--
-- local popup = Popup({
--   position = '50%',
--   size = {
--     width = 80,
--     height = 40,
--   },
--   enter = true,
--   focusable = true,
--   zindex = 50,
--   relative = 'editor',
--   border = {
--     padding = {
--       top = 2,
--       bottom = 2,
--       left = 3,
--       right = 3,
--     },
--     style = 'rounded',
--     text = {
--       top = ' I am top title ',
--       top_align = 'center',
--       bottom = 'I am bottom title',
--       bottom_align = 'left',
--     },
--   },
--   buf_options = {
--     modifiable = true,
--     readonly = false,
--   },
--   win_options = {
--     winblend = 10,
--     winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
--   },
-- })
-- popup:mount()
-- end })
