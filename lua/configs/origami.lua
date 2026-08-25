return {
  useLspFoldsWithTreesitterFallback = {
    enabled = true,
    foldmethodIfNeitherIsAvailable = 'indent',
  },
  pauseFoldsOnSearch = true,
  foldtext = {
    enabled = true,
    padding = {
      character = ' ',
      width = 3,
    },
    lineCount = {
      template = '󰁂 %d lines',
      hlgroup = 'Comment',
    },
    diagnosticsCount = true,
    gitsignsCount = true,
    disableOnFt = { 'snacks_picker_input' },
  },
  autoFold = {
    enabled = false,
  },
  foldKeymaps = {
    setup = false,
  },
}
