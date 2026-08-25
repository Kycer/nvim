local map = require('utils.keymap').set

-- 高频操作（不使用 Leader）
map('n', '<A-e>', function() require('oil').open_float() end, { desc = 'Find/File: 打开 Oil 文件浏览器' })
map('n', '<leader>e', function() Snacks.explorer() end, { desc = 'Find/File: 打开 Snacks 文件浏览器' })
map('n', '<A-f>', function() Snacks.picker.files() end, { desc = 'Find/File: 查找文件' })
map('n', '<A-b>', function() Snacks.picker.buffers() end, { desc = 'Buffer: 查找已打开的 Buffer' })
map('n', '<A-k>', function() require('aerial').snacks_picker() end, { desc = 'Search: 查找当前 Buffer 的符号' })
map('n', '<A-g>', function() Snacks.picker.grep() end, { desc = 'Search: 全局文本搜索' })
map('n', '<A-s>', function() Snacks.picker.grep_buffers() end, { desc = 'Search: 在已打开的 Buffer 中搜索' })
map('n', 'bd', function() Snacks.bufdelete() end, { desc = 'Buffer: 删除当前 Buffer' })
map(
  'n',
  '<A-j>',
  function() require('multicursor-nvim').matchAddCursor(1) end,
  { desc = 'Tools: 为下一个匹配项添加光标' }
)
map(
  'n',
  '<A-S-j>',
  function() require('multicursor-nvim').deleteCursor() end,
  { desc = 'Tools: 删除当前多光标' }
)
map('n', '<A-S-b>', function() require('bookmarks').bookmark_list() end, { desc = 'Tools: 打开书签列表' })
map({ 'n', 'x', 'o' }, '<A-t>', function() require('flash').jump() end, { desc = 'Search: Flash 跳转' })
map('o', 'r', function() require('flash').remote() end, { desc = 'Search: Flash 远程操作' })
map('o', 'R', function() require('flash').treesitter_search() end, { desc = 'Search: Flash Treesitter 远程操作' })

-- Find / File
map(
  'n',
  '<leader>fc',
  function() Snacks.picker.files({ cwd = vim.fn.stdpath('config') }) end,
  { desc = 'Find/File: 查找 Neovim 配置文件' }
)
map('n', '<leader>fg', function() Snacks.picker.git_files() end, { desc = 'Find/File: 查找 Git 文件' })
map('n', '<leader>fp', function() Snacks.picker.projects() end, { desc = 'Find/File: 查找项目' })
map('n', '<leader>fr', function() Snacks.picker.recent() end, { desc = 'Find/File: 查找最近文件' })

