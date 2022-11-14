local dpi   = require("beautiful.xresources").apply_dpi
hotkeys_popup = require("awful.hotkeys_popup")
hotkeys_popup.hide_without_description = false


local os = os
local my_table = awful.util.table

theme                                           = {}
theme.dir                                       = os.getenv("HOME") .. "/.config/awesome/theme"
theme.font                                      = "Terminus 9"
theme.font_bold                                 = "Terminus Bold 9"
theme.fg_normal                                 = "#ff0000" -- "#d9d9d9" --"#DDDDFF"
theme.fg_focus                                  = "#ee0000" --"#ffffff" --"#EA6F81"
theme.fg_urgent                                 = "#ff00000" --"#ffffff" --"#CC9393"
theme.bg_normal                                 = "#000000" --"#1A1A1A" --"#1A1A1A"
theme.bg_focus                                  = "#110000" --"#313131"
theme.bg_urgent                                 = "#220000" --"#1A1A1A"

theme.hotkeys_bg                                = "#1d1f21"
theme.hotkeys_fg                                = "#fcfcfc"

theme.notification_fg                           = "#fcfcfc"
theme.notification_icon_size                    = 256

theme.border_width                              = dpi(2)
theme.border_normal                             = "#000000" --"#3F3F3F"
theme.border_focus                              = "#ff0000" --"#ff9900" --"#7F7F7F"
theme.border_marked                             = "#ff0000" --"#CC9393"

theme.tasklist_bg_focus                         = "#000000" --"#b36b00" --"#1A1A1A"
theme.titlebar_bg_focus                         = theme.bg_focus
theme.titlebar_bg_normal                        = theme.bg_normal
theme.titlebar_fg_focus                         = theme.fg_focus

theme.menu_height                               = dpi(16)
theme.menu_width                                = dpi(140)
theme.menu_submenu_icon                         = theme.dir .. "/icons/submenu.png"
theme.taglist_squares_sel                       = theme.dir .. "/icons/square_sel.png"
theme.taglist_squares_unsel                     = theme.dir .. "/icons/square_unsel.png"
theme.layout_tile                               = theme.dir .. "/icons/tile.png"
theme.layout_tileleft                           = theme.dir .. "/icons/tileleft.png"
theme.layout_tilebottom                         = theme.dir .. "/icons/tilebottom.png"
theme.layout_tiletop                            = theme.dir .. "/icons/tiletop.png"
--theme.layout_fairv                              = theme.dir .. "/icons/fairv.png"
--theme.layout_fairh                              = theme.dir .. "/icons/fairh.png"
--theme.layout_spiral                             = theme.dir .. "/icons/spiral.png"
--theme.layout_dwindle                            = theme.dir .. "/icons/dwindle.png"
--theme.layout_max                                = theme.dir .. "/icons/max.png"
--theme.layout_fullscreen                         = theme.dir .. "/icons/fullscreen.png"
--theme.layout_magnifier                          = theme.dir .. "/icons/magnifier.png"
theme.layout_floating                           = theme.dir .. "/icons/floating.png"
theme.widget_ac                                 = theme.dir .. "/icons/ac.png"
--theme.widget_battery                            = theme.dir .. "/icons/battery.png"
--theme.widget_battery_low                        = theme.dir .. "/icons/battery_low.png"
--theme.widget_battery_empty                      = theme.dir .. "/icons/battery_empty.png"
theme.widget_mem                                = theme.dir .. "/icons/mem.png"
theme.widget_cpu                                = theme.dir .. "/icons/cpu.png"
theme.widget_temp                               = theme.dir .. "/icons/temp.png"
theme.widget_net                                = theme.dir .. "/icons/net.png"
theme.widget_updates                            = theme.dir .. "/icons/updates.png"
--theme.widget_hdd                                = theme.dir .. "/icons/hdd.png"
--theme.widget_music                              = theme.dir .. "/icons/note.png"
--theme.widget_music_on                           = theme.dir .. "/icons/note_on.png"
theme.widget_vol                                = theme.dir .. "/icons/vol.png"
theme.widget_vol_low                            = theme.dir .. "/icons/vol_low.png"
theme.widget_vol_no                             = theme.dir .. "/icons/vol_no.png"
theme.widget_vol_mute                           = theme.dir .. "/icons/vol_mute.png"
theme.tasklist_plain_task_name                  = false
theme.tasklist_disable_icon                     = false 
theme.useless_gap                               = dpi(default_useless_gap)
theme.titlebar_close_button_focus               = theme.dir .. "/icons/titlebar/close_focus.png"
theme.titlebar_close_button_normal              = theme.dir .. "/icons/titlebar/close_normal.png"
--theme.titlebar_ontop_button_focus_active        = theme.dir .. "/icons/titlebar/ontop_focus_active.png"
--theme.titlebar_ontop_button_normal_active       = theme.dir .. "/icons/titlebar/ontop_normal_active.png"
--theme.titlebar_ontop_button_focus_inactive      = theme.dir .. "/icons/titlebar/ontop_focus_inactive.png"
--theme.titlebar_ontop_button_normal_inactive     = theme.dir .. "/icons/titlebar/ontop_normal_inactive.png"
--theme.titlebar_sticky_button_focus_active       = theme.dir .. "/icons/titlebar/sticky_focus_active.png"
--theme.titlebar_sticky_button_normal_active      = theme.dir .. "/icons/titlebar/sticky_normal_active.png"
--theme.titlebar_sticky_button_focus_inactive     = theme.dir .. "/icons/titlebar/sticky_focus_inactive.png"
--theme.titlebar_sticky_button_normal_inactive    = theme.dir .. "/icons/titlebar/sticky_normal_inactive.png"
--theme.titlebar_floating_button_focus_active     = theme.dir .. "/icons/titlebar/floating_focus_active.png"
--theme.titlebar_floating_button_normal_active    = theme.dir .. "/icons/titlebar/floating_normal_active.png"
--theme.titlebar_floating_button_focus_inactive   = theme.dir .. "/icons/titlebar/floating_focus_inactive.png"
--theme.titlebar_floating_button_normal_inactive  = theme.dir .. "/icons/titlebar/floating_normal_inactive.png"
--theme.titlebar_maximized_button_focus_active    = theme.dir .. "/icons/titlebar/maximized_focus_active.png"
--theme.titlebar_maximized_button_normal_active   = theme.dir .. "/icons/titlebar/maximized_normal_active.png"
--theme.titlebar_maximized_button_focus_inactive  = theme.dir .. "/icons/titlebar/maximized_focus_inactive.png"
--theme.titlebar_maximized_button_normal_inactive = theme.dir .. "/icons/titlebar/maximized_normal_inactive.png"



