local status, oil = pcall(require, 'oil')
if not status then
  vim.notify('not found oil.nvim')
  return
end

local detail = false

oil.setup({
  default_file_explorer = true,
  float = {
    padding = 2,
    max_width = 0.8,
    max_height = 0.8,
    border = 'rounded',
  },
  keymaps = {
    -- 与 Snacks Explorer 保持一致的浏览快捷键。
    ['<C-h>'] = false,
    ['<C-l>'] = false,
    ['<C-k>'] = false,
    ['<C-j>'] = false,
    ['<CR>'] = 'actions.select',
    ['<BS>'] = 'actions.parent',
    ['l'] = 'actions.select',
    ['h'] = 'actions.parent',
    ['u'] = 'actions.refresh',
    ['o'] = 'actions.open_external',
    ['<C-s>'] = { 'actions.select', opts = { horizontal = true } },
    ['<C-v>'] = { 'actions.select', opts = { vertical = true } },
    ['<C-t>'] = { 'actions.select', opts = { tab = true } },
    ['y'] = 'actions.yank_entry',
    ['H'] = 'actions.toggle_hidden',
    ['P'] = 'actions.preview',
    ['?'] = 'actions.show_help',
    ['q'] = 'actions.close',

    -- 保留原有别名，避免影响既有使用习惯。
    ['<C-r>'] = 'actions.refresh',
    ['<leader>y'] = 'actions.yank_entry',
    ['g.'] = false,
    ['zh'] = 'actions.toggle_hidden',
    ['\\'] = { 'actions.select', opts = { horizontal = true } },
    ['|'] = { 'actions.select', opts = { vertical = true } },
    ['`'] = 'actions.parent',
    ['gd'] = {
      desc = 'Toggle file detail view',
      callback = function()
        detail = not detail
        if detail then
          require('oil').set_columns({ 'icon', 'permissions', 'size', 'mtime' })
        else
          require('oil').set_columns({ 'icon' })
        end
      end,
    },
  },
})
