-- Create tags
-- default_layout_index is in vars.lua
local default_layout = awful.layout.layouts[default_layout_index]

local normal_tag_keys = {'Tab', 'q', 'w' };
local normal_tag_names = {'T', 'q', 'w' };
-- normal_tag_count in vars.lua
for i = 1, normal_tag_count do
    add_tag({
        --name = tostring(i),
        name = normal_tag_names[i],
        layout = default_layout,

        c_defactivated = true,
        c_key = normal_tag_keys[i]
    })
end


local iconsdir = awesomedir .. "/theme/icons/tag/"

local discord_icon = iconsdir .. "discord.png"
local media_icon = iconsdir .. "media.png"
local lol_icon = iconsdir .. "lol.png"
local mc_icon = iconsdir .. "mc.png"
local music_icon = iconsdir .. "music.png"
local icecat_icon = iconsdir .. "icecat.png"
local chromium_icon = iconsdir .. "chromium.png"
local dialect_icon = iconsdir .. "dialect.png"
local lutris_icon = iconsdir .. "lutris.png"
local btd6_icon = iconsdir .. "btd6.png"
local mail_icon = iconsdir .. "tutanota.png"
local virt_icon = iconsdir .. "virt.png"

add_tag({
    name = "music",
    layout = default_layout,
    volatile = true, 

    icon = music_icon,
    icon_only = true,

    c_key = "n",
    c_defactivated = false,
    c_apps = { name = { "cmus" }},
    c_switchaction = function(tag)
        -- music_player is in vars.lua
        run_if_not_running_pgrep({ music_player_class }, function() awful.spawn(music_player, { tag = tag.name }) end )
    end,
    c_autogenrules = true,
})

local run_discordwebapp = "sh -c 'XAPP_FORCE_GTKWINDOW_ICON=webapp-manager firefox --class WebApp-discord7290 --profile /home/krypek/.local/share/ice/firefox/discord7290 --no-remote https://discord.com/channels/@me'"

-- local dc_classes = { "discord", "WebApp-discord7290" }
-- local dc_grep = { "Discord", "@/usr/lib/firefox/firefox --class WebApp-discord7290" }
add_tag({
    name = "discord",
    layout = default_layout,
    volatile = true,

    icon = discord_icon,
    icon_only = true,

    -- Custom variables
    c_key = "d",
    c_defactivated = false,
    c_apps = { class = { "discord" }}, 
    c_switchaction = function(tag)
        run_if_not_running_pgrep("discord")
    end,
    c_autogenrules = true,
})
--[[ This isn't acially a diffrent workspace than discord
add_tag({
    name = "badcord",
    -- Custom variables
    c_key = "b",
    c_defactivated = false,
    c_switchaction = function(tag)
        run_if_not_running_pgrep(dc_grep, function() awful.spawn("discord", { tag = tag.name }) end )
    end,
    -- All actions will be redirected to discord, expect switchaction
    c_redirect = "discord"
})
--]]
add_tag({
    name = "icecat",
    layout = default_layout,
    volatile = true, 

    icon = icecat_icon,
    icon_only = true,

    c_key = "s",
    c_defactivated = false,
    c_apps = { class = { "icecat", "Navigator" } },
    c_switchaction = function(tag)
        run_if_not_running_pgrep({ "icecat" }, function() awful.spawn("icecat", { tag = tag.name }) end)
    end,
    c_autogenrules = true,
})

add_tag({
    name = "chromium",
    layout = default_layout,
    volatile = true, 

    icon = chromium_icon,
    icon_only = true,

    c_key = "a",
    c_defactivated = false,
    c_apps = { class = { "chromium", "Chromium" }},
    c_switchaction = function(tag)
        run_if_not_running_pgrep({ "chromium" }, function() awful.spawn("chromium --new-window", { tag = tag.name }) end)
    end,
    c_autogenrules = true,
})

