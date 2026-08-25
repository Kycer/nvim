local M = {}

local default_opts = {
  noremap = true,
  silent = true,
}

---@param mode string|string[]
---@param lhs string|string[]
---@param rhs string|function
---@param opts? vim.keymap.set.Opts
function M.set(mode, lhs, rhs, opts)
  opts = vim.tbl_extend('force', default_opts, opts or {})

  vim.keymap.set(mode, lhs, rhs, opts)
end

---@param bufnr integer
---@param mode string|string[]
---@param lhs string|string[]
---@param rhs string|function
---@param opts? vim.keymap.set.Opts
function M.buf_set(bufnr, mode, lhs, rhs, opts)
  opts = vim.tbl_extend('force', opts or {}, {
    buffer = bufnr,
  })

  M.set(mode, lhs, rhs, opts)
end

---@param mode string|string[]
---@param lhs string|string[]
---@param opts? vim.keymap.del.Opts
function M.del(mode, lhs, opts) vim.keymap.del(mode, lhs, opts) end

---@param bufnr integer
---@param mode string|string[]
---@param lhs string|string[]
function M.buf_del(bufnr, mode, lhs)
  M.del(mode, lhs, {
    buffer = bufnr,
  })
end

return M
