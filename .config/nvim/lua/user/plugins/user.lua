return {
  'm00qek/baleia.nvim',
  { 'catppuccin/nvim', name = 'catppuccin', priority = 1000 },
  {
    'rcarriga/nvim-notify',
    config = function()
      require("notify").setup({
        background_colour = "#000000",
      })
    end
  },
  'sopa0/telescope-makefile',
  {
    'nvim-telescope/telescope.nvim',
    opts = function(_, opts)
      local telescope = require 'telescope'
      telescope.setup(opts)
      telescope.load_extension('make')
    end
  }
}
