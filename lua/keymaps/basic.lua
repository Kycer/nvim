local map = require('utils.keymap').set

-- 退出INSERT模式
map('i', 'jj', '<cmd>stopinsert<cr>', { desc = '退出INSERT模式' })
-- 全选
map('n', '<C-a>', '<cmd>normal! ggVG<cr>', { desc = '全选' })
-- 保存
map({ 'n', 'i', 'x', 's' }, '<C-s>', '<cmd>write<cr>', { desc = '保存文件' })

-- 退出
map('n', '<leader>qq', '<cmd>qa<cr>', { desc = 'Quit: 退出 Neovim' })
map('n', '<leader>qw', '<cmd>wqa<cr>', { desc = 'Quit: 保存全部并退出 Neovim' })

-- 清除搜索高亮
map('n', '<Esc>', '<cmd>nohlsearch<cr>', { desc = '清除搜索高亮' })

-- 窗口移动：高频操作直接使用 Ctrl
map('n', '<C-h>', '<C-w>h', { desc = '移动到左侧窗口' })
map('n', '<C-j>', '<C-w>j', { desc = '移动到下方窗口' })
map('n', '<C-k>', '<C-w>k', { desc = '移动到上方窗口' })
map('n', '<C-l>', '<C-w>l', { desc = '移动到右侧窗口' })

-- 调整窗口大小
map('n', '<A-Up>', '<cmd>resize -2<cr>', { desc = 'Window: 减小窗口高度' })
map('n', '<A-Down>', '<cmd>resize +2<cr>', { desc = 'Window: 增加窗口高度' })
map('n', '<A-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Window: 减小窗口宽度' })
map('n', '<A-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Window: 增加窗口宽度' })

-- HL 移动到行首/行尾
map({ 'n', 'v' }, '<A-h>', '^', { desc = '移动到行首' })
map({ 'n', 'v' }, '<A-l>', '$', { desc = '移动到行尾' })

-- 分屏
map('n', '<leader>wv', '<cmd>vsplit<cr>', { desc = '垂直分屏' })
map('n', '<leader>ws', '<cmd>split<cr>', { desc = '水平分屏' })
map('n', '<leader>wd', '<C-w>c', { desc = '关闭窗口' })

-- Buffer
map('n', 'bh', '<cmd>bprevious<cr>', { desc = '上一个 Buffer' })
map('n', 'bl', '<cmd>bnext<cr>', { desc = '下一个 Buffer' })

-- 可视模式移动代码；只读的 Picker/帮助窗口只移动选择，不修改其内容
map('x', 'J', function()
  if not vim.bo.modifiable then return 'j' end
  return ":move '>+1<CR>gv=gv"
end, { desc = '向下移动选中内容', expr = true })
map('x', 'K', function()
  if not vim.bo.modifiable then return 'k' end
  return ":move '<-2<CR>gv=gv"
end, { desc = '向上移动选中内容', expr = true })
map(
  'x',
  '<',
  function() return vim.bo.modifiable and '<gv' or '' end,
  { desc = '减少缩进并保持选区', expr = true }
)
map(
  'x',
  '>',
  function() return vim.bo.modifiable and '>gv' or '' end,
  { desc = '增加缩进并保持选区', expr = true }
)
