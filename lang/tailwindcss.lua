---@type vim.lsp.Config
return {
  cmd = { 'tailwindcss-language-server', '--stdio' },
  filetypes = {
    'astro',
    'css',
    'html',
    'htmlangular',
    'javascript',
    'javascriptreact',
    'less',
    'markdown',
    'mdx',
    'postcss',
    'sass',
    'scss',
    'svelte',
    'templ',
    'typescript',
    'typescriptreact',
    'vue',
  },
  root_dir = function(bufnr, on_dir)
    local project = require('utils.lang').load('project')
    local config_root = project.marker_root(bufnr, {
      'tailwind.config.js',
      'tailwind.config.cjs',
      'tailwind.config.mjs',
      'tailwind.config.ts',
      'postcss.config.js',
      'postcss.config.cjs',
      'postcss.config.mjs',
      'postcss.config.ts',
    })
    local package_root = project.package_root(bufnr, {
      '@tailwindcss/cli',
      '@tailwindcss/postcss',
      '@tailwindcss/vite',
      'tailwindcss',
    })
    local root = project.nearest(config_root, package_root)

    if root then on_dir(root) end
  end,
  workspace_required = true,
  settings = {
    tailwindCSS = {
      classAttributes = { 'class', 'className', 'class:list', 'classList', 'ngClass' },
      includeLanguages = {
        htmlangular = 'html',
        templ = 'html',
      },
      validate = true,
    },
  },
}
