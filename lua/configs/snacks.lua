-- Project detection ----------------------------------------------------------

-- Keep this list in sync with the Snacks projects picker so that opening an
-- explorer and discovering projects use the same definition of a project.
local project_markers = {
  '.git',
  '_darcs',
  '.hg',
  '.bzr',
  '.svn',
  'package.json',
  'Makefile',
  'Cargo.toml',
}

local function find_project_root(path)
  path = path or vim.uv.cwd() or vim.fn.getcwd()
  local stat = vim.uv.fs_stat(path)
  local start = stat and stat.type == 'directory' and path or vim.fs.dirname(path)
  return start and vim.fs.root(start, project_markers) or nil
end

-- Explorer actions ----------------------------------------------------------

local function selected_explorer_paths(picker)
  if vim.fn.mode():find('^[vV]') then picker.list:select() end

  local paths = {}
  for _, item in ipairs(picker:selected({ fallback = true })) do
    local path = Snacks.picker.util.path(item)
    if path then paths[#paths + 1] = vim.fs.normalize(path) end
  end
  picker.list:set_selected()
  return paths
end

local function copy_explorer_paths(format, label)
  return function(picker)
    local values = vim.tbl_map(format, selected_explorer_paths(picker))
    if #values == 0 then return end

    local value = table.concat(values, '\n')
    vim.fn.setreg('"', value, 'l')
    vim.fn.setreg('+', value, 'l')
    Snacks.notify.info(('已复制%s（%d 项）'):format(label, #values), { title = 'Snacks Explorer' })
  end
end

local copy_absolute_path = copy_explorer_paths(function(path) return path end, '绝对路径')

local copy_project_path = copy_explorer_paths(function(path)
  local root = find_project_root(path)
  return root and vim.fs.relpath(root, path) or path
end, '项目相对路径')

local copy_filename = copy_explorer_paths(function(path) return vim.fs.basename(path) end, '文件名')

local copy_parent_path = copy_explorer_paths(function(path) return vim.fs.dirname(path) end, '父目录路径')

local function sidekick_send(picker)
  local ok, integration = pcall(require, 'sidekick.cli.picker.snacks')
  if not ok then
    Snacks.notify.error('Sidekick 未安装或加载失败', { title = 'Snacks Explorer' })
    return
  end

  -- Sidekick's Snacks action closes the picker before sending. Temporarily
  -- suppress that close so Explorer and its buffer stay open.
  local close = rawget(picker, 'close')
  picker.close = function() end
  local sent, err = pcall(integration.send, picker)
  picker.close = close
  if not sent then Snacks.notify.error(err, { title = 'Snacks Explorer' }) end
end

-- Bigfile -------------------------------------------------------------------

local bigfile = { enabled = true }

-- Dashboard -----------------------------------------------------------------

local dashboard = {
  enabled = true,
  width = 60,
  row = nil, -- dashboard position. nil for center
  col = nil, -- dashboard position. nil for center
  pane_gap = 4, -- empty columns between vertical panes
  autokeys = '1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', -- autokey sequence
  -- These settings are used by some built-in sections
  preset = {
    -- Defaults to a picker that supports `fzf-lua`, `telescope.nvim` and `mini.pick`
    ---@type fun(cmd:string, opts:table)|nil
    pick = nil,
    -- Used by the `keys` section to show keymaps.
    -- Set your custom keymaps here.
    -- When using a function, the `items` argument are the default keymaps.
    ---@type snacks.dashboard.Item[]
    keys = {
      { icon = ' ', key = 'f', desc = 'Find File', action = ":lua Snacks.dashboard.pick('files')" },
      { icon = ' ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
      { icon = ' ', key = 'g', desc = 'Find Text', action = ":lua Snacks.dashboard.pick('live_grep')" },
      { icon = ' ', key = 'r', desc = 'Recent Files', action = ":lua Snacks.dashboard.pick('oldfiles')" },
      {
        icon = ' ',
        key = 'c',
        desc = 'Config',
        action = function()
          local config_dir = vim.fn.stdpath('config')
          vim.api.nvim_set_current_dir(config_dir)
          Snacks.dashboard.pick('files', { cwd = config_dir })
        end,
      },
      {
        icon = ' ',
        key = 's',
        desc = 'Restore Session',
        action = ':AutoSession search',
      },
      { icon = '󰒲 ', key = 'l', desc = 'Lazy', action = ':Lazy', enabled = package.loaded.lazy ~= nil },
      { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
    },
    -- Used by the `header` section
    header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
  },
  -- item field formatters
  formats = {
    icon = function(item)
      if item.file and item.icon == 'file' or item.icon == 'directory' then
        return Snacks.dashboard.icon(item.file, item.icon)
      end
      return { item.icon, width = 2, hl = 'icon' }
    end,
    footer = { '%s', align = 'center' },
    header = { '%s', align = 'center' },
    file = function(item, ctx)
      local fname = vim.fn.fnamemodify(item.file, ':~')
      fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
      if #fname > ctx.width then
        local dir = vim.fn.fnamemodify(fname, ':h')
        local file = vim.fn.fnamemodify(fname, ':t')
        if dir and file then
          file = file:sub(-(ctx.width - #dir - 2))
          fname = dir .. '/…' .. file
        end
      end
      local dir, file = fname:match('^(.*)/(.+)$')
      return dir and { { dir .. '/', hl = 'dir' }, { file, hl = 'file' } } or { { fname, hl = 'file' } }
    end,
  },
  sections = {
    { section = 'header' },
    { section = 'keys', gap = 1, padding = 1 },
    { section = 'startup' },
  },
}

-- Explorer ------------------------------------------------------------------

local explorer = {
  enabled = true,
  replace_netrw = true,
  trash = true,
}

-- Indent --------------------------------------------------------------------

local indent = {
  enabled = true,
  indent = {
    char = '│',
    only_scope = false,
    only_current = false,
  },
  scope = {
    enabled = true,
    char = '│',
    only_current = false,
  },
}

-- Input ---------------------------------------------------------------------

local input = { enabled = true }

-- Picker --------------------------------------------------------------------

local picker = {
  enabled = true,
  -- 打开 Picker 后先聚焦结果列表并保持 Normal 模式；按 i 开始输入。
  focus = 'list',
  actions = {
    copy_absolute_path = { action = copy_absolute_path, desc = '复制绝对路径' },
    copy_project_path = { action = copy_project_path, desc = '复制项目相对路径' },
    copy_filename = { action = copy_filename, desc = '复制文件名' },
    copy_parent_path = { action = copy_parent_path, desc = '复制父目录路径' },
    sidekick_send = { action = sidekick_send, desc = '发送到 Sidekick' },
  },
  sources = {
    projects = {
      patterns = project_markers,
    },
    explorer = {
      -- 打开 Explorer 时定位当前文件，并在切换 Buffer 后自动跟随。
      follow_file = true,
      auto_close = false,
      ignored = true,
      exclude = { '.git' },
      focus = 'list',
      layout = { preset = 'sidebar', preview = false },
      config = function(opts)
        opts.hidden = find_project_root(opts.cwd) ~= nil
        -- Defining a source config replaces Snacks' built-in one, so preserve
        -- its Explorer-specific setup explicitly.
        return require('snacks.picker.source.explorer').setup(opts)
      end,
      win = {
        list = {
          keys = {
            ['<CR>'] = 'confirm',
            ['<BS>'] = 'explorer_up',
            ['l'] = 'confirm',
            ['h'] = 'explorer_close',
            ['a'] = 'explorer_add',
            ['r'] = 'explorer_rename',
            ['d'] = 'explorer_del',
            ['c'] = 'explorer_copy',
            ['m'] = 'explorer_move',
            ['y'] = { 'explorer_yank', mode = { 'n', 'x' } },
            ['p'] = 'explorer_paste',
            ['u'] = 'explorer_update',
            ['o'] = 'explorer_open',
            ['<C-s>'] = 'edit_split',
            ['<C-v>'] = 'edit_vsplit',
            ['<C-t>'] = 'tab',
            ['gyp'] = { 'copy_absolute_path', mode = { 'n', 'x' } },
            ['gyr'] = { 'copy_project_path', mode = { 'n', 'x' } },
            ['gyn'] = { 'copy_filename', mode = { 'n', 'x' } },
            ['gyd'] = { 'copy_parent_path', mode = { 'n', 'x' } },
            ['<A-a>'] = { 'sidekick_send', mode = { 'n', 'x' } },
            ['H'] = 'toggle_hidden',
            ['I'] = 'toggle_ignored',
            ['P'] = 'toggle_preview',
            ['?'] = 'toggle_help_list',
            ['q'] = 'close',
          },
        },
      },
    },
  },
}

-- Notifier ------------------------------------------------------------------

-- 通知统一交给 Noice 和 nvim-notify，避免多个后端同时接管 vim.notify。
local notifier = { enabled = false }

-- Quickfile -----------------------------------------------------------------

local quickfile = { enabled = true }

-- Scope ---------------------------------------------------------------------

local scope = { enabled = true }

-- Scroll --------------------------------------------------------------------

local scroll = { enabled = false }

-- Statuscolumn --------------------------------------------------------------

local statuscolumn = { enabled = false }

-- Words ---------------------------------------------------------------------

local words = { enabled = true }

-- Terminal ------------------------------------------------------------------

local terminal = {
  enabled = true,
  win = { height = 0.35 },
}

return {
  bigfile = bigfile,
  dashboard = dashboard,
  explorer = explorer,
  indent = indent,
  input = input,
  picker = picker,
  notifier = notifier,
  quickfile = quickfile,
  scope = scope,
  scroll = scroll,
  statuscolumn = statuscolumn,
  words = words,
  terminal = terminal,
}
