-- Disable stupid tmux keybindings from showing up in help menu
package.loaded["awful.hotkeys_popup.keys.tmux"] = {}
-- Add vim keys
require("awful.hotkeys_popup.keys")

local dpi   = require("beautiful.xresources").apply_dpi

local function increse_useless_gap(value)
    lain.util.useless_gaps_resize(value)
end

local function screenshot(command, prefix, open_editor)
    local dir = screenshots_folder .. os.date('%d.%m.%y') .. '/'
    os.execute('mkdir -p ' .. dir)
    local file = dir .. prefix .. '_' .. os.date('%X') .. '.png'
    local cmd = 'scrot --file ' .. file ..
        ' --quality 100 --silent ' .. command
   
    if command == "--select" then
        cmd = cmd .. ' -l mode=classic,style=solid,width=1,color="green"'
    end

    local exec = 
        "awesome-client 'noti(\\\"Screenshot saved (" .. prefix .. ")\\\", \\\"" .. file .. "\\\")'"
        .. ' && copyq write image/png - < ' .. file .. ' && copyq select 0'

    if open_editor then
        exec = exec .. ' && ' .. screenshot_editor .. ' ' .. file 
    end
    cmd = cmd .. ' --exec "' .. exec .. '"'
    awful.spawn(cmd)
end

local function gen_screenshot_key(key, desc, command, prefix)
    return awful.util.table.join(
	    awful.key({capskey}, key, 
            function() screenshot(command, prefix) end,
            {description = desc, group = "screen"}),
	    awful.key({capskey, shiftkey}, key, 
            function() screenshot(command, prefix, true) end,
            {description = desc .. ' (Open ' .. screenshot_editor .. ')', group = "screen"})
    )
end

local main_player
local secondary_player

local function playerctl_action(action, playernumber)
    local output = os.capture("playerctl --list-all")
    output = string.sub(output, 0, -2)
    local split = split_by_line_ending(output)

    if #split == 0 then return end
    if #split == 1 then
        main_player = split[1]
        secondary_player = nil
    else
        if not list_contains(split, main_player) then
            main_player = secondary_player
            secondary_player = nil
            if not list_contains(split, main_player) then
                main_player = split[1]
                secondary_player = split[2]
            end
        end
        assert(main_player ~= nil)
        if not list_contains(split, secondary_player) then
            if split[2] == main_player then
                secondary_player = split[1]
            else
                secondary_player = split[2]
            end
        end
    end
    assert(main_player ~= secondary_player)
   
    if action == "swap" then
        if main_player and secondary_player then
            local t1 = main_player 
            main_player = secondary_player
            secondary_player = t1
        elseif secondary_player then 
            main_player = secondary_player
            secondary_player = nil
        end

        return
    end

    local player
    if playernumber == 1 then player = main_player
    elseif playernumber == 2 then player = secondary_player
    end
    if player then
        local cmd = "playerctl --player=" .. player .. " " .. action
        awful.spawn(cmd)
    else
        noti("Player doesn't exist", "Player " .. playernumber .. " doesn't exist.")
    end
end


local function gen_playerctl_key(key, action, desc)
    return awful.util.table.join(
        -- Primary control
        awful.key({capskey}, key, 
            function() playerctl_action(action, 1) end, 
            { description = action .. " playerctl media", group = "multimedia" }),
        
        -- Secondary control
        awful.key({capskey, shiftkey}, key, 
            function() playerctl_action(action, 2) end, 
            { description = action .. " playerctl media (Secondary)", group = "multimedia" })
    )
end

local globalkeys_media = awful.util.table.join (
    awful.key({capskey, ctrlkey}, "Tab", 
        function() playerctl_action("swap") end,
        { description = "Swap playerctl players", group = "multimedia" }),

    gen_playerctl_key("Tab", "play-pause"),
    gen_playerctl_key("q", "next"),
    gen_playerctl_key("a", "previous"),
    gen_playerctl_key("w", "volume 0.02%+"),
    gen_playerctl_key("s", "volume 0.02%-"),

	-- Global volume controls
	awful.key({capskey}, "e",
		function() awful.spawn("amixer set Master 5%+") end,
		{description = "increse speaker volume", group = "multimedia"}),
	awful.key({capskey}, "d",
		function() awful.spawn("amixer set Master 5%-") end,
		{description = "decrese speaker volume", group = "multimedia"}),
	-- Microphone volume controls
	awful.key({capskey, shift}, "e",
		function() awful.spawn("amixer set Capture 5%+") end,
		{description = "increse microphone volume", group = "multimedia"}),
	awful.key({capskey, shift}, "d",
		function() awful.spawn("amixer set Capture 5%-") end,
		{description = "decrese microphone volume", group = "multimedia"}),

    awful.key({capskey, ctrlkey}, "e",
        function() awful.spawn("amixer set Capture cap") end,
		{description = "unmute microphone", group = "multimedia"}),
    awful.key({capskey, ctrlkey}, "d",
        function() awful.spawn("amixer set Capture nocap") end,
		{description = "mute microphone", group = "multimedia"})
)

