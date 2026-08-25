local capabilities = vim.lsp.protocol.make_client_capabilities()

-- Neovim 0.12 已原生声明绝大多数补全能力；补齐 Blink 使用的字段，
-- 避免仅为生成 capabilities 就在打开文件时提前加载整个 blink.cmp。
capabilities = vim.tbl_deep_extend('force', capabilities, {
  textDocument = {
    completion = {
      completionItem = {
        resolveSupport = {
          properties = { 'documentation', 'detail', 'additionalTextEdits', 'command', 'data' },
        },
        insertTextModeSupport = { valueSet = { 1 } },
      },
      completionList = {
        itemDefaults = { 'commitCharacters', 'editRange', 'insertTextFormat', 'insertTextMode', 'data' },
      },
      insertTextMode = 1,
    },
  },
})

capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

vim.lsp.config('*', {
  capabilities = capabilities,
})

vim.diagnostic.config({
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = ' ',
      [vim.diagnostic.severity.WARN] = ' ',
      [vim.diagnostic.severity.INFO] = ' ',
      [vim.diagnostic.severity.HINT] = ' ',
    },
  },
  underline = true,
  update_in_insert = false,
  virtual_text = {
    source = 'if_many',
    spacing = 4,
  },
  float = {
    border = 'rounded',
    source = true,
  },
})

local lsp_group = vim.api.nvim_create_augroup('nvim_lsp_features', { clear = true })

vim.api.nvim_create_autocmd('LspAttach', {
  group = lsp_group,
  callback = function(event)
    local client = assert(vim.lsp.get_client_by_id(event.data.client_id))
    if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
      vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
    end
  end,
})

local servers = {
  'lua_ls',
  'jsonls',
  'bashls',
  'rust_analyzer',
  'gopls',
  -- 'pyright',
  -- 'marksman',
  'taplo',
  -- 'ts_ls',
  -- 'cssmodules_ls',
  -- 'tailwindcss',
  -- 'emmet_language_server',
}

local lang = require('utils.lang')

for _, server in ipairs(servers) do
  vim.lsp.config(server, lang.load(server))
end

vim.lsp.enable(servers)
