return {
  { 
    'sopa0/telescope-makefile',
  },
  {
    'nvim-telescope/telescope.nvim',
    opts = function(_, opts)
      local telescope = require 'telescope'
      telescope.setup(opts)
      telescope.load_extension('make')
    end
  }
}
