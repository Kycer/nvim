-- require('vim._core.ui2').enable({
--   enable = true,
-- })
require('core.options')
require('core.lazy')
require('core.autocmds')
require('keymaps')

vim.cmd([[colorscheme catppuccin-mocha]])
require('configs.statusline').setup()