local globalkeys_awesome = awful.util.table.join(
	-- Show help
	awful.key({superkey}, "s", hotkeys_popup.show_help,
		{description = "show help", group = "awesome"}),
	awful.key({superkey, shiftkey, ctrlkey}, "q", function()
        awful.spawn("pkill redshift")
        awesome.quit()
        end, {description = "quit awesome", group = "awesome"}),
	-- Restart awesome 
	awful.key({superkey, ctrlkey, shiftkey}, "m", function()
            os.execute("echo "..awful.screen.focused().selected_tag.name .. " > /tmp/awesomewm_last_tag")
            awesome.restart()
        end,
		{description = "reload awesome", group = "awesome"}),

	-- theme variable is in theme.lua
	awful.key({capskey}, "y", 
		function() increse_useless_gap(1) end,
		{description = "Increse useless gap", group = "awesome" }),
	
	awful.key({capskey}, "h",
		function() increse_useless_gap(-1) end,
		{description = "Decrese useless gap", group = "awesome" }),

    awful.key({capskey}, "t", function()
        wallpaper_group = wallpaper_group + 1
        if wallpaper_group > #wallpapers then wallpaper_group = 1 end
        wallpaper_index = 1

        local wallpaper = wallpapers[wallpaper_group][1]
        -- set_vallpaper() in functions.lua
        set_wallpaper(wallpaper)
        end,
        {description = "switch wallpaper group", group = "awesome"}),
    
    awful.key({capskey}, "g", function()
        wallpaper_index = wallpaper_index + 1
        if wallpaper_index > #wallpapers[wallpaper_group] then wallpaper_index = 1 end

        local wallpaper = wallpapers[wallpaper_group][wallpaper_index]
        -- set_vallpaper() in functions.lua
        set_wallpaper(wallpaper)
        end,
        {description = "switch wallpaper index", group = "awesome"})
)

local globalkeys_screen = awful.util.table.join(
	awful.key({superkey, ctrlkey}, "j",
		function() awful.screen.focus_relative(1) end,
		{description = "focus the next screen", group = "screen"}),

	awful.key({superkey, ctrlkey}, "k",
		function() awful.screen.focus_relative(-1) end, 
		{description = "focus the previous screen", group = "screen"}), 
	
	awful.key({capskey}, "v", 
		function() os.execute("sleep 1; xset dpms force off") end,
		{description = "Toggle screen backlight", group = "screen" })
)

