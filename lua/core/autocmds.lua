local function augroup(name) return vim.api.nvim_create_augroup('nvim_' .. name, { clear = true }) end

-- 打开实际文件时再初始化原生 LSP；Dashboard 启动无需加载 LSP 和补全模块。
vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
  group = augroup('lazy_lsp'),
  once = true,
  callback = function() require('configs.lsp') end,
})

-- 内容恢复到最近一次读取或保存的状态时，自动清除 modified 标记。
-- 只在退出 Insert 或普通模式修改后比较，并跳过大文件，避免每次输入都计算摘要。
local max_content_hash_size = 5 * 1024 * 1024

local function content_hash(buf)
  if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_buf_is_loaded(buf) or vim.bo[buf].buftype ~= '' then
    return
  end
  local size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
  if size < 0 or size > max_content_hash_size then return end

  local content = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), '\n')
  if vim.bo[buf].endofline then content = content .. '\n' end
  return vim.fn.sha256(content)
end

vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufWritePost' }, {
  group = augroup('remember_saved_content'),
  callback = function(event) vim.b[event.buf].nvim_saved_content_hash = content_hash(event.buf) end,
})

vim.api.nvim_create_autocmd({ 'TextChanged', 'InsertLeave' }, {
  group = augroup('restore_unmodified'),
  callback = function(event)
    if not vim.bo[event.buf].modified then return end
    local saved_hash = vim.b[event.buf].nvim_saved_content_hash
    if saved_hash and content_hash(event.buf) == saved_hash then vim.bo[event.buf].modified = false end
  end,
})

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  group = augroup('checktime'),
  callback = function()
    if vim.o.buftype ~= 'nofile' then vim.cmd('checktime') end
  end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  group = augroup('highlight_yank'),
  callback = function() (vim.hl or vim.highlight).on_yank() end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ 'VimResized' }, {
  group = augroup('resize_splits'),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd('tabdo wincmd =')
    vim.cmd('tabnext ' .. current_tab)
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd('FileType', {
  group = augroup('close_with_q'),
  pattern = {
    'PlenaryTestPopup',
    'checkhealth',
    'dbout',
    'gitsigns-blame',
    'grug-far',
    'help',
    'lspinfo',
    'neotest-output',
    'neotest-output-panel',
    'neotest-summary',
    'notify',
    'qf',
    'snacks_win',
    'spectre_panel',
    'startuptime',
    'tsplayground',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set('n', 'q', function()
        vim.cmd('close')
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = 'Quit buffer',
      })
    end)
  end,
})

-- make it easier to close man-files when opened inline
vim.api.nvim_create_autocmd('FileType', {
  group = augroup('man_unlisted'),
  pattern = { 'man' },
  callback = function(event) vim.bo[event.buf].buflisted = false end,
})

-- 保存新文件时自动创建不存在的父目录
vim.api.nvim_create_autocmd('BufWritePre', {
  group = augroup('auto_create_dir'),
  callback = function(event)
    if vim.bo[event.buf].buftype ~= '' or event.match:match('^%w%w+://') then return end

    local parent = vim.fs.dirname(vim.api.nvim_buf_get_name(event.buf))
    if parent and parent ~= '' then vim.fn.mkdir(parent, 'p') end
  end,
})

vim.api.nvim_create_autocmd('BufEnter', {
  group = augroup('format_on_enter'),
  pattern = '*',
  command = 'set formatoptions-=cro',
})

-- 只在自然语言文本中折行并检查拼写，避免影响代码文件
vim.api.nvim_create_autocmd('FileType', {
  group = augroup('text_editing'),
  pattern = { 'markdown', 'gitcommit', 'gitrebase' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.spell = true
    vim.opt_local.spelllang = { 'en_us', 'cjk' }
  end,
})
