---@module 'crates'
---@type crates.UserConfig
return {
  popup = {
    autofocus = true,
  },
  completion = {
    insert_closing_quote = true,
    blink = {
      use_custom_kind = true,
      kind_text = {
        version = 'Version',
        feature = 'Feature',
      },
      kind_icon = {
        version = ' ',
        feature = ' ',
      },
    },
    crates = {
      enabled = true,
      min_chars = 3,
      max_results = 8,
    },
  },
  lsp = {
    enabled = true,
    name = 'crates.nvim',
    actions = true,
    completion = true,
    hover = true,
  },
}
