return {
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  {
    'mbbill/undotree',
    config = function()
      vim.g.undotree_WindowLayout = 2
      vim.g.undotree_ShortIndicators = 1
      vim.g.undotree_SetFocusWhenToggle = 1
      vim.g.undotree_HelpLine = 0
      vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
    end,
  },
  {
    'alexghergh/nvim-tmux-navigation',
    opts = {
      disable_when_zoomed = true, -- defaults to false
      keybindings = {
        left = '<C-h>',
        down = '<C-j>',
        up = '<C-k>',
        right = '<C-l>',
        -- last_active = '<C-\\>',
        -- next = '<C-Space>',
      },
    },
  },

  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      icons = {
        mappings = vim.g.have_nerd_font,
        keys = {},
      },

      -- Document existing key chains
      config = function()
        local wk = require 'which-key'
        wk.add {
          { '<leader>l', group = '[L]SP' },
          { '<leader>s', group = '[S]earch' },
          { '<leader>h', group = '[G]it Hunk', mode = { 'n', 'v' } },
        }
        -- spec = {
        --   -- { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
        --   -- { '<leader>d', group = '[D]ocument' },
        --   -- { '<leader>r', group = '[R]ename' },
        --   -- { '<leader>s', group = '[S]earch' },
        --   -- { '<leader>w', group = '[W]orkspace' },
        --   -- { '<leader>t', group = '[T]oggle' },
        --   -- { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
        -- },
      end,
    },
  },

  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',

        build = 'make',
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- [[ Configure Telescope ]]
      local actions = require 'telescope.actions'
      require('telescope').setup {
        --  All the info you're looking for is in `:help telescope.setup()`
        defaults = {

          -- TODO: winblend = 10,
          mappings = {
            i = {
              ['<C-j>'] = actions.move_selection_next,
              ['<C-k>'] = actions.move_selection_previous,
            },
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },

  {
    'catppuccin/nvim',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- Load the colorscheme here
      vim.cmd.colorscheme 'catppuccin-mocha'

      -- You can configure highlights by doing something like:
      vim.cmd.hi 'Comment gui=none'
      vim.cmd.hi 'Normal guibg=NONE ctermbg=NONE'
      vim.cmd.hi 'NormalNC guibg=NONE ctermbg=NONE'
    end,
  },

  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = {} },

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- require('mini.surround').setup()

      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v %:p'
      end
    end,
  },

  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      watch_for_changes = true,
      skip_confirm_for_simple_edits = true,
      view_options = {
        show_hidden = true,
      },
      float = {
        padding = 10,
      },
      keymaps = {
        ['<Esc>'] = 'actions.close',
        ['<C-j>'] = '',
        ['<C-k>'] = '',
      },
    },
    init = function()
      vim.api.nvim_set_keymap('n', '<leader>o', '', {
        noremap = true,
        callback = function()
          local oil = require 'oil'
          local util = require 'oil.util'

          oil.toggle_float()
          util.run_after_load(0, function()
            oil.open_preview()
          end)
        end,
      })
    end,
    -- Optional dependencies
    dependencies = { { 'echasnovski/mini.icons', opts = {} } },
    -- dependencies = { 'nvim-tree/nvim-web-devicons' }, -- use if prefer nvim-web-devicons
  },

  -- {
  --   'VonHeikemen/fine-cmdline.nvim',
  --   dependencies = { 'MunifTanjim/nui.nvim' },
  --   opts = {
  --     cmdline = {
  --       enable_keymaps = false,
  --     },
  --   },
  -- },
  -- {
  --   'folke/noice.nvim',
  --   event = 'VeryLazy',
  --   opts = {
  --     -- add any options here
  --   },
  --   dependencies = {
  --     -- if you lazy-load any plugin below, make sure to add proper `module='...'` entries
  --     'MunifTanjim/nui.nvim',
  --     -- OPTIONAL:
  --     --   `nvim-notify` is only needed, if you want to use the notification view.
  --     --   If not available, we use `mini` as the fallback
  --     'rcarriga/nvim-notify',
  --   }
  -- }
}
