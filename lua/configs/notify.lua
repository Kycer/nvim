return {
  stages = 'fade_in_slide_out',
  timeout = 3000,
  render = 'wrapped-compact',
  minimum_width = 40,
  max_width = function() return math.floor(vim.o.columns * 0.4) end,
  max_height = function() return math.floor(vim.o.lines * 0.3) end,
  background_colour = 'NormalFloat',
  top_down = true,
  icons = {
    ERROR = '',
    WARN = '',
    INFO = '',
    DEBUG = '',
    TRACE = '✎',
  },
}
