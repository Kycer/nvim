return {
    {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        opts = {
            -- 在写markdown时禁用括号补全
            disable_filetype = { 'markdown' },
            --  can use treesitter to check for a pair.
            check_ts = true,
        },
    },
    {
        'folke/snacks.nvim',
        priority = 1000,
        lazy = false,
        opts = require('configs.snacks'),
    },
    -- symbol line 大纲
    {
        'stevearc/aerial.nvim',
        cmd = { 'AerialToggle', 'AerialOpen', 'AerialNavToggle' },
        opts = {},
        -- Optional dependencies
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        },
    },
    -- gitsigns
    {
        'lewis6991/gitsigns.nvim',
        event = { 'BufReadPre', 'BufNewFile' },
        opts = require('configs.gitsigns'),
    },
    -- trouble
    {
        'folke/trouble.nvim',
        cmd = 'Trouble',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {},
    },
    {
        'folke/which-key.nvim',
        event = 'VimEnter',
        opts = require('configs.which-key'),
    },
    -- true false 反转
    {
        'rmagatti/alternate-toggler',
        lazy = true,
        config = function() require('configs.alternate') end,
    },
    --
    {
        'tomasky/bookmarks.nvim',
        event = { 'BufReadPost', 'BufNewFile' },
        config = function() require('configs.bookmarks') end,
    },
    -- 多光标插件
    {
        'jake-stewart/multicursor.nvim',
        lazy = true,
        opts = {},
    },
    -- flash
    {
        'folke/flash.nvim',
        lazy = true,
        opts = {
            label = {
                uppercase = false,
            },
        },
    },
    -- session
    {
        'rmagatti/auto-session',
        lazy = false,
        opts = {
            suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
            auto_restore_last_session = false,
            -- log_level = 'debug',
        },
    },
    {
        'MagicDuck/grug-far.nvim',
        cmd = 'GrugFar',
        opts = {},
    },
    {
        'saecki/crates.nvim',
        tag = 'stable',
        event = 'BufRead Cargo.toml',
        cmd = 'Crates',
        opts = require('configs.crates'),
    },
    {
        'MeanderingProgrammer/render-markdown.nvim',
        ft = 'markdown',
        cmd = 'RenderMarkdown',
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'nvim-tree/nvim-web-devicons',
        },
        opts = require('configs.render-markdown'),
    },
    {
        'folke/sidekick.nvim',
        cmd = 'Sidekick',
        opts = require('configs.sidekick'),
    },
}
