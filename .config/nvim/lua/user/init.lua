return {
  colorscheme = 'catppuccin',
  polish = function()
    vim.filetype.add({
      extension = {
        qml = 'qml'
      }
    })

    vim.cmd('hi Normal guibg=NONE ctermbg=NONE')
    vim.cmd('hi NormalNC guibg=NONE ctermbg=NONE')

    vim.cmd([[
      let s:baleia = luaeval("require('baleia').setup { }")
      command! BaleiaColorize call s:baleia.once(bufnr('%'))
      ]])
  end
}
