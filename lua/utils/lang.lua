local M = {}
local cache = {}

function M.load(name)
  if cache[name] then return cache[name] end

  local path = vim.fs.joinpath(vim.fn.stdpath('config'), 'lang', name .. '.lua')
  local chunk, err = loadfile(path)
  if not chunk then error(('无法加载语言配置 %q: %s'):format(name, err)) end

  cache[name] = chunk()
  return cache[name]
end

return M