local markup = lain.util.markup
local separators = lain.util.separators

--local keyboardlayout = awful.widget.keyboardlayout:new()

-- Textclock
local clockicon = wibox.widget.imagebox(theme.widget_clock)
local clock = awful.widget.watch(
    "date +'%m %b  %d %a  %R:%S '", 1,
    function(widget, stdout)
	widget.markup = 
	  '<span color="'..theme.fg_normal..'" font="'..theme.font_bold..'">  '..stdout..'</span>'
    end
)

-- Calendar
theme.cal = lain.widget.cal({
    attach_to = { clock },
    notification_preset = {
        font = "Terminus 10",
        fg   = theme.fg_normal,
        bg   = theme.bg_normal
    }
})


-- MEM
local memicon = wibox.widget.imagebox(theme.widget_mem)
local mem = lain.widget.mem({
    settings = function()
	widget.markup = 
	  '<span color="'..theme.fg_normal..'" font="'..theme.font_bold..'">'..string.format("%.1f", mem_now.used/1024)..'</span>'..
	  '<span color="'..theme.fg_normal..'" font="'..theme.font..'"> GB </span>'
    end
})

-- CPU
local cpuicon = wibox.widget.imagebox(theme.widget_cpu)
local cpu = lain.widget.cpu({
    settings = function()
	widget.markup = 
	  '<span color="'..theme.fg_normal..'" font="'..theme.font_bold..'">'..cpu_now.usage..'% '..'</span>'
    end
})

-- CPU temp
local cpu_temp_icon = wibox.widget.imagebox(theme.widget_temp) 
local cpu_temp = awful.widget.watch("cat /sys/class/hwmon/hwmon0/temp1_input", 5, function(widget, stdout)
	widget.markup = 
	  '<span color="'..theme.fg_normal..'" font="'..theme.font_bold..'">'..string.format("%.1f", tonumber(stdout)/1000) .. '°C '..'</span>'
end)

-- Redshift screen temperature
local screen_temp = awful.widget.watch('echo', 15, function(widget, stdout)
    local text	
    if os.capture("pgrep redshift") == "" then
        text = "NOT RUNNING"
    else
        text = os.capture("redshift -p | grep \"temp\" | awk '{print $3}'")
    end
	widget.markup = 
	  '<span color="'..theme.fg_normal..'" font="'..theme.font_bold..'">'..text..'</span>'
end)

-- Uptime
local uptime = awful.widget.watch('uptime --pretty', 60, function(widget, stdout)
	stdout = os.capture('echo \'' .. stdout .. '\' | sed -E -e \'s/ (minutes|minute)/m/g\' -e \'s/ (hours|hour)/h/g\' -e \'s/ (day|days)/d/g\'')
    widget.markup = 
	  '<span color="'..theme.fg_normal..'" font="'..theme.font_bold..'">'..stdout..'</span>'
end)