local globalkeys_launcher = awful.util.table.join(
	awful.key({altkey}, "e", function()
        -- keychords
	    local globalkeys_grabber
	    grabber = awful.keygrabber.run(function(_, key, event)
			if event == "release" then return end
			if key == "f" then run_if_not_running_pgrep("freetube")
			elseif key == "y" then run_if_not_running_pgrep("lbry")
			
			elseif key == "p" then awful.spawn("")

			elseif key == "l" then awful.spawn("lutris")
			elseif key == "s" then awful.spawn("steam")

			elseif key == "u" then run_if_not_running_pgrep("redshift") 
			elseif key == "g" then run_if_not_running_pgrep("github-desktop") 
			elseif key == "k" then awful.spawn("keepassxc") 
			elseif key == "c" then run_if_not_running_pgrep("copyq") 
			elseif key == "r" then awful.spawn("alacritty --class ranger --title ranger -e ranger") 
			elseif key == "[" then awful.spawn("alacritty --class 'System update' --title 'System update' -e paru -Syu") 
			elseif key == "]" then run_if_not_running_pgrep({ "steam_app_960090" }, function() 
                --awful.spawn("env LUTRIS_SKIP_INIT=1 lutris lutris:rungameid/2") 
                awful.spawn("steam steam://rungameid/368340")
                end)
            
			elseif key == "'" then awful.spawn("sh " .. userdir .. "/.config/dotfiles/scripts/ttyper.sh ignore") 
			elseif key == "v" then awful.spawn("virt-manager") 
			elseif key == "a" then awful.spawn("alacritty --class 'aerc','aerc' --title 'aerc' -e aerc") 
	    end
	    awful.keygrabber.stop(grabber)
	    end)
		end, {description = "Run appliaction keycord", group = "launcher"}),

    awful.key({superkey, altkey}, "v", function() 
	    noti("Terminated", "Terminated league of legends", 1)
	    os.execute("pkill League") 
        os.execute("pkill Riot")    
        end, {description="R.I.P. league of legends", group="launcher"}),

	awful.key({superkey, altkey}, "s", function()
		noti("Application Terminated", "Terminated steam", 1)
		os.execute("killall -s TERM steam") end,
		{description="Close steam", group="launcher"}),

	awful.key({superkey, altkey}, "y", function()
		noti("Application Terminated", "Terminated lbry", 1)
		os.execute("pkill -TERM lbry") end,
		{description="Close lbry", group="launcher"}),

	awful.key({superkey, altkey}, "z", function()
		noti("Application Terminated", "Terminated tutanota", 1)
		os.execute("pkill -TERM tutanota") end,
		{description="Close tutanota", group="launcher"}),

	awful.key({superkey, altkey}, "u", function()
		noti("Application Terminated", "Terminated redshift", 1)
		os.execute("pkill -TERM redshift") end,
		{description="Close redshift", group="launcher"}),

	awful.key({superkey, altkey}, "c", function()
		noti("Application Terminated", "Terminated copyq", 1)
		os.execute("pkill -TERM copyq") end,
		{description="Close copyq", group="launcher"}),

	awful.key({superkey, altkey}, "k", function()
		noti("Application Terminated", "Terminated keepassxc", 1)
		os.execute("pkill -TERM keepassxc") end,
		{description="Close keepassxc", group="launcher"}),
	
    awful.key({superkey, altkey}, "d", function()
		noti("Application Terminated", "Terminated discord", 1)
		os.execute("pkill discord") end,
		{description="Close discord", group="launcher"}),

	awful.key({altkey}, "Return", 
		function() awful.spawn(terminal) end, 
		{description = "open a terminal (" .. terminal .. ")", group = "launcher"}),

	awful.key({altkey}, "r",
		function() awful.spawn("dmenu_run_history") end, 
		{description = "run prompt (dmenu_run_history)", group = "launcher"})
)

local globalkeys_layout = awful.util.table.join(
	awful.key({superkey}, "l", 
		function() awful.tag.incmwfact(0.05) end,
		{description = "increase master width factor", group = "layout"}),

	awful.key({superkey}, "h", function() awful.tag.incmwfact(-0.05) end, 
		{description = "decrease master width factor", group = "layout"}), 

	awful.key({superkey, shiftkey}, "h",
		function() awful.tag.incnmaster(1, nil, true) end, 
		{description = "increase the number of master clients", group = "layout"}), 

	awful.key({superkey, shiftkey}, "l",
		function() awful.tag.incnmaster(-1, nil, true) end, 
		{description = "decrease the number of master clients", group = "layout"}), 
		
	awful.key({superkey, ctrlkey}, "h",
		function() awful.tag.incncol(1, nil, true) end, 
		{description = "increase the number of columns", group = "layout"}), 
	
	awful.key({superkey, ctrlkey}, "l",
		function() awful.tag.incncol(-1, nil, true) end, 
		{description = "decrease the number of columns", group = "layout"}), 

	-- Switch layouts
	awful.key({capskey}, "r",
		function() awful.layout.inc(1) end,
		{description = "Next layout", group = "awesome" }),

    awful.key({capskey}, "f",
		function() awful.layout.inc(-1) end,
		{description = "Previous layout", group = "awesome" })

)

