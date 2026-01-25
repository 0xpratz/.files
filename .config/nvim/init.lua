-- LEADER KEYS (must be set before lazy)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- DISPLAY SETTINGS
vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.signcolumn = "yes"
vim.o.scrolloff = 10
vim.o.termguicolors = true
vim.o.list = true
vim.o.listchars = "tab:» ,lead:·,trail:·"
vim.o.inccommand = "split"
vim.o.wrap = false
vim.o.winborder = "rounded"
vim.opt.colorcolumn = "80"

-- EDITING BEHAVIOR
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldcolumn = "1"
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.breakindent = true
vim.o.mouse = "a"
vim.o.timeoutlen = 600
vim.o.updatetime = 250

-- SEARCH SETTINGS
vim.o.ignorecase = true
vim.o.smartcase = true

-- WINDOW BEHAVIOR
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.confirm = true

-- FILE HANDLING
vim.o.swapfile = false
vim.o.undofile = true

-- Disable netrw
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrw = 1

-- Set clipboard asynchronously
vim.schedule(function()
    vim.o.clipboard = "unnamedplus"
end)

-- BOOTSTRAP LAZY.NVIM
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- PLUGINS
require("lazy").setup({
    -- Dependencies
    { "nvim-tree/nvim-web-devicons" },
    { "nvim-lua/plenary.nvim" },

    -- LSP Progress
    {
        "j-hui/fidget.nvim",
        config = function()
            require("fidget").setup({})
        end,
    },

    -- Git Signs
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({
                current_line_blame = true,
                signs = {
                    add = { text = "│" },
                    change = { text = "│" },
                    delete = { text = "_" },
                    topdelete = { text = "‾" },
                    changedelete = { text = "~" },
                    untracked = { text = "┆" },
                },
            })
        end,
        keys = {
            {
                "<leader>gb",
                function()
                    require("gitsigns").blame_line({ full = true })
                end,
                desc = "Git Blame Line",
            },
            {
                "<leader>gp",
                function()
                    require("gitsigns").preview_hunk()
                end,
                desc = "Preview Hunk",
            },
        },
    },

    -- Folds
    {
        "chrisgrieser/nvim-origami",
        config = function()
            require("origami").setup({})
        end,
        keys = {
            {
                "<Left>",
                function()
                    require("origami").h()
                end,
                desc = "Close Fold",
            },
            {
                "<Right>",
                function()
                    require("origami").l()
                end,
                desc = "Open Fold",
            },
        },
    },

    -- Whitespace Management
    {
        "ntpeters/vim-better-whitespace",
        event = "BufRead",
        config = function()
            vim.g.better_whitespace_enabled = 1
            vim.g.strip_whitespace_on_save = 1
            vim.g.better_whitespace_filetypes_blacklist = {
                "diff",
                "git",
                "gitcommit",
                "markdown",
                "unite",
                "qf",
                "help",
                "snacks_dashboard",
            }
            vim.g.better_whitespace_operator = ""
        end,
    },

    -- Color Scheme
    {
        "vague-theme/vague.nvim",
        priority = 1000,
        config = function()
            require("vague").setup({
                bold = true,
                italic = true,
            })
            vim.cmd("colorscheme vague")
        end,
    },

    -- Snacks (UI Components)
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        config = function()
            require("snacks").setup({
                picker = {
                    hidden = true,
                    ignored = true,
                    sources = {
                        explorer = {
                            auto_close = true,
                            jump = { close = true },
                            confirm = { close = true },
                            layout = {
                                layout = {
                                    position = "right",
                                },
                            },
                        },
                    },
                },
                explorer = {
                    enabled = true,
                    replace_netrw = true,
                    trash = true,
                    auto_close = true,
                },
                statuscolumn = {
                    left = { "mark", "sign" },
                    right = { "fold", "git" },
                    folds = {
                        open = true,
                        git_hl = true,
                    },
                    git = {
                        patterns = { "GitSign", "MiniDiffSign" },
                    },
                    refresh = 50,
                },
                indent = { enabled = true },
                lazygit = {},
                dashboard = {
                    enabled = true,
                    autoclose = false,
                    preset = {
                        keys = {
                            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.picker.files()" },
                            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                            {
                                icon = " ",
                                key = "g",
                                desc = "Find Text",
                                action = ":lua Snacks.picker.grep()",
                            },
                            {
                                icon = " ",
                                key = "r",
                                desc = "Recent Files",
                                action = ":lua Snacks.picker.recent()",
                            },
                            {
                                icon = " ",
                                key = "c",
                                desc = "Config",
                                action = ":e $MYVIMRC",
                            },
                            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
                            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
                            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
                        },
                    },
                    sections = {
                        { section = "header" },
                        { section = "keys", gap = 1, padding = 1 },
                        { section = "startup" },
                    },
                },
                notifier = { enabled = true },
                quickfile = { enabled = true },
                profiler = { enabled = true },
                scroll = { enabled = true },
                words = { enabled = true },
            })
        end,
        keys = {
            -- File Explorer
            {
                "<leader>e",
                function()
                    require("snacks").explorer.open()
                end,
                desc = "Explorer",
            },
            -- Picker
            {
                "<leader>ff",
                function()
                    require("snacks").picker.files()
                end,
                desc = "Find Files",
            },
            {
                "<leader>fg",
                function()
                    require("snacks").picker.grep()
                end,
                desc = "Find Text (Grep)",
            },
            {
                "<leader>fw",
                function()
                    require("snacks").picker.grep_word()
                end,
                desc = "Find Word Under Cursor",
            },
            {
                "<leader>fb",
                function()
                    require("snacks").picker.buffers()
                end,
                desc = "Find Buffers",
            },
            {
                "<leader>fh",
                function()
                    require("snacks").picker.help()
                end,
                desc = "Find Help",
            },
            {
                "<leader>fr",
                function()
                    require("snacks").picker.recent()
                end,
                desc = "Find Recent Files",
            },
            {
                "<leader>fc",
                function()
                    require("snacks").picker.commands()
                end,
                desc = "Find Commands",
            },
            {
                "<leader>fk",
                function()
                    require("snacks").picker.keymaps()
                end,
                desc = "Find Keymaps",
            },
            {
                "<leader>fd",
                function()
                    require("snacks").picker.diagnostics()
                end,
                desc = "Find Diagnostics",
            },
            {
                "<leader>ft",
                function()
                    require("snacks").picker.todo_comments()
                end,
                desc = "Find TODOs",
            },
            -- Git
            {
                "<leader>gg",
                function()
                    require("snacks").lazygit.open()
                end,
                desc = "Lazygit",
            },
            -- Dashboard
            {
                "<leader>h",
                function()
                    require("snacks").dashboard()
                end,
                desc = "Dashboard",
            },
            -- Profiler
            {
                "<leader>ps",
                function()
                    require("snacks").profiler.startup()
                end,
                desc = "Profile Startup",
            },
            {
                "<leader>pp",
                function()
                    require("snacks").profiler.pick()
                end,
                desc = "Pick Profile",
            },
            -- Notifications
            {
                "<leader>nh",
                function()
                    require("snacks").notifier.show_history()
                end,
                desc = "Notification History",
            },
            {
                "<leader>nd",
                function()
                    require("snacks").notifier.hide()
                end,
                desc = "Dismiss Notifications",
            },
        },
    },

    -- Which-Key
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            require("which-key").setup({
                preset = "modern",
                delay = 400,
            })
            require("which-key").add({
                { "<leader>f", group = "Find" },
                { "<leader>g", group = "Git" },
                { "<leader>c", group = "Code" },
                { "<leader>d", group = "Debug/Diagnostics" },
                { "<leader>t", group = "Toggle" },
                { "<leader>s", group = "Session" },
                { "<leader>n", group = "Notifications" },
                { "<leader>p", group = "Profile" },
            })
        end,
    },

    -- Mini Modules
    {
        "echasnovski/mini.nvim",
        config = function()
            require("mini.move").setup()
            require("mini.comment").setup()
            require("mini.pairs").setup()
            require("mini.statusline").setup()
            require("mini.tabline").setup()
            require("mini.surround").setup()

            -- Mini Hipatterns
            require("mini.hipatterns").setup({
                highlighters = {
                    fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
                    hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
                    todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
                    note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
                    hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
                },
            })

            -- Mini Sessions
            require("mini.sessions").setup({
                autoread = false,
                autowrite = true,
                directory = vim.fn.stdpath("data") .. "/sessions/",
            })
        end,
        keys = {
            {
                "<leader>ss",
                function()
                    vim.ui.input({ prompt = "Session name: " }, function(name)
                        if name then
                            require("mini.sessions").write(name)
                        end
                    end)
                end,
                desc = "Save Session",
            },
            {
                "<leader>sl",
                function()
                    require("mini.sessions").select()
                end,
                desc = "Load Session",
            },
            {
                "<leader>sd",
                function()
                    require("mini.sessions").select("delete")
                end,
                desc = "Delete Session",
            },
        },
    },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        version = false,
        branch = "master",
        build = ":TSUpdate",
        lazy = false,
        main = "nvim-treesitter.configs",
        opts = {
            ensure_installed = {
                "lua",
                "vim",
                "vimdoc",
                "query",
                "python",
                "c",
                "cpp",
                "markdown",
                "markdown_inline",
                "json",
                "csv",
            },
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },
            incremental_selection = {
                enable = true,
                keymaps = { node_incremental = "v", node_decremental = "V" },
            },
        },
        config = function(_, opts)
            local ok, configs = pcall(require, "nvim-treesitter.configs")
            if not ok then
                return
            end
            configs.setup(opts)
        end,
    },

    -- Mason
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = {
            {
                "mason-org/mason.nvim",
                opts = {
                    ui = {
                        icons = {
                            package_installed = "✓",
                            package_pending = "➜",
                            package_uninstalled = "✗"
                        }
                    },
                },
            },
        },
        opts = {
            ensure_installed = {
                -- LSP
                "lua-language-server",

                -- Formatters
                "stylua",

                -- Linters
                "luacheck",
            },
            auto_update = false,
            run_on_start = true
        }
    },

    -- LSP
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            { "folke/lazydev.nvim", ft = "lua" },
        },
        config = function()
            require("lazydev").setup({
                library = {},
            })

            vim.diagnostic.config({
                underline = true,
                signs = {
                    active = true,
                    text = {
                        [vim.diagnostic.severity.ERROR] = "",
                        [vim.diagnostic.severity.WARN] = "",
                        [vim.diagnostic.severity.HINT] = "󰟃",
                        [vim.diagnostic.severity.INFO] = "",
                    },
                },
                virtual_text = false,
                float = {
                    border = "rounded",
                    format = function(diagnostic)
                        return string.format(
                            "%s (%s) [%s]",
                            diagnostic.message,
                            diagnostic.source,
                            diagnostic.code or diagnostic.user_data.lsp.code
                        )
                    end,
                },
            })

            vim.lsp.enable({ "lua_ls" })
            vim.lsp.enable({ "gopls" })
        end,
        keys = {
            { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" } },
            { "<leader>cr", vim.lsp.buf.rename, desc = "Rename" },
            { "gd", vim.lsp.buf.definition, desc = "Go to Definition" },
            { "gr", vim.lsp.buf.references, desc = "Go to References" },
            { "gI", vim.lsp.buf.implementation, desc = "Go to Implementation" },
            { "K", vim.lsp.buf.hover, desc = "Hover Documentation" },
            { "[d", vim.diagnostic.goto_prev, desc = "Previous Diagnostic" },
            { "]d", vim.diagnostic.goto_next, desc = "Next Diagnostic" },
        },
    },

    -- Formatting
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        config = function()
            require("conform").setup({
                formatters_by_ft = {
                    lua = { "stylua" },
                    go = { "goimports", "golines" },
                },
                format_on_save = {
                    lsp_fallback = true,
                    timeout_ms = 3000,
                },
                formatters = {
                    golines = {
                        args = {
                            "--max-len=80",
                            "--base-formatter=gofmt",
                        },
                    },
                },
            })
        end,
        keys = {
            {
                "<leader>cf",
                function()
                    require("conform").format({ async = true, lsp_fallback = true })
                end,
                desc = "Format",
            },
        },
    },

    -- Linting
    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("lint").linters_by_ft = {
                lua = { "luacheck" },
                go = { "golangcilint" },
            }
        end,
    },

    -- Completions
    {
        "saghen/blink.cmp",
        version = "1.*",
        config = function()
            require("blink.cmp").setup({
                keymap = { preset = "default" },
                sources = { default = { "lsp", "path", "snippets", "buffer" } },
                fuzzy = { implementation = "lua" },
                completion = {
                    menu = { auto_show = false },
                    documentation = { auto_show = true },
                },
            })
        end,
    },

    -- Trouble (Diagnostics)
    {
        "folke/trouble.nvim",
        cmd = { "Trouble" },
        config = function()
            require("trouble").setup({})
        end,
        keys = {
            {
                "<leader>dd",
                function()
                    require("trouble").toggle()
                end,
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>dw",
                function()
                    require("trouble").toggle("workspace_diagnostics")
                end,
                desc = "Workspace Diagnostics",
            },
            {
                "<leader>dq",
                function()
                    require("trouble").toggle("quickfix")
                end,
                desc = "Quickfix List",
            },
        },
    },
}, {
        install = { colorscheme = { "vague", "habamax" } },
        ui = {
            border = "rounded",
        },
        performance = {
            rtp = {
                disabled_plugins = {
                    "gzip",
                    "tarPlugin",
                    "tohtml",
                    "tutor",
                    "zipPlugin",
                },
            },
        },
    })