-- Search / Query
map('n', '<leader>sl', function() Snacks.picker.lines() end, { desc = 'Search: 查找当前 Buffer 的行' })
map(
  { 'n', 'x' },
  '<leader>sw',
  function() Snacks.picker.grep_word() end,
  { desc = 'Search: 搜索光标单词或选中内容' }
)
map(
  'n',
  '<leader>sr',
  function()
    require('grug-far').open({
      prefills = {
        paths = vim.fn.expand('%'),
        search = vim.fn.expand('<cword>'),
      },
      transient = true,
    })
  end,
  { desc = 'Search: 搜索并替换当前文件' }
)
map('n', '<leader>s/', function() Snacks.picker.search_history() end, { desc = 'Search: 查找搜索历史' })
map('n', '<leader>sa', function() Snacks.picker.autocmds() end, { desc = 'Search: 查找自动命令' })
map('n', '<leader>sc', function() Snacks.picker.command_history() end, { desc = 'Search: 查找命令历史' })
map('n', '<leader>sC', function() Snacks.picker.commands() end, { desc = 'Search: 查找 Neovim 命令' })
map(
  { 'n', 'x', 'o' },
  '<leader>sf',
  function() require('flash').treesitter() end,
  { desc = 'Search: Flash Treesitter 跳转' }
)
map('n', '<leader>sh', function() Snacks.picker.help() end, { desc = 'Search: 查找帮助文档' })
map('n', '<leader>sH', function() Snacks.picker.highlights() end, { desc = 'Search: 查找高亮组' })
map('n', '<leader>sj', function() Snacks.picker.jumps() end, { desc = 'Search: 查找跳转历史' })
map('n', '<leader>sk', function() Snacks.picker.keymaps() end, { desc = 'Search: 查找快捷键' })
-- map('n', '<leader>sL', function() Snacks.picker.loclist() end, { desc = 'Search: 查找位置列表' })
map('n', '<leader>sm', function() Snacks.picker.marks() end, { desc = 'Search: 查找标记' })
map('n', '<leader>sM', function() Snacks.picker.man() end, { desc = 'Search: 查找 Man 手册' })
map('n', '<leader>sp', function() Snacks.picker.pickers() end, { desc = 'Search: 查找 Snacks Picker' })
map('n', '<leader>sP', function() Snacks.picker.lazy() end, { desc = 'Search: 查找插件配置' })
-- map('n', '<leader>sq', function() Snacks.picker.qflist() end, { desc = 'Search: 查找 Quickfix 列表' })
-- map('n', '<leader>sR', function() Snacks.picker.resume() end, { desc = 'Search: 恢复上一次查找' })
map('n', '<leader>st', function()
  require('todo-comments')
  Snacks.picker.todo_comments({ keywords = { 'TODO', 'FIX', 'FIXME' } })
end, { desc = 'Search: 查找待办注释' })
map('n', '<leader>su', function() Snacks.picker.undo() end, { desc = 'Search: 查找撤销历史' })
map('n', '<leader>sx', function() Snacks.picker.cliphist() end, { desc = 'Search: 查找剪贴板历史' })
map('n', '<leader>sn', function() require('noice').cmd('history') end, { desc = 'Search: 查找消息历史' })

-- Buffer
vim.api.nvim_create_user_command('BufferDeleteAll', function(opts) Snacks.bufdelete.all({ force = opts.bang }) end, {
  bang = true,
  desc = '安全删除全部 Buffer',
  force = true,
})
map('n', '<leader>bD', '<cmd>BufferDeleteAll<cr>', { desc = 'Buffer: 删除全部 Buffer' })
map('n', '<leader>bs', function() Snacks.scratch() end, { desc = 'Buffer: 打开或关闭 Scratch Buffer' })
map('n', '<leader>bS', function() Snacks.scratch.select() end, { desc = 'Buffer: 选择 Scratch Buffer' })

-- Code
map('n', '<leader>cR', function() Snacks.rename.rename_file() end, { desc = 'Code: 重命名当前文件' })

-- Git
map('n', '<leader>gb', function() Snacks.picker.git_branches() end, { desc = 'Git: 查找分支' })
map('n', '<leader>gd', function() Snacks.picker.git_diff() end, { desc = 'Git: 查找变更块' })
map('n', '<leader>gf', function() Snacks.picker.git_log_file() end, { desc = 'Git: 查看当前文件日志' })
map('n', '<leader>gl', function() Snacks.picker.git_log() end, { desc = 'Git: 查看仓库日志' })
map('n', '<leader>gL', function() Snacks.picker.git_log_line() end, { desc = 'Git: 查看当前行日志' })
map('n', '<leader>gs', function() Snacks.picker.git_status() end, { desc = 'Git: 查看工作区状态' })
map('n', '<leader>gS', function() Snacks.picker.git_stash() end, { desc = 'Git: 查看 Stash' })
map({ 'n', 'x' }, '<leader>gB', function() Snacks.gitbrowse() end, { desc = 'Git: 在浏览器中打开仓库' })
map('n', '<leader>gG', function() Snacks.lazygit() end, { desc = 'Git: 打开 Lazygit' })
map('n', ']h', function()
  if vim.wo.diff then return vim.cmd.normal({ ']c', bang = true }) end
  require('gitsigns').nav_hunk('next')
end, { desc = 'Git: 跳到下一个变更块' })
map('n', '[h', function()
  if vim.wo.diff then return vim.cmd.normal({ '[c', bang = true }) end
  require('gitsigns').nav_hunk('prev')
end, { desc = 'Git: 跳到上一个变更块' })
map(
  'n',
  '<leader>ghs',
  function() require('gitsigns').stage_hunk() end,
  { desc = 'Git/Hunk: 暂存或取消暂存变更块' }
)
map('n', '<leader>ghr', function() require('gitsigns').reset_hunk() end, { desc = 'Git/Hunk: 还原当前变更块' })
map('n', '<leader>ghp', function() require('gitsigns').preview_hunk() end, { desc = 'Git/Hunk: 预览当前变更块' })
map(
  'n',
  '<leader>ghb',
  function() require('gitsigns').blame_line({ full = true }) end,
  { desc = 'Git/Hunk: 查看当前行完整记录' }
)
map(
  'n',
  '<leader>ght',
  function() require('gitsigns').toggle_current_line_blame() end,
  { desc = 'Git/Hunk: 切换当前行记录' }
)

