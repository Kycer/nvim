local status, conform = pcall(require, 'conform')
if not status then
  vim.notify('not found conform')
  return
end
conform.setup({
  formatters_by_ft = {
    lua = { 'stylua' },
    javascript = { 'prettierd' },
    typescript = { 'prettierd' },
    javascriptreact = { 'prettierd' },
    typescriptreact = { 'prettierd' },
    css = { 'prettierd' },
    json = { 'prettierd' },
    html = { 'prettierd' },
    yaml = { 'prettierd' },
    toml = { 'taplo' },
    markdown = { 'prettierd' },
    rust = { 'rustfmt' },
    kdl = { 'kdlfmt' },
    sh = { 'shfmt' },
  },
  format_on_save = function(bufnr)
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end
    return {
      timeout_ms = 500,
      lsp_format = 'fallback',
    }
  end,
})

vim.api.nvim_create_user_command('FormatToggle', function(args)
  if args.bang then
    vim.b.disable_autoformat = not vim.b.disable_autoformat
    vim.notify(
      ('当前 Buffer 自动格式化：%s'):format(vim.b.disable_autoformat and '关闭' or '开启'),
      vim.log.levels.INFO,
      { title = 'Conform' }
    )
    return
  end

  vim.g.disable_autoformat = not vim.g.disable_autoformat
  vim.notify(
    ('全局自动格式化：%s'):format(vim.g.disable_autoformat and '关闭' or '开启'),
    vim.log.levels.INFO,
    { title = 'Conform' }
  )
end, { bang = true, desc = '切换自动保存格式化；使用 ! 仅切换当前 Buffer' })