local globalkeys_system = awful.util.table.join(
	awful.key({superkey, ctrlkey, shiftkey}, "p",
		function() awful.spawn("loginctl poweroff") end,
		{description = "poweroff", group = "system"}),

	awful.key({superkey, ctrlkey, shiftkey}, "r",
		function() awful.spawn("loginctl reboot") end,
		{description = "reboot", group = "system"}),

	awful.key({superkey, ctrlkey, shiftkey}, "l",
		function() awful.spawn(lock_command) end,
		{description = "lock", group = "system"}),

	awful.key({superkey, ctrlkey, shiftkey}, "k", function() 
        awful.spawn(lock_command)
        os.execute("sleep 1; xset dpms force off")
        end, {description = "turn off screen and lock", group = "system"}),
    
    -- suspend() in functions.lua
	awful.key({superkey, ctrlkey, shiftkey}, "s", suspend,
		{description = "sleep", group = "system"}),

    -- hibernate() in functions.lua
	awful.key({superkey, ctrlkey, shiftkey}, "h", hibernate,
		{description = "hibernate", group = "system"}),

    gen_screenshot_key('z', 'Take screenshot of the entire screen', '', 'full'),
    gen_screenshot_key('x', 'Take screenshot of currently active window', '--focused', 'act'),
    gen_screenshot_key('c', 'Select area and take screenshot', '--select', 'sel')
)

local globalkeys_tag = awful.util.table.join(
	awful.key({altkey}, "Left", awful.tag.viewprev,
		{description = "view previous", group = "tag"}),
	awful.key({altkey}, "Right", awful.tag.viewnext,
		{description = "view next", group = "tag"}),
	awful.key({altkey}, "Escape", awful.tag.history.restore,
		{description = "go back", group = "tag"})
)

local globalkeys_clients = awful.util.table.join(
	-- sort_clients function is in tags.lua
	awful.key({superkey, altkey}, "t", 
        function() sort_clients() end, 
        {description="place clients where they belong", group = "client"} ),
	
	-- Change focus
	awful.key({superkey}, "j",
		function() awful.client.focus.byidx(1) end, 
		{description = "focus next by index", group = "client"}), 

	awful.key({superkey}, "k", 
		function() awful.client.focus.byidx(-1) end,
		{description = "focus previous by index", group = "client"}),
	-- Layout manipulation
	awful.key({superkey, shiftkey}, "j", function() awful.client.swap.byidx(1) end,
	{description = "swap with next client by index", group = "client"}), 

	awful.key({superkey, shiftkey}, "k",
		function() awful.client.swap.byidx(-1) end, 
		{description = "swap with previous client by index", group = "client" }),
		
	awful.key({superkey}, "u", awful.client.urgent.jumpto,
		{description = "jump to urgent client", group = "client"}),

	awful.key({superkey}, "Tab", function() 
	awful.client.focus.history.previous()
		if client.focus then client.focus:raise() end
			end, 
		{description = "go back", group = "client"})
)


globalkeys = awful.util.table.join(
    globalkeys_media,
    globalkeys_awesome,
    globalkeys_screen,
    globalkeys_launcher,
    globalkeys_layout,
    globalkeys_system,
    globalkeys_tag,
    globalkeys_clients
)
-- Client keys
clientkeys = awful.util.table.join(
	awful.key({superkey}, "f", function(c)
	c.fullscreen = not c.fullscreen
	c:raise()
	end, 
		{description = "toggle fullscreen", group = "client"}),

	awful.key({superkey, "Shift"}, "c",
		function(c) c:kill() end, 
		{description = "close", group = "client"}),

	awful.key({superkey, "Control"}, "space", awful.client.floating.toggle,
		{description = "toggle floating", group = "client"}),
										
	awful.key({superkey, "Control"}, "Return",
		function(c) c:swap(awful.client.getmaster()) end, 
        {description = "move to master", group = "client"}),
		
	awful.key({superkey}, "o", 
		function(c) c:move_to_screen() end, 
		{description = "move to screen", group = "client"}),

	awful.key({superkey}, "t", 
		function(c) c.ontop = not c.ontop end, 
		{description = "toggle keep on top", group = "client"}),
									 
	awful.key({superkey}, "m", function(c) 
	c.maximized = not c.maximized
	c:raise()
	end, 
		{description = "(un)maximize", group = "client"}),
									 
	awful.key({superkey, "Control"}, "m", function(c)
	c.maximized_vertical = not c.maximized_vertical
	c:raise()
	end, 
		{description = "(un)maximize vertically", group = "client"}),
										
	awful.key({superkey, "Shift"}, "m", function(c)
	c.maximized_horizontal = not c.maximized_horizontal
	c:raise() 
	end, 
		{description = "(un)maximize horizontally", group = "client"})
)

