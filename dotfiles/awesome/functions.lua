-- Function to retrieve console output
function os.capture(cmd)
    local handle = assert(io.popen(cmd, "r"))
    local output = assert(handle:read("*a"))
    handle:close()
    return output
end

function noti(title, text, timeout) 
    if not timeout then timeout = 5 end
    	naughty.notify {
        		preset = naughty.config.presets.low,
        		title = title,
       			text = text,
                timeout = timeout,
            }
end

function run_if_not_running_pgrep(name, func)
    if type(name) == "string" then 
        if not func then
            func = function() 
                awful.spawn(name)
            end
        end
        name = { name }
    end
    local running = 0
    for _, grep in ipairs(name) do
        local cmd
        if string.sub(grep, 0, 1) == "@" then
            grep = string.sub(grep, 2, string.len(grep))
            cmd = "pgrep --full \"" .. grep .. "\""
        else
            cmd = "pgrep " .. grep
        end
        local output = os.capture(cmd)
	    if output ~= "" then
            running = 1 
	    end
    end
    if running == 0 then
        func()
    end
    return running
end

function set_wallpaper(wallpaper, disable_noti)
        if not disable_noti then
            noti("Wallpaper changed", tostring(wallpaper), 1)
        end
        if wallpaper:find('^#') then
            gears.wallpaper.set(wallpaper)
        else
            gears.wallpaper.maximized(wallpaper_dir .. wallpaper)
        end
end

local can_sleep = true

function suspend() 
    if can_sleep then
        awful.spawn("playerctl pause -a")
    	can_sleep = false
	    os.execute('loginctl suspend')
        os.execute('sleep 0.3')
        os.execute(lock_command)
	    local globalkeys_grabber
	    grabber = awful.keygrabber.run(function(_, key, event)
		    if event == "release" then return end
		    os.execute("sleep 0.1")
		    awful.keygrabber.stop(grabber)
		end)
	    can_sleep = true
    end
end

function hibernate() 
    if can_sleep then
        awful.spawn("playerctl pause -a")
	    can_sleep = false
	    os.execute("loginctl hibernate")
	    local globalkeys_grabber
	    grabber = awful.keygrabber.run(function(_, key, event)
		    if event == "release" then return end
			os.execute("sleep 0.1")
			awful.keygrabber.stop(grabber)
	    end)
	    can_sleep = true
    end
end

function serialize_table(val, name, skipnewlines, depth)
    skipnewlines = skipnewlines or false
    depth = depth or 0

    local tmp = string.rep(" ", depth)

    if name then tmp = tmp .. name .. " = " end

    if type(val) == "table" then
        tmp = tmp .. "{" .. (not skipnewlines and "\n" or "")

        for k, v in pairs(val) do
            tmp =  tmp .. serialize_table(v, k, skipnewlines, depth + 1) .. "," .. (not skipnewlines and "\n" or "")
        end

        tmp = tmp .. string.rep(" ", depth) .. "}"
    elseif type(val) == "number" then
        tmp = tmp .. tostring(val)
    elseif type(val) == "string" then
        tmp = tmp .. string.format("%q", val)
    elseif type(val) == "boolean" then
        tmp = tmp .. (val and "true" or "false")
    else
        tmp = tmp .. "\"[inserializeable datatype:" .. type(val) .. "]\""
    end

    return tmp
end