-- Debug / Diagnostics
map('n', '<leader>dd', function() Snacks.picker.diagnostics() end, { desc = 'Debug: 查找工作区诊断' })
map(
  'n',
  '<leader>dD',
  function() Snacks.picker.diagnostics_buffer() end,
  { desc = 'Debug: 查找当前 Buffer 诊断' }
)
map(
  'n',
  '<leader>dt',
  '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
  { desc = 'Debug: 切换当前 Buffer 诊断列表' }
)
map('n', '<leader>dT', '<cmd>Trouble diagnostics toggle<cr>', { desc = 'Debug: 切换工作区诊断列表' })

-- Tools
map(
  'n',
  '<leader>tmk',
  function() require('multicursor-nvim').matchSkipCursor(1) end,
  { desc = 'Tools: 跳过当前多光标匹配项' }
)
map('n', '<leader>tma', function()
  local multicursor = require('multicursor-nvim')
  if multicursor.cursorsEnabled() then
    multicursor.clearCursors()
  else
    multicursor.enableCursors()
  end
end, { desc = 'Tools: 启用或清除所有多光标' })
map(
  'n',
  '<leader>ta',
  function() require('alternate-toggler').toggleAlternate() end,
  { desc = 'Tools: 切换光标处的对应值' }
)
map('n', '<leader>tl', '<cmd>Lazy<cr>', { desc = 'Tools: 打开 Lazy 插件管理器' })
map('n', '<leader>tt', function() Snacks.terminal.toggle() end, { desc = 'Tools: 切换终端' })
map(
  'n',
  '<leader>tb',
  function() require('bookmarks').bookmark_toggle() end,
  { desc = 'Tools: 添加或删除当前行书签' }
)
map(
  'n',
  '<leader>tba',
  function() require('bookmarks').bookmark_ann() end,
  { desc = 'Tools: 编辑当前行书签注释' }
)
map(
  'n',
  '<leader>tbc',
  function() require('bookmarks').bookmark_clean() end,
  { desc = 'Tools: 清除当前 Buffer 的书签' }
)
map(
  'n',
  '<leader>tbC',
  function() require('bookmarks').bookmark_clear_all() end,
  { desc = 'Tools: 清除全部书签' }
)
map('n', '<leader>ts', '<cmd>AutoSession save<cr>', { desc = 'Tools: 保存当前会话' })
map('n', '<leader>tr', '<cmd>AutoSession restore<cr>', { desc = 'Tools: 恢复最近会话' })
map('n', '<leader>tf', '<cmd>AutoSession search<cr>', { desc = 'Tools: 查找并恢复会话' })
map('n', '<leader>td', '<cmd>AutoSession delete<cr>', { desc = 'Tools: 删除会话' })

