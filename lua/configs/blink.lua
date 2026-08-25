---@module 'blink.cmp'
---@type blink.cmp.Config
return {
  keymap = {
    preset = 'none',
    ['<A-m>'] = { 'show', 'show_documentation', 'hide_documentation' },
    ['<CR>'] = { 'accept', 'fallback' },
    ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
    ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
    ['<C-n>'] = { 'select_next', 'fallback_to_mappings' },
    ['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
    ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
    ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
    ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
  },
  completion = {
    keyword = { range = 'full' },
    list = {
      selection = {
        preselect = false,
        auto_insert = true,
      },
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 500,
    },
    menu = {
      draw = {
        treesitter = { 'lsp' },
        columns = {
          { 'source_name', 'kind_icon', 'label', 'label_description', gap = 1 },
          { 'kind' },
        },
      },
    },
  },
  signature = {
    enabled = true,
  },
  snippets = {
    preset = 'default',
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
    per_filetype = {
      lua = { inherit_defaults = true, 'lazydev' },
    },
    providers = {
      lazydev = {
        name = 'LazyDev',
        module = 'lazydev.integrations.blink',
        score_offset = 100,
      },
      lsp = { score_offset = 4 },
      path = { score_offset = 3 },
      snippets = { score_offset = 2 },
      buffer = { score_offset = 1 },
    },
  },
  cmdline = {
    keymap = { preset = 'cmdline' },
    -- 当前 Blink main 的 mode config 通过完整 SourceConfig schema 校验，
    -- 因此动态 source 列表需要放在 sources.default 中。
    sources = {
      default = function()
        local cmd_type = vim.fn.getcmdtype()
        if cmd_type == '/' or cmd_type == '?' then return { 'buffer' } end
        if cmd_type == ':' or cmd_type == '@' then return { 'cmdline', 'buffer' } end
        return {}
      end,
    },
    completion = {
      menu = {
        auto_show = function() return vim.fn.getcmdtype() == ':' end,
      },
      ghost_text = { enabled = true },
    },
  },
  appearance = {
    nerd_font_variant = 'mono',
  },
  fuzzy = {
    implementation = 'prefer_rust_with_warning',
  },
}
