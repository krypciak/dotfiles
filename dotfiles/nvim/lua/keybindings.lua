function map(mode, combo, mapping, opts)
    local options = {noremap = true}
    if opts then
        options = vim.tbl_extend('force', options, opts)
    end
    vim.api.nvim_set_keymap(mode, combo, mapping, options)
end

-- NvimTree keybindings
map('n', '<C-n>', ':NvimTreeToggle<CR>', { noremap = true })

-- Run/Compile keybinding
map('n', '<leader>t', '', { noremap = true, callback = function()
        ftype = vim.bo.filetype
        if ftype == 'rust' then rust_run()
        elseif ftype == 'python' then python_run()
        else print('Unsupported filetype: '.. ftype) end
   end })


-- Build keybinding
map('n', '<leader>b', '', { noremap = true, callback = function()
        ftype = vim.bo.filetype
        if ftype == 'rust' then rust_build()
        elseif ftype == 'c' then c_build()
        elseif ftype == 'cpp' then c_build()
        else print('Unsupported filetype: '.. ftype) end
   end })



-- d stands for delete not cut
map('n', 'x', '"_x', { noremap = true })
map('n', 'X', '"_X', { noremap = true })
map('n', 'd', '"_d', { noremap = true })
map('n', 'D', '"_D', { noremap = true })
map('v', 'd', '"_d', { noremap = true })


map('n', '<leader>d', '"+d', { noremap = true })
map('n', '<leader>D', '"+D', { noremap = true })
map('v', '<leader>d', '"+d', { noremap = true })

-- Set jk to <esc>
map('', ';;', '<esc>', { noremap = true})
map('i', ';l', '<esc>', { noremap = true})
map('', '<esc>', '<nop>', { noremap = true })
map('i', '<esc>', '<nop>', { noremap = true })

local foldcolumn = 0;
cmd(':set foldcolumn=' .. foldcolumn)
map('n', '<leader>n', '', { noremap = true, callback = function() 
        foldcolumn = foldcolumn + 1
        if foldcolumn > 4 then foldcolumn = 0 end
        cmd(':set foldcolumn='..foldcolumn)
    end,})

map('n', '<leader>w', ':set wrap!<cr>', { noremap = true })

map('n', '<leader>]', ':noh<cr>', { noremap = true })

map('n', '<leader>ff', '<cmd>Telescope find_files<cr>')
--'nnoremap <leader>ff <cmd>Telescope find_files<cr>'
--nnoremap <leader>fg <cmd>Telescope live_grep<cr>
--nnoremap <leader>fb <cmd>Telescope buffers<cr>
--nnoremap <leader>fh <cmd>Telescope help_tags<cr>

map('', '<leader>aa', ':%y<cr>')

require("lang/rust")
require("lang/python")
require("lang/c")