-- Tools / Crates
map('n', '<leader>tcc', '<cmd>Crates show_crate_popup<cr>', { desc = 'Tools: 查看当前 Crate 信息' })
map('n', '<leader>tcv', '<cmd>Crates show_versions_popup<cr>', { desc = 'Tools: 查看 Crate 版本' })
map('n', '<leader>tcf', '<cmd>Crates show_features_popup<cr>', { desc = 'Tools: 查看 Crate Features' })
map('n', '<leader>tcd', '<cmd>Crates show_dependencies_popup<cr>', { desc = 'Tools: 查看 Crate 依赖' })
map('n', '<leader>tcu', '<cmd>Crates update_crate<cr>', { desc = 'Tools: 更新当前 Crate' })
map('n', '<leader>tcU', '<cmd>Crates update_all_crates<cr>', { desc = 'Tools: 更新全部 Crates' })
map('n', '<leader>tco', '<cmd>Crates open_cratesio<cr>', { desc = 'Tools: 在 crates.io 打开当前 Crate' })

-- Tools / Sidekick
map(
  { 'n', 't', 'i', 'x' },
  '<C-.>',
  function() require('sidekick.cli').focus() end,
  { desc = 'Tools: 聚焦 Sidekick' }
)
map(
  { 'n', 't' },
  '<A-c>',
  function() require('sidekick.cli').toggle({ name = 'codex', focus = true }) end,
  { desc = 'Tools: 切换 Codex CLI' }
)
map('n', '<leader>tko', function() require('sidekick.cli').toggle() end, { desc = 'Tools: 切换 Sidekick CLI' })
map(
  'n',
  '<leader>tks',
  function() require('sidekick.cli').select({ filter = { installed = true } }) end,
  { desc = 'Tools: 选择已安装的 AI CLI' }
)
map(
  { 'n', 'x' },
  '<leader>tkp',
  function() require('sidekick.cli').prompt() end,
  { desc = 'Tools: 选择 Sidekick Prompt' }
)
map(
  'n',
  '<leader>tkf',
  function() require('sidekick.cli').send({ msg = '{file}' }) end,
  { desc = 'Tools: 发送当前文件' }
)
map(
  'x',
  '<leader>tkv',
  function() require('sidekick.cli').send({ msg = '{selection}' }) end,
  { desc = 'Tools: 发送选中内容' }
)
map('n', '<leader>tkd', function() require('sidekick.cli').close() end, { desc = 'Tools: 关闭 Sidekick 会话' })
map(
  'n',
  '<leader>tkC',
  function() require('sidekick.cli').toggle({ name = 'claude', focus = true }) end,
  { desc = 'Tools: 切换 Claude CLI' }
)

-- UI / Toggle
map('n', '<leader>uc', function() Snacks.picker.colorschemes() end, { desc = 'UI: 选择配色方案' })
map('n', '<leader>ua', function() require('noice').cmd('all') end, { desc = 'UI: 查看全部消息' })
map('n', '<leader>ue', function() require('noice').cmd('errors') end, { desc = 'UI: 查看错误消息' })
map('n', '<leader>ul', function() require('noice').cmd('last') end, { desc = 'UI: 查看最近消息' })
map('n', '<leader>un', function()
  require('noice').cmd('dismiss')
  require('notify').dismiss({ pending = true, silent = true })
end, { desc = 'UI: 清除可见消息与通知' })
map('n', '<leader>uz', function() Snacks.zen() end, { desc = 'UI: 切换 Zen 模式' })
map('n', '<leader>uZ', function() Snacks.zen.zoom() end, { desc = 'UI: 切换窗口缩放' })
map('n', '<leader>uf', '<cmd>FormatToggle<cr>', { desc = 'UI: 切换全局自动格式化' })
map('n', '<leader>uF', '<cmd>FormatToggle!<cr>', { desc = 'UI: 切换当前 Buffer 自动格式化' })
map('n', '<leader>um', '<cmd>RenderMarkdown buf_toggle<cr>', { desc = 'UI: 切换 Markdown 渲染' })
map('n', '<leader>uM', '<cmd>RenderMarkdown preview<cr>', { desc = 'UI: 侧边预览 Markdown' })
