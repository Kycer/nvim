---@module 'sidekick'
---@type sidekick.Config
return {
  -- 本机没有 copilot-language-server；先启用不依赖 Copilot 的 AI CLI 功能。
  nes = { enabled = false },
  cli = {
    picker = 'snacks',
    tools = {
      codex = { native_scroll = true },
    },
    win = {
      -- float"|"left"|"bottom"|"top"|"right"
      layout = 'float',
      float = {
        width = 0.9,
        height = 0.9,
      },
      split = { width = 65, height = 20 },
    },
    mux = {
      backend = 'tmux',
      -- "terminal"|"window"|"split"
      create = 'terminal',
      enabled = true,
    },
  },
}
