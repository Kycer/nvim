return {
  cmdline = {
    enabled = true,
    view = 'cmdline_popup',
  },
  messages = {
    enabled = true,
    view = 'notify',
    view_error = 'notify',
    view_warn = 'notify',
    view_history = 'messages',
    view_search = 'virtualtext',
  },
  popupmenu = {
    enabled = true,
    backend = 'nui',
  },
  notify = {
    enabled = true,
    view = 'notify',
  },
  lsp = {
    progress = { enabled = false },
    hover = { enabled = false },
    signature = { enabled = false },
    message = { enabled = false },
  },
  presets = {
    bottom_search = false,
    command_palette = true,
    long_message_to_split = true,
    inc_rename = false,
    lsp_doc_border = false,
  },
}
