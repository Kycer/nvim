return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function() require('configs.treesitter') end,
  },
  {
    'chrisgrieser/nvim-origami',
    event = 'BufReadPost',
    init = function()
      vim.opt.foldcolumn = '1'
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99
      vim.opt.foldenable = true
      vim.opt.fillchars:append({ foldopen = '', foldclose = '', fold = ' ', foldsep = ' ' })
    end,
    opts = require('configs.origami'),
  },
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        { path = 'snacks.nvim', words = { 'Snacks' } },
      },
    },
  },
  {
    'saghen/blink.cmp',
    event = { 'InsertEnter', 'CmdlineEnter' },
    dependencies = {
      'saghen/blink.lib',
      -- optional: provides snippets for the snippet source
      'rafamadriz/friendly-snippets',
    },
    build = function()
      -- build the fuzzy matcher, optionally add a timeout to `pwait(timeout_ms)`
      -- you can use `gb` in `:Lazy` to rebuild the plugin as needed
      require('blink.cmp').build():pwait()
    end,
    opts = require('configs.blink'),
    opts_extend = { 'sources.default' },
  },
  -- todo
  {
    'folke/todo-comments.nvim',
    event = 'BufReadPost',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = true,
  },
  {
    'stevearc/conform.nvim',
    event = 'BufReadPost',
    config = function() require('configs.conform') end,
  },
  -- {
  --   'luozhiya/fittencode.nvim',
  --   opts = require('plugins.configs.fittencode'),
  -- },
  {
    'folke/ts-comments.nvim',
    opts = {},
    event = 'BufReadPost',
  },
  {
    'kylechui/nvim-surround',
    version = '*', -- Use for stability; omit to use `main` branch for the latest features
    event = 'BufReadPost',
    opts = {},
  },
}
