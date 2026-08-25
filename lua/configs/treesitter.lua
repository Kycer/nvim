local treesitter = require('nvim-treesitter')

local parsers = {
  'bash',
  'css',
  'go',
  'html',
  'javascript',
  'json',
  'json5',
  'lua',
  'luadoc',
  'markdown',
  'markdown_inline',
  'python',
  'regex',
  'rust',
  'toml',
  'tsx',
  'typescript',
  'vim',
  'vimdoc',
  'yaml',
}

vim.treesitter.language.register('bash', { 'sh', 'zsh' })
vim.treesitter.language.register('javascript', 'javascriptreact')
vim.treesitter.language.register('json', 'jsonc')
vim.treesitter.language.register('tsx', 'typescriptreact')

-- Parsers are installed globally for the current user in Neovim's default
-- data directory. Already installed parsers are skipped.
treesitter.install(parsers)

local group = vim.api.nvim_create_augroup('nvim_treesitter', { clear = true })

local function start_highlight(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_buf_is_loaded(bufnr) then return end
  if vim.bo[bufnr].buftype ~= '' then return end

  -- AutoSession 在 VimEnter 中恢复的 Buffer 可能错过文件类型检测。
  if vim.bo[bufnr].filetype == '' then
    local filetype = vim.filetype.match({ buf = bufnr })
    if filetype then vim.bo[bufnr].filetype = filetype end
  end

  local language = vim.treesitter.language.get_lang(vim.bo[bufnr].filetype)
  if language then pcall(vim.treesitter.start, bufnr, language) end
end

vim.api.nvim_create_autocmd('FileType', {
  group = group,
  callback = function(event) start_highlight(event.buf) end,
})

vim.api.nvim_create_autocmd('SessionLoadPost', {
  group = group,
  nested = true,
  callback = function()
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      start_highlight(bufnr)
    end
  end,
})
