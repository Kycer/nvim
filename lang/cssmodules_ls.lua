---@type vim.lsp.Config
return {
  cmd = { 'cssmodules-language-server' },
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  root_dir = function(bufnr, on_dir)
    local project = require('utils.lang').load('project')
    local root = project.package_root(bufnr, {
      '@angular/core',
      'next',
      'postcss-modules',
      'react',
      'svelte',
      'typed-css-modules',
      'vite',
      'vue',
      'webpack',
    })

    if root then on_dir(root) end
  end,
  workspace_required = true,
}
