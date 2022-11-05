function python_run()
    cmd(":w")
    -- Get the first non-blank line
    local first_line = vim.fn.getline(1)
    local args = ''
    if first_line:find('#RUN_ARGS=', 1, true) then
        args = string.sub(first_line, 12)
    end
    local bul = ':term python %'
    print(bul)
    cmd(bul)
    cmd("normal! G")
end
