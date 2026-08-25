return {
  {
    'stevearc/oil.nvim',
    cmd = 'Oil',
    dependencies = {
      { 'echasnovski/mini.icons', opts = {} },
    },
    config = function() require('configs.oil') end,
  },
  {
    'rcarriga/nvim-notify',
    event = 'VeryLazy',
    config = function(_, opts)
      local notify = require('notify')
      notify.setup(opts)
      vim.notify = notify
    end,
    opts = require('configs.notify'),
  },
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
    opts = require('configs.noice'),
  },
}
