---@module 'sidekick'
---@type sidekick.Config
return {
  -- 本机没有 copilot-language-server；先启用不依赖 Copilot 的 AI CLI 功能。
  nes = { enabled = false },
  cli = {
    picker = 'snacks',
    win = {
      layout = 'right',
      split = { width = 65, height = 20 },
    },
    mux = {
      -- backend = 'zellij',
      enabled = false,
    },
  },
}
