local o = vim.o
local g = vim.g

-- Share system clipboard with vim clipboard
cmd('set clipboard+=unnamedplus')

o.relativenumber = true
vim.wo.number = true
o.wrap = false
o.tabstop = 4
o.shiftwidth = 4
o.expandtab = true
o.foldmethod = 'indent'

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
