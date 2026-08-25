---@type vim.lsp.Config
return {
  cmd = { 'rust-analyzer' },
  filetypes = { 'rust' },
  root_markers = { 'Cargo.toml', 'rust-project.json', '.git' },
  settings = {
    ['rust-analyzer'] = {
      imports = {
        granularity = { group = 'module' },
        prefix = 'self',
      },
      cargo = {
        allFeatures = true,
        loadOutDirsFromCheck = true,
        runBuildScripts = true,
      },
      check = {
        command = 'clippy',
        extraArgs = { '--no-deps' },
      },
      procMacro = { enable = true },
      inlayHints = {
        enable = true,
        showParameterNames = true,
        parameterHintsPrefix = '<- ',
        otherHintsPrefix = '=> ',
      },
    },
  },
}
