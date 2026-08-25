---@module 'gitsigns'
---@type Gitsigns.Config
return {
  current_line_blame = true,
  current_line_blame_opts = {
    delay = 400,
    use_focus = true,
    virt_text = true,
    virt_text_pos = 'eol',
    virt_text_priority = 100,
  },
  current_line_blame_formatter = '  <author>, <author_time:%Y-%m-%d> • <summary>',
  preview_config = {
    border = 'rounded',
  },
}
