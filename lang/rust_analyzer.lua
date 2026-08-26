---@type vim.lsp.Config
return {
  cmd = { 'rust-analyzer' },
  filetypes = { 'rust' },
  -- 优先复用仓库级 client，避免 workspace 内每个 crate 启动一个 rust-analyzer。
  root_markers = { 'rust-project.json', '.git', 'Cargo.toml' },
  settings = {
    ['rust-analyzer'] = {
      imports = {
        granularity = { group = 'module' },
        prefix = 'self',
      },
      cargo = {
        buildScripts = { enable = true },
      },
      check = {
        command = 'clippy',
        extraArgs = { '--no-deps' },
        workspace = false,
      },
      procMacro = { enable = true },
      completion = {
        fullFunctionSignatures = { enable = true },
      },
      inlayHints = {
        parameterHints = { enable = true },
        typeHints = { enable = true },
        chainingHints = { enable = true },
        closureReturnTypeHints = { enable = 'with_block' },
        lifetimeElisionHints = {
          enable = 'skip_trivial',
          useParameterNames = true,
        },
        maxLength = 40,
      },
    },
  },
}