-- AUTOCOMMANDS

-- Format on save
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function(args)
        require("conform").format({ bufnr = args.buf })
    end,
})

-- Hover Diagnostics
local diag_group = vim.api.nvim_create_augroup("DiagnosticHover", { clear = true })
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    group = diag_group,
    callback = function()
        vim.diagnostic.open_float(nil, {
            border = "rounded",
            scope = "cursor",
            focus = false,
            header = "",
            prefix = "",
        })
    end,
})

-- Highlight text after yank
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking text",
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})

-- Close certain filetypes with q
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "help", "qf", "lspinfo", "checkhealth" },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
})

-- GENERAL KEYMAPS

-- Clear search highlighting
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Resize windows
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize +2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize -2<CR>", { desc = "Increase window width" })

-- Buffer Navigation
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { silent = true, desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { silent = true, desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", { silent = true, desc = "Delete buffer" })

-- Toggle Options
vim.keymap.set("n", "<leader>tn", function()
    vim.o.relativenumber = not vim.o.relativenumber
end, { desc = "Toggle Relative Number" })

vim.keymap.set("n", "<leader>tw", function()
    vim.o.wrap = not vim.o.wrap
end, { desc = "Toggle Wrap" })

vim.keymap.set("n", "<leader>ts", function()
    vim.o.spell = not vim.o.spell
end, { desc = "Toggle Spell" })

-- Lazy
vim.keymap.set("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- Insert mode navigation
vim.keymap.set("i", "<M-h>", "<Left>", { desc = "Move left" })
vim.keymap.set("i", "<M-j>", "<Down>", { desc = "Move down" })
vim.keymap.set("i", "<M-k>", "<Up>", { desc = "Move up" })
vim.keymap.set("i", "<M-l>", "<Right>", { desc = "Move right" })
vim.keymap.set("i", "<leader>i", "<ESC>", { desc = "Exit Insert Mode" })