add_tag({
    name = "mail",
    layout = default_layout,
    volatile = true, 

    icon = mail_icon,
    icon_only = true,

    c_key = "z",
    c_defactivated = false,
    c_apps = { class = { "tutanota-desktop", 'aerc' }},
    c_switchaction = function(tag)
	    run_if_not_running_pgrep({ "tutanota", 'aerc' }, function() awful.spawn("tutanota-desktop") end)
    end,
    c_autogenrules = true,
})

add_tag({
    name = "dialect",
    layout = default_layout,
    volatile = true, 

    icon = dialect_icon,
    icon_only = true,

    c_key = "t",
    c_defactivated = false,
    c_apps = { class = { "dialect" }},
    c_switchaction = function(tag)
	    run_if_not_running_pgrep({ "dialect" }, function() awful.spawn("dialect", { tag = tag.name }) end) 
    end,
    c_autogenrules = true,
})

local media_classes = {"FreeTube", "LBRY" }
local media_grep = { "freetube", "lbry"}
add_tag({
    name = "media",
    layout = default_layout,
    volatile = true, 

    icon = media_icon,
    icon_only = true,

    c_key = "f",
    c_defactivated = false,
    c_apps = { class = media_classes },
    c_switchaction = function(tag)
        run_if_not_running_pgrep(media_grep, function() awful.spawn("freetube", { tag = tag.name }) end)
    end,
    c_autogenrules = true,
})

-- Redirect to media tag
add_tag({
    name = "lbry",

    c_key = "y",
    c_defactivated = false,
    c_switchaction = function(tag)
        run_if_not_running_pgrep(media_grep, function() awful.spawn("lbry", { tag = tag.name }) end)
    end,
    c_redirect = "media"
})
local mc_classes = { "multimc", "MultiMC", "Minecraft*" }
add_tag({
    name = "mc",
    layout = default_layout,
    volatile = true,

    icon = mc_icon,
    icon_only = true,

    c_key = "c",
    c_defactivated = false,
    c_apps = { class = mc_classes },
    c_switchaction = function(tag)
	    run_if_not_running_clients({{"multimc", { tag = tag.name }}}, get_all_clients(), mc_classes, {})
    end,
    c_autogenrules = true,
})


add_tag({
    name = "virt",
    layout = default_layout,
    volatile = true,

    icon = virt_icon,
    icon_only = true,

    c_key = "g",
    c_defactivated = false,
    c_apps = { class = { "virt-manager", "Virt-manager" }},
    c_switchaction = function(tag)
	    run_if_not_running_pgrep("virt-manager")
    end,
    c_autogenrules = true,
})

local lol_classes = { 	
	"leagueclient.exe",   "league of legends.exe", 
    "leagueclientux.exe", "riotclientux.exe",
    "live.na.exe"
}
add_tag({
    name = "lol",
    layout = awful.layout.suit.floating,
    volatile = true,

    icon = lol_icon,
    icon_only = true,

    -- Custom variables
    c_key = "v",
    c_defactivated = false,
    c_apps = { class = lol_classes },
    c_switchaction = function(tag)
        run_if_not_running_pgrep({"Riot", "League"}, function() awful.spawn("env LUTRIS_SKIP_INIT=1 lutris lutris:rungameid/1", { tag = tag.name }) end)
    end,
    c_autogenrules = true,
})

add_tag({
    name = "games",
    layout = awful.layout.suit.floating,

    icon = lutris_icon,
    icon_only = true,

    c_key = "h",
    c_defactivated = false,
    c_apps = { class = { "Steam", "lutris", "Lutris", "steam_app_960090", "CrossCode" }, name = { "Steam", "BloonsTD6" }},
    c_autogenrules = true,

    --[[c_switchaction = function(tag)
	run_if_not_running_clients({{"env LUTRIS_SKIP_INIT=1 lutris",
	  { tag = tag.name }}}, get_all_clients(), tag.c_apps["class"], {})
    end]]
})

