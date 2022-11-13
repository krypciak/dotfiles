userdir = os.getenv('HOME')
wallpaper_dir = userdir .. '/.config/wallpapers/'
wallpaper_selected_file = userdir .. '/.cache/wallpaper-selected'

default_group = 1
default_index = 1

wallpapers = { 
    {  'oneshot/library.png', 'oneshot/main.png', 'oneshot/factory.png', 'oneshot/asteroid.png' }, 
    { 'autumn.png' }, 
    { '#000000', '#303030' } 
}

group = default_group
index = default_index

file = io.open(wallpaper_selected_file, "r")

if file then
    lines = file:lines()
    i = 0
    for line in lines do
        i = i + 1
        if i == 1 then group = tonumber(line)
        elseif i == 2 then index = tonumber(line)
        else break end
    end

    group = group + tonumber(arg[1])
    if group > #wallpapers then group = 1
    elseif 0 >= group      then group = #wallpapers end

    index = index + tonumber(arg[2])
    if index > #wallpapers[group] then index = 1
    elseif 0 >= index             then index = #wallpapers[group] end
    file:close()
end

file = io.open(wallpaper_selected_file, "w")
    
file:write(group .. '\n' .. index .. '\n')
file:close()

function set_wallpaper(wallpaper) 
    if wallpaper:find('^#') then
        os.execute('swaybg --color "' .. wallpaper .. '"')
    else
        os.execute('swaybg --mode stretch --image ' .. wallpaper_dir .. wallpaper)
    end
end

os.execute("pkill swaybg")
set_wallpaper(wallpapers[group][index])