-- Battery
--[[
local baticon = wibox.widget.imagebox(theme.widget_battery)
local bat = lain.widget.bat({
    settings = function()
        if bat_now.status and bat_now.status ~= "N/A" then
            if bat_now.ac_status == 1 then
                baticon:set_image(theme.widget_ac)
            elseif not bat_now.perc and tonumber(bat_now.perc) <= 5 then
                baticon:set_image(theme.widget_battery_empty)
            elseif not bat_now.perc and tonumber(bat_now.perc) <= 15 then
                baticon:set_image(theme.widget_battery_low)
            else
                baticon:set_image(theme.widget_battery)
            end
            widget:set_markup(markup.font(theme.font, " " .. bat_now.perc .. "% "))
        else
            widget:set_markup(markup.font(theme.font, " AC "))
            baticon:set_image(theme.widget_ac)
        end
    end
})
--]]
-- ALSA volume
local volicon = wibox.widget.imagebox(theme.widget_vol)
theme.volume = lain.widget.alsa({
    timeout = 3,
    settings = function()
        if volume_now.status == "off" then
            volicon:set_image(theme.widget_vol_mute)
        elseif tonumber(volume_now.level) == 0 then
            volicon:set_image(theme.widget_vol_no)
        elseif tonumber(volume_now.level) <= 50 then
            volicon:set_image(theme.widget_vol_low)
        else
            volicon:set_image(theme.widget_vol)
        end

	widget.markup = 
	  '<span color="'..theme.fg_normal..'" font="'..theme.font_bold..'">'..volume_now.level  .. '% '..'</span>'
    end
})
theme.volume.widget:buttons(awful.util.table.join(
                               awful.button({}, 4, function ()
                                     awful.util.spawn("amixer set Master 1%+")
                                     theme.volume.update()
                               end),
                               awful.button({}, 5, function ()
                                     awful.util.spawn("amixer set Master 1%-")
                                     theme.volume.update()
                               end)
))

-- Net
local neticon = wibox.widget.imagebox(theme.widget_net)
local net = lain.widget.net({
    settings = function()
	local received = tonumber(net_now.received)
	local received_str = ' '..(received > 1024 and (string.format("%0.1f", received/1024).." MB") or (string.format("%0.0f", received).." KB")).."↓"
	
	local sent = tonumber(net_now.sent)
	local sent_str = ' '..(sent > 1024 and (string.format("%0.1f", sent/1024).." MB") or (string.format("%0.0f", sent).." KB")).."↑ "
        
	widget.markup = 
	  '<span color="'..theme.fg_normal..'" font="'..theme.font_bold..'">'..received_str ..'</span>'..
	  '<span color="'..theme.fg_normal..'" font="'..theme.font_bold..'">'..sent_str..'</span>'
    end
})

-- Update check
local updateicon = wibox.widget.imagebox(theme.widget_updates)
local update = awful.widget.watch('echo a', 300, function(widget, stdout)
    stdout = os.capture(update_count_check)
	widget.markup = 
	  '<span color="'..theme.fg_normal..'" font="'..theme.font_bold..'">'..stdout.. '</span>'
end)

-- Separators
local spr     = wibox.widget.textbox(' ')
--local arrl_dl = separators.arrow_left(theme.arrow1, "alpha")
--local arrl_ld = separators.arrow_left("alpha", theme.arrow1)

function theme.at_screen_connect(s)
    -- Quake application
    s.quake = lain.util.quake({ app = awful.util.terminal })

    ext_group = 0
    ext_index = 0
    ext_noti = false
    assert(loadfile(userdir .. '/.config/dotfiles/scripts/wallpaper.lua', 't', _ENV))()

    -- Create a promptbox for each screen
    --s.mypromptbox = awful.widget.prompt()
    
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, nil)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, nil)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = dpi(18), bg = theme.bg_normal, fg = theme.fg_normal })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            --spr,
            s.mytaglist,
            --s.mypromptbox,
            spr,
	    spr,
	    spr,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            --keyboardlayout,
            spr,
            --arrl_ld,
            --wibox.container.background(volicon, theme.arrow1),
            --wibox.container.background(theme.volume.widget, theme.arrow1),
	    volicon,
	    theme.volume.widget,
            --arrl_dl,
            --wibox.container.background(memicon, theme.arrow2),
            --wibox.container.background(mem.widget, theme.arrow2),
	    memicon,
	    mem.widget,
	    cpuicon,
	    cpu.widget,
	    cpu_temp_icon,
	    cpu_temp,
	    spr,
	    screen_temp,
	    spr,
	    neticon,
	    net.widget,
        spr,
        updateicon,
        update,
        spr,
        spr,
        spr,
        spr,
        uptime,
        spr,
        --arrl_dl,
        clock,
        --spr,
        --arrl_ld,
        wibox.container.background(s.mylayoutbox, theme.bg_focus),
        },
    }
end

theme.icon_theme = "/usr/share/icons/breeze-dark"

return theme
