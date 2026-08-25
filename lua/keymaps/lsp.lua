local buf_map = require('utils.keymap').buf_set
local lsp_keymaps_group = vim.api.nvim_create_augroup('nvim_lsp_keymaps', { clear = true })

vim.api.nvim_create_autocmd('LspAttach', {
  group = lsp_keymaps_group,
  callback = function(event)
    if vim.b[event.buf].lsp_keymaps_set then return end

    local function map(mode, lhs, rhs, desc) buf_map(event.buf, mode, lhs, rhs, { desc = desc }) end

    map('n', '<A-r>', vim.lsp.buf.rename, 'Code: 重命名光标处符号')
    map({ 'n', 'x' }, '<A-CR>', vim.lsp.buf.code_action, 'Code: 执行代码操作')
    map('n', 'gd', function() Snacks.picker.lsp_definitions() end, 'Code: 跳转到定义')
    map('n', 'gD', function() Snacks.picker.lsp_declarations() end, 'Code: 跳转到声明')
    map('n', 'gri', function() Snacks.picker.lsp_implementations() end, 'Code: 查找实现')
    map('n', 'grr', function() Snacks.picker.lsp_references() end, 'Code: 查找引用')
    map('n', 'grt', function() Snacks.picker.lsp_type_definitions() end, 'Code: 跳转到类型定义')
    map(
      'n',
      '<C-A-l>',
      function() require('conform').format({ bufnr = event.buf, async = true, lsp_format = 'fallback' }) end,
      'Code: 格式化当前 Buffer'
    )
    map('n', '<leader>ci', function()
      local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf })
      vim.lsp.inlay_hint.enable(not enabled, { bufnr = event.buf })
    end, 'Code: 切换内联提示')
    map('n', '<leader>cs', function() Snacks.picker.lsp_symbols() end, 'Code: 查找当前 Buffer 符号')
    map('n', '<leader>cS', function() Snacks.picker.lsp_workspace_symbols() end, 'Code: 查找工作区符号')

    vim.b[event.buf].lsp_keymaps_set = true
  end,
})
