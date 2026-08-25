local M = {}

local modes = {
  n = { 'NORMAL', 'Normal' },
  no = { 'O-PENDING', 'Normal' },
  nov = { 'O-PENDING', 'Normal' },
  noV = { 'O-PENDING', 'Normal' },
  ['no\22'] = { 'O-PENDING', 'Normal' },
  niI = { 'NORMAL', 'Normal' },
  niR = { 'NORMAL', 'Normal' },
  niV = { 'NORMAL', 'Normal' },
  nt = { 'NORMAL', 'Normal' },
  v = { 'VISUAL', 'Visual' },
  V = { 'V-LINE', 'Visual' },
  ['\22'] = { 'V-BLOCK', 'Visual' },
  s = { 'SELECT', 'Visual' },
  S = { 'S-LINE', 'Visual' },
  ['\19'] = { 'S-BLOCK', 'Visual' },
  i = { 'INSERT', 'Insert' },
  ic = { 'INSERT', 'Insert' },
  ix = { 'INSERT', 'Insert' },
  R = { 'REPLACE', 'Replace' },
  Rc = { 'REPLACE', 'Replace' },
  Rx = { 'REPLACE', 'Replace' },
  Rv = { 'V-REPLACE', 'Replace' },
  Rvc = { 'V-REPLACE', 'Replace' },
  Rvx = { 'V-REPLACE', 'Replace' },
  c = { 'COMMAND', 'Command' },
  cv = { 'EX', 'Command' },
  r = { 'PROMPT', 'Command' },
  rm = { 'MORE', 'Command' },
  ['r?'] = { 'CONFIRM', 'Command' },
  ['!'] = { 'SHELL', 'Command' },
  t = { 'TERMINAL', 'Terminal' },
}

local disabled_filetypes = {
  dashboard = true,
  alpha = true,
  ministarter = true,
  snacks_dashboard = true,
}

local function escape(value)
  local escaped = tostring(value):gsub('%%', '%%%%')
  return escaped
end

local function buffer_for_statusline()
  local win = tonumber(vim.g.statusline_winid)
  if win and vim.api.nvim_win_is_valid(win) then return vim.api.nvim_win_get_buf(win) end
  return vim.api.nvim_get_current_buf()
end

local function mode_component()
  local current = vim.api.nvim_get_mode().mode
  local mode = modes[current] or { current:upper(), 'Normal' }
  return ' ' .. mode[1] .. ' |'
end

local function git_component(buf)
  local status = vim.b[buf].gitsigns_status_dict or {}
  local head = status.head or vim.b[buf].gitsigns_head
  if not head or head == '' then return '' end

  local parts = { ' ', escape(head) }
  if (status.added or 0) > 0 then parts[#parts + 1] = (' +%d'):format(status.added) end
  if (status.changed or 0) > 0 then parts[#parts + 1] = (' ~%d'):format(status.changed) end
  if (status.removed or 0) > 0 then parts[#parts + 1] = (' -%d'):format(status.removed) end
  parts[#parts + 1] = ' |'
  return table.concat(parts)
end

local function diagnostics_component(buf)
  local counts = vim.diagnostic.count(buf)
  local severity = vim.diagnostic.severity
  local parts = {}
  if (counts[severity.ERROR] or 0) > 0 then parts[#parts + 1] = (' E:%d'):format(counts[severity.ERROR]) end
  if (counts[severity.WARN] or 0) > 0 then parts[#parts + 1] = (' W:%d'):format(counts[severity.WARN]) end
  if (counts[severity.INFO] or 0) > 0 then parts[#parts + 1] = (' I:%d'):format(counts[severity.INFO]) end
  if (counts[severity.HINT] or 0) > 0 then parts[#parts + 1] = (' H:%d'):format(counts[severity.HINT]) end
  if #parts > 0 then parts[#parts + 1] = ' |' end
  return table.concat(parts)
end

local function filename_component(buf)
  local name = vim.api.nvim_buf_get_name(buf)
  local filename = name == '' and '[No Name]' or vim.fn.fnamemodify(name, ':.')
  return ' %<' .. escape(filename) .. ' %m%r'
end

local function filesize_component(buf)
  local name = vim.api.nvim_buf_get_name(buf)
  if name == '' then return '' end
  local size = vim.fn.getfsize(name)
  if size < 0 then return '' end
  if size < 1024 then return (' %dB'):format(size) end
  if size < 1024 * 1024 then return (' %.1fK'):format(size / 1024) end
  if size < 1024 * 1024 * 1024 then return (' %.1fM'):format(size / 1024 / 1024) end
  return (' %.1fG'):format(size / 1024 / 1024 / 1024)
end

local function file_component(buf)
  local formats = { unix = 'LF', dos = 'CRLF', mac = 'CR' }
  local format = formats[vim.bo[buf].fileformat] or vim.bo[buf].fileformat
  local encoding = vim.bo[buf].fileencoding ~= '' and vim.bo[buf].fileencoding or vim.o.encoding
  local filetype = vim.bo[buf].filetype ~= '' and vim.bo[buf].filetype or 'text'
  return (' | %s | %s | %s'):format(format, encoding:upper(), escape(filetype))
end

local function lsp_component(buf)
  local names = {}
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf })) do
    if not client:is_stopped() then names[#names + 1] = client.name end
  end
  if #names == 0 then return '' end
  table.sort(names)
  return ' | ' .. escape(table.concat(names, ','))
end

function M.render()
  local buf = buffer_for_statusline()
  if disabled_filetypes[vim.bo[buf].filetype] then return '' end
  return table.concat({
    mode_component(),
    git_component(buf),
    diagnostics_component(buf),
    filename_component(buf),
    '%=',
    filesize_component(buf),
    file_component(buf),
    lsp_component(buf),
    ' | %p%% | %l:%c ',
  })
end

function M.setup() vim.o.statusline = "%!v:lua.require('configs.statusline').render()" end

return M
