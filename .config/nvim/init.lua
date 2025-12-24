-- LEADER KEYS
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
--vim.o.listchars = 'tab:Â» ,lead:Â·,trail:Â·'
vim.o.inccommand = "split"
vim.o.wrap = false

-- EDITING BEHAVIOR
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldcolumn = "1"
--vim.o.fillchars = [[eob: ,fold: ,foldopen:ï‘¼,foldsep: ,foldclose:ï‘ ]]
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.breakindent = true
vim.o.mouse = "a"
vim.o.timeoutlen = 300
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

-- Disable netrw (using snacks.explorer instead)
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrw = 1

-- Set clipboard asynchronously to avoid startup delay
vim.schedule(function()
    vim.o.clipboard = "unnamedplus"
end)

-- AUTOCOMMANDS

-- Clean unused packages
vim.api.nvim_create_user_command('PackClean', function()
    local all_plugins = vim.pack.get()
    local unused_plugins = {}
    for _, plugin in ipairs(all_plugins) do
        if not plugin.active then
            table.insert(unused_plugins, plugin.spec.name)
        end
    end
    if #unused_plugins > 0 then
        vim.pack.del(unused_plugins)
        print("Deleted unused plugins: " .. table.concat(unused_plugins, ", "))
    else
        print("No unused plugins found.")
    end
end, {})

-- Highlight text after yank
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking text",
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})

-- PLUGINS
vim.pack.add({
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "master" },
    { src = "https://github.com/nvim-mini/mini.nvim" },
    { src = "https://github.com/j-hui/fidget.nvim" },
    { src = "https://github.com/folke/snacks.nvim" },
    { src = "https://github.com/vague-theme/vague.nvim" },
    { src = "https://github.com/ntpeters/vim-better-whitespace" },
    { src = "https://github.com/chrisgrieser/nvim-origami" },
})
-- PLUGIN CONFIGURATIONS

-- Folds
require("origami").setup({})

-- Whitespace Management
vim.g.better_whitespace_enabled = 1
vim.g.strip_whitespace_on_save = 1
vim.g.better_whitespace_filetypes_blacklist = {
    "diff", "git", "gitcommit", "markdown", "unite", "qf", "help"
}
vim.g.better_whitespace_operator = ""

-- Color Scheme
require("vague").setup({
    bold = true,
    italic = true,
})
vim.cmd("colorscheme vague")

-- Treesitter
require("nvim-treesitter.configs").setup({
    incremental_selection = {
        enable = true,
        keymaps = {
            node_incremental = "v",
            node_decremental = "V",
        },
    },
    ensure_installed = {
        "lua",
        "vim",
        "vimdoc",
        "c",
        "cpp",
        "go",
        "gomod",
        "gosum",
        "gotmpl",
        "gowork",
        "fish",
        "regex",
    },
    highlight = { enable = true },
    indent = { enable = true },
})

-- Snacks
require("snacks").setup({
    picker = {
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
    indent = { enabled = true },
})

-- Mini Modules
require("mini.move").setup()
require("mini.comment").setup()
require("mini.pairs").setup()
require("mini.statusline").setup()
require("mini.tabline").setup()
require("mini.surround").setup()

-- Mini Hipatterns (keyword highlighting)
require("mini.hipatterns").setup({
    highlighters = {
        fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
        hack  = { pattern = '%f[%w]()HACK()%f[%W]',  group = 'MiniHipatternsHack'  },
        todo  = { pattern = '%f[%w]()TODO()%f[%W]',  group = 'MiniHipatternsTodo'  },
        note  = { pattern = '%f[%w]()NOTE()%f[%W]',  group = 'MiniHipatternsNote'  },
        hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
    },
})

-- KEYMAPS
-- Clear search highlighting
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Buffer Navigation
vim.keymap.set("n", "<Tab>", ":bnext<CR>", { silent = true, desc = "Next buffer" })
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", { silent = true, desc = "Previous buffer" })
vim.keymap.set("n", "<C-w>d", "<Cmd>bd<CR>", { noremap = true, silent = true, desc = "Delete buffer" })

-- File Explorer
vim.keymap.set("n", "<leader>e", function() require("snacks").explorer.open() end, { desc = "Snacks Explorer" })

-- Folds
vim.keymap.set("n", "<Left>", function() require("origami").h() end)
vim.keymap.set("n", "<Right>", function() require("origami").l() end)
