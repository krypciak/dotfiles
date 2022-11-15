local userdir = os.getenv('HOME')
wallpaper_dir = userdir .. '/.config/wallpapers/'
local wallpaper_selected_file = wallpaper_dir .. 'selected'

local default_group = 1
local default_index = 1

local wallpapers = { 
    {  'oneshot/library.png', 'oneshot/main.png', 'oneshot/factory.png', 'oneshot/asteroid.png' }, 
    { 'autumn.png' }, 
    { '#000000', '#303030' } 
}

local in_group
local in_index
if arg then
    in_group = tonumber(arg[1])
    in_index = tonumber(arg[2])
else
    in_group = ext_group
    in_index = ext_index
end

local group = default_group
local index = default_index

local file = io.open(wallpaper_selected_file, "r")

if file then
    lines = file:lines()
    local i = 0
    for line in lines do
        i = i + 1
        if i == 1 then group = tonumber(line)
        elseif i == 2 then index = tonumber(line)
        else break end
    end

    group = group + in_group
    if group > #wallpapers then group = 1
    elseif 0 >= group      then group = #wallpapers end

    index = index + in_index
    if index > #wallpapers[group] then index = 1
    elseif 0 >= index             then index = #wallpapers[group] end
    file:close()
end

file = io.open(wallpaper_selected_file, "w")
    
file:write(group .. '\n' .. index .. '\n')
file:close()

if os.getenv("WAYLAND_DISPLAY") then
    function set_wallpaper(wallpaper) 
        if wallpaper:find('^#') then
            os.execute('swww clear "' .. wallpaper .. '"')
        else
            os.execute('swww img ' .. wallpaper_dir .. wallpaper .. " --transition-type=center --transition-fps 255")
        end
    end
end

set_wallpaper(wallpapers[group][index], not ext_noti)

