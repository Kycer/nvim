---@type vim.lsp.Config
return {
  cmd = { 'typescript-language-server', '--stdio' },
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  root_dir = function(bufnr, on_dir)
    local project = require('utils.lang').load('project')
    local deno_root = project.marker_root(bufnr, { 'deno.json', 'deno.jsonc', 'deno.lock' })
    local project_root = project.marker_root(bufnr, {
      'package-lock.json',
      'yarn.lock',
      'pnpm-lock.yaml',
      'bun.lockb',
      'bun.lock',
      'tsconfig.json',
      'jsconfig.json',
      'package.json',
    })

    if deno_root and (not project_root or #deno_root >= #project_root) then return end
    if project_root then on_dir(project_root) end
  end,
  workspace_required = true,
  init_options = {
    hostInfo = 'neovim',
  },
}
