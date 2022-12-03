local o = vim.o
local g = vim.g

-- Share system clipboard with vim clipboard
cmd('set clipboard+=unnamedplus')
if os.getenv('WAYLAND_DISPLAY') then
    -- Wayland
    g.clipboard = {
        copy = {
            ['+'] = 'wl-copy',
            ['*'] = 'wl-copy',
        },
        paste = {
            ['+'] = 'wl-paste',
            ['*'] = 'wl-paste',
        },
        cache_enabled = 1,
    }
else
    -- X11
    g.clipboard = {
        copy = {
            ['+'] = 'xsel -ib',
            ['*'] = 'xsel -ib',
        },
        paste = {
            ['+'] = 'xsel -ob',
            ['*'] = 'xsel -ob',
        },
        cache_enabled = 1,
    }
end
--
g.SuperTabDefaultCompletionType = "<c-n>"


o.relativenumber = true
vim.wo.number = true
o.wrap = false
o.tabstop = 4
o.shiftwidth = 4
o.expandtab = true
o.foldmethod = 'indent'

cmd [[
    set undofile
    set undodir=~/.cache/nvim/undo/
]]

cmd [[

    :highlight Folded ctermbg=237
]]


-- Return to last edit position when opening files
cmd [[
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
]]

