return {
  n = {
    ['ö'] = { ':', desc = 'Command' },
    ['<leader>fm'] = { '<cmd>Telescope make<cr>', desc = 'Find makefiles' },
    -- ['gD'] = { function() vim.lsp.buf.declaration() end, desc = 'Go to Declaration' },
    -- ['gd'] = { function() vim.lsp.buf.definition() end, desc = 'Go to Definition' },
    ['go'] = { '<cmd>:ClangdSwitchSourceHeader<cr>', desc = 'Switch Header <> Source', noremap = true, silent = true },
    ['vie'] = { 'ggVG', desc = 'Select entire file', noremap = true, silent = true },
    -- ['C-h'] = { [[<cmd>lua require('tmux').move_left()<cr>]], desc = 'tmux left pane' },
    -- ['C-j'] = { [[<cmd>lua require('tmux').move_down()<cr>]], desc = 'tmux down pane' },
    -- ['C-k'] = { [[<cmd>lua require('tmux').move_up()<cr>]], desc = 'tmux up pane' },
    -- ['C-l'] = { [[<cmd>lua require('tmux').move_right()<cr>]], desc = 'tmux right pane' }
  },
  t = {
    ['<Esc>'] = { [[<C-\><C-n>]], desc = 'Exit terminal' }
  }
}
