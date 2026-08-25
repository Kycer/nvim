vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- 退出、关闭修改过的 Buffer 时先确认
vim.o.confirm = true
-- 显示每个窗口的状态栏
vim.o.laststatus = 3
-- 模式已由 Lualine 显示
vim.o.showmode = false
-- 命令行已由 Noice 使用 NUI 弹窗显示
vim.o.cmdheight = 0
-- 开启左侧数字
vim.o.number = true
-- 使用相对数
vim.o.relativenumber = true
-- 高亮当前行
vim.o.cursorline = false
-- 代码文件默认不换行；Markdown、Git commit 等文本文件在 autocmds.lua 中局部开启
vim.o.wrap = false
-- 在最后一行显示一些内容
vim.o.showcmd = true
-- 命令模式显示补全菜单
vim.o.wildmenu = true
-- /搜索时忽略大小写
vim.o.ignorecase = true
-- /搜索时智能大小写
vim.o.smartcase = true
-- 共享系统剪切
vim.o.clipboard = 'unnamedplus'
-- 设置<tab>键
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = true
-- 保持项目工作目录，不随当前文件自动切换
vim.o.autochdir = false
-- 在光标上方和下方保留的最小屏幕行数
vim.o.scrolloff = 4
-- 自动缩进
vim.o.smartindent = true
-- 新分屏默认在当前窗口的下方或右侧
vim.o.splitbelow = true
vim.o.splitright = true
-- 始终保留标记列，避免诊断信息出现时文本移动
vim.o.signcolumn = 'yes'
-- 缩短组合键等待时间
vim.o.timeoutlen = 300
-- 缩短 CursorHold、交换文件写入及部分插件更新的等待时间
vim.o.updatetime = 200
-- 开启鼠标
vim.o.mouse = 'a'
-- 开启颜色
vim.o.termguicolors = true
-- 让全局默认边框变成rounded或single
vim.o.winborder = 'rounded'
-- 始终隐藏字符（不依赖语法高亮）,在 Markdown 文件中，粗体、斜体等标记字符可能会被隐藏
-- vim.opt.conceallevel = 2

-- 设置编码格式
vim.o.fileencodings = 'utf-8,gb2312,gb18030,gbk,ucs-bom,cp936,latin1'
vim.o.enc = 'utf8'

-- 保存修改历史
vim.o.swapfile = false
vim.o.undofile = true
