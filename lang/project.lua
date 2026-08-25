local M = {}

local function buffer_path(bufnr)
  local path = vim.api.nvim_buf_get_name(bufnr)
  return path ~= '' and path or vim.fn.getcwd()
end

function M.marker_root(bufnr, markers)
  local git_root = vim.fs.root(bufnr, '.git')
  local marker = vim.fs.find(markers, {
    path = buffer_path(bufnr),
    stop = git_root and vim.fs.dirname(git_root) or nil,
    upward = true,
    type = 'file',
  })[1]

  return marker and vim.fs.dirname(marker) or nil
end

function M.package_root(bufnr, package_names)
  local git_root = vim.fs.root(bufnr, '.git')
  local wanted = {}
  for _, name in ipairs(package_names) do
    wanted[name] = true
  end

  local manifests = vim.fs.find('package.json', {
    path = buffer_path(bufnr),
    stop = git_root and vim.fs.dirname(git_root) or nil,
    upward = true,
    limit = math.huge,
    type = 'file',
  })

  for _, manifest in ipairs(manifests) do
    local read_ok, lines = pcall(vim.fn.readfile, manifest)
    if read_ok then
      local decode_ok, package = pcall(vim.json.decode, table.concat(lines, '\n'))
      if decode_ok and type(package) == 'table' then
        for _, field in ipairs({ 'dependencies', 'devDependencies', 'peerDependencies', 'optionalDependencies' }) do
          for name in pairs(package[field] or {}) do
            if wanted[name] then return vim.fs.dirname(manifest) end
          end
        end
      end
    end
  end
end

function M.nearest(...)
  local nearest
  for _, root in ipairs({ ... }) do
    if root and (not nearest or #root > #nearest) then nearest = root end
  end
  return nearest
end

return M
