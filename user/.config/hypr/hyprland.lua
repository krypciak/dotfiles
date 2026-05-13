-- ################
-- ### MONITORS ###
-- ################

hl.monitor {
    output = '',
    mode = 'preffered',
    position = 'auto',
    scale = '1',
}
hl.monitor {
    output = 'HDMI-A-2',
    mode = '2560x1440@144',
}
hl.monitor {
    output = 'eDP-1',
    mode = '1920x1080@60',
    scale = 1,
}

-- ###################
-- ### MY PROGRAMS ###
-- ###################

local terminal = 'alacritty'
local menu = 'fuzzel --width 30 --log-level=none'
local bar_run = 'waybar'
local bar_kill = 'pkill waybar'
local cliphist_menu = '~/.config/scripts/cliphist-fuzzel.sh'
local wallpaper = 'luajit ~/.config/wallpapers/wallpaper.lua'
local music = 'alacritty --class cmus --title cmus -e cmus'
local clipboard_manager = 'wl-paste --watch cliphist -max-items 30000 store'
local mail = 'tutanota-desktop --enable-features=UseOzonePlatform --ozone-platform=wayland'
local browser = 'librewolf'

-- #################
-- ### AUTOSTART ###
-- #################

hl.on('hyprland.start', function()
    hl.exec_cmd('awww-daemon')
    hl.exec_cmd('sleep 0.3; ' .. wallpaper .. ' inc 0 0')
    hl.exec_cmd('gammastep -r')
    hl.exec_cmd(bar_run)
    hl.exec_cmd(clipboard_manager)
    hl.exec_cmd('amixer set Capture nocap > /dev/null 2>&1')
    hl.exec_cmd('fnott')
    hl.exec_cmd('pgrep keepassxc || keepassxc')
    hl.exec_cmd('sleep 15; pgrep tutanota || ' .. mail)
    hl.exec_cmd('blueman-applet')
    hl.exec_cmd('safeeyes')

    hl.exec_cmd('fcitx5 -d')
end)

-- #############################
-- ### ENVIRONMENT VARIABLES ###
-- #############################

hl.env('XCURSOR_SIZE', '24')
hl.env('XCURSOR_THEME', 'breeze_cursors')
hl.env('HYPRCURSOR_SIZE', '24')

hl.env('MOZ_ENABLE_WAYLAND', '1')
hl.env('GDK_BACKEND', 'wayland,x11,*')
hl.env('SDL_VIDEODRIVER', 'wayland')
hl.env('CLUTTER_BACKEND', 'wayland')
hl.env('_JAVA_AWT_WM_NONREPARENTING', '1')

hl.env('ANKI_WAYLAND', '1')

hl.env('QT_QPA_PLATFORM', 'wayland;xcb')
hl.env('QT_AUTO_SCREEN_SCALE_FACTOR', '1')
-- hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION","1")

hl.env('XDG_CURRENT_DESKTOP', 'Hyprland')
hl.env('XDG_SESSION_TYPE', 'wayland')
hl.env('XDG_SESSION_DESKTOP', 'Hyprland')

hl.env('XMODIFIERS', "'@im=fcitx'")
hl.env('SDL_IM_MODULE', "'fcitx'")
hl.env('QT_IM_MODULES', 'wayland;fcitx;ibus')

-- ###################
-- ### PERMISSIONS ###
-- ###################

hl.config {
    ecosystem = {
        enforce_permissions = 1,
    },
}

hl.permission { binary = '/usr/(bin|local/bin)/grim', type = 'screencopy', mode = 'allow' }
hl.permission { binary = '/usr/(bin|local/bin)/hyprpicker', type = 'screencopy', mode = 'allow' }
hl.permission { binary = '/usr/(bin|local/bin)/wayvnc', type = 'screencopy', mode = 'allow' }
hl.permission { binary = '/usr/(bin|local/bin)/wayvnc', type = 'cursorpos', mode = 'allow' }

-- #####################
-- ### LOOK AND FEEL ###
-- #####################

local inactive_border_color = 'rgba(1d1f21ff)'
hl.config {
    general = {
        gaps_in = 0,
        gaps_out = 0,

        border_size = 1,

        col = {
            active_border = 'rgba(33ccffee)',
            inactive_border = inactive_border_color,
        },

        resize_on_border = false,

        allow_tearing = false,
    },
}

hl.config {
    decoration = {
        shadow = {
            enabled = false,
        },
        blur = {
            enabled = false,
        },
    },
    animations = {
        enabled = false,
    },
}

-- inactive border color when only one window
hl.window_rule {
    match = { float = 0, workspace = 'w[tv1]' },
    border_color = inactive_border_color,
}
hl.window_rule {
    match = { float = 0, workspace = '[1]' },
    border_color = inactive_border_color,
}

-- #############
-- ### INPUT ###
-- #############

hl.config {
    input = {
        kb_layout = 'pl,us',
        kb_variant = '',
        kb_model = '',
        kb_options = 'caps:shiftlock',
        kb_rules = '',

        follow_mouse = 2,

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = false,
        },

        repeat_rate = 50,
        repeat_delay = 200,
    },

    cursor = {
        inactive_timeout = 2,
        no_warps = true,
        hide_on_key_press = true,
    },
}

hl.gesture {
    fingers = 3,
    direction = 'horizontal',
    action = 'workspace',
}

-- Example per-device config
-- device {
--     name = epic-mouse-v1
--     sensitivity = -0.5
-- }

-- ##################
-- ### WORKSPACES ###
-- ##################

hl.workspace_rule { workspace = '6', } -- on_created_empty = 'webcord' }
hl.workspace_rule { workspace = '7', on_created_empty = browser }
hl.workspace_rule { workspace = '9', on_created_empty = mail }
hl.workspace_rule { workspace = '5', on_created_empty = music }

hl.bind('ALT + Tab', hl.dsp.focus { workspace = '1' })
hl.bind('ALT + Q', hl.dsp.focus { workspace = '2' })
hl.bind('ALT + W', hl.dsp.focus { workspace = '3' })
hl.bind('ALT + E', hl.dsp.focus { workspace = '4' })
hl.bind('ALT + N', hl.dsp.focus { workspace = '5' })
hl.bind('ALT + D', hl.dsp.focus { workspace = '6' })
hl.bind('ALT + S', hl.dsp.focus { workspace = '7' })
hl.bind('ALT + A', hl.dsp.focus { workspace = '8' })
hl.bind('ALT + Z', hl.dsp.focus { workspace = '9' })
hl.bind('ALT + C', hl.dsp.focus { workspace = '10' })
hl.bind('ALT + H', hl.dsp.focus { workspace = '11' })

hl.bind('ALT + SHIFT + Tab', hl.dsp.window.move { workspace = '1' })
hl.bind('ALT + SHIFT + Q', hl.dsp.window.move { workspace = '2' })
hl.bind('ALT + SHIFT + W', hl.dsp.window.move { workspace = '3' })
hl.bind('ALT + SHIFT + E', hl.dsp.window.move { workspace = '4' })
hl.bind('ALT + SHIFT + N', hl.dsp.window.move { workspace = '5' })
hl.bind('ALT + SHIFT + D', hl.dsp.window.move { workspace = '6' })
hl.bind('ALT + SHIFT + S', hl.dsp.window.move { workspace = '7' })
hl.bind('ALT + SHIFT + A', hl.dsp.window.move { workspace = '8' })
hl.bind('ALT + SHIFT + Z', hl.dsp.window.move { workspace = '9' })
hl.bind('ALT + SHIFT + C', hl.dsp.window.move { workspace = '10' })
hl.bind('ALT + SHIFT + H', hl.dsp.window.move { workspace = '11' })

hl.window_rule { match = { class = '^(discord|WebCord)$' }, workspace = "6 silent" }
hl.window_rule { match = { title = '^(WebCord)$' }, workspace = "6 silent" }
hl.window_rule { match = { title = 'Discord Updater' }, workspace = "6 silent", center = true }
hl.window_rule { match = { class = '^(LibreWolf|librewolf|chromium)$' }, workspace = "7 silent" }
hl.window_rule { match = { class = '^(tutanota-desktop|aerc)$' }, workspace = "9 silent" }
hl.window_rule { match = { class = '^(cmus|spotube)$' }, workspace = "5 silent" }
hl.window_rule { match = { class = '^(prismlauncher|Minecraft.*|steam_app_960090)$' }, workspace = "8 silent" }
hl.window_rule { match = { class = '^(MonkeyCity-Win.exe|dontstarve_steam_x64)$' }, workspace = "8 silent" }
hl.window_rule { match = { title = '^(.*CrossCode.*|Alabaster Dawn|.*DevTools.*)$' }, workspace = "8 silent" }
hl.window_rule { match = { class = '^(Lutris|steam_app_489830)$' }, workspace = "11 silent" }
hl.window_rule { match = { title = '^(.*Steam.*|Launching...)$' }, workspace = "11 silent" }

-- ###################
-- ### KEYBINDINGS ###
-- ###################

-- Spawn
hl.bind('ALT + RETURN', hl.dsp.exec_cmd(terminal))
hl.bind('XF86Terminal ', hl.dsp.exec_cmd(terminal))

hl.bind('ALT + R', hl.dsp.exec_cmd(menu))
hl.bind('XF86Open', hl.dsp.exec_cmd(menu))

-- Power options
local lock = 'playerctl pause -a; swaylock'
local suspend = '~/.config/scripts/suspend.sh; ' .. lock
local reboot = '~/.config/scripts/reboot.sh'
local poweroff = '~/.config/scripts/poweroff.sh'

hl.bind('SUPER + SHIFT + CONTROL + Q', hl.dsp.exec_cmd('hyprctl dispatch exit'))
hl.bind('SUPER + SHIFT + CONTROL + M', hl.dsp.exec_cmd('hyprctl reload'))

hl.bind('SUPER + SHIFT + CONTROL + P', hl.dsp.exec_cmd(poweroff), { locked = true })
hl.bind('XF86PowerOff', hl.dsp.exec_cmd(poweroff), { locked = true })
hl.bind('XF86PowerDown', hl.dsp.exec_cmd(poweroff), { locked = true })

hl.bind('SUPER + SHIFT + CONTROL + L', hl.dsp.exec_cmd(lock))
hl.bind('XF86LogOff ', hl.dsp.exec_cmd(lock))

hl.bind('SUPER + SHIFT + CONTROL + R', hl.dsp.exec_cmd(reboot), { locked = true })
hl.bind('SUPER + SHIFT + CONTROL + T', hl.dsp.exec_cmd('~/.config/scripts/soft-reboot.sh'), { locked = true })
hl.bind('SUPER + SHIFT + CONTROL + W', hl.dsp.exec_cmd('doas grub-reboot 2 && ~/.config/scripts/reboot.sh'), { locked = true })

hl.bind('SUPER + SHIFT + CONTROL + S', hl.dsp.exec_cmd(suspend), { locked = true })
hl.bind('XF86Sleep ', hl.dsp.exec_cmd(suspend), { locked = true })
hl.bind(
    'SUPER + SHIFT + CONTROL + H',
    hl.dsp.exec_cmd('~/.config/scripts/hibernate.sh; if [[ ! -f /etc/encrypted ]]; then ' .. lock .. ' fi'),
    { locked = true }
)

-- Client manipulation
hl.bind('SUPER + SHIFT + C', hl.dsp.window.close())
hl.bind('SUPER + ALT + SHIFT + C', hl.dsp.window.kill())
hl.bind('SUPER + CONTROL + Space', hl.dsp.window.float { action = 'toggle' })
hl.bind('SUPER + F', hl.dsp.window.fullscreen(0))
hl.bind('SUPER + M', hl.dsp.window.fullscreen { mode = 'maximized' })

hl.bind('SUPER + CONTROL + H', hl.dsp.window.resize { x = -60, y = 0 }, { repeating = true })
hl.bind('SUPER + CONTROL + J', hl.dsp.window.resize { x = 0, y = 60 }, { repeating = true })
hl.bind('SUPER + CONTROL + K', hl.dsp.window.resize { x = 0, y = -60 }, { repeating = true })
hl.bind('SUPER + CONTROL + L', hl.dsp.window.resize { x = 60, y = 0 }, { repeating = true })

-- Focus manipulation
hl.bind('SUPER + CONTROL + Return', hl.dsp.layout('swapwithmaster'))
hl.bind('SUPER + J', hl.dsp.layout('cyclenext'))
hl.bind('SUPER + K', hl.dsp.layout('cycleprev'))
hl.bind('SUPER + SHIFT + J', hl.dsp.layout('swapnext'))
hl.bind('SUPER + SHIFT + K', hl.dsp.layout('swapprev'))

-- Layout manipulation
hl.bind('SUPER + H', hl.dsp.layout('mfact -0.05'))
hl.bind('SUPER + L', hl.dsp.layout('mfact +0.05'))
hl.bind('SUPER + SHIFT + H', hl.dsp.layout('addmaster'))
hl.bind('SUPER + SHIFT + L', hl.dsp.layout('removemaster'))

hl.bind('ALT + period', hl.dsp.focus { monitor = 'r' })
hl.bind('ALT + comma', hl.dsp.focus { monitor = 'l' })

hl.bind('ALT + SHIFT + period', hl.dsp.window.move { monitor = 'r' })
hl.bind('ALT + SHIFT + comma', hl.dsp.window.move { monitor = 'l' })

-- Playerctl
hl.bind('ALT + J', hl.dsp.exec_cmd('playerctl play-pause'), { locked = true })
hl.bind('ALT + U', hl.dsp.exec_cmd('playerctl next'), { locked = true })
hl.bind('ALT + M', hl.dsp.exec_cmd('playerctl previous'), { locked = true })
hl.bind('ALT + I', hl.dsp.exec_cmd('playerctl volume 0.02%+'), { locked = true, repeating = true })
hl.bind('ALT + K', hl.dsp.exec_cmd('playerctl volume 0.02%-'), { locked = true, repeating = true })

hl.bind('MOD3 + Tab', hl.dsp.exec_cmd('playerctl play-pause'), { locked = true })
hl.bind('MOD3 + Q', hl.dsp.exec_cmd('playerctl next'), { locked = true })
hl.bind('MOD3 + A', hl.dsp.exec_cmd('playerctl previous'), { locked = true })
hl.bind('MOD3 + W', hl.dsp.exec_cmd('playerctl volume 0.02%+'), { locked = true, repeating = true })
hl.bind('MOD3 + S', hl.dsp.exec_cmd('playerctl volume 0.02%-'), { locked = true, repeating = true })

hl.bind('XF86AudioPause', hl.dsp.exec_cmd('playerctl play-pause'), { locked = true })
hl.bind('XF86AudioPlay', hl.dsp.exec_cmd('playerctl play-pause'), { locked = true })
hl.bind('XF86AudioNext', hl.dsp.exec_cmd('playerctl next'), { locked = true })
hl.bind('XF86AudioPrev', hl.dsp.exec_cmd('playerctl previous'), { locked = true })

-- Misc caps keys
hl.bind('MOD3 + 1', hl.dsp.exec_cmd(cliphist_menu))
hl.bind('ALT + G', hl.dsp.exec_cmd(cliphist_menu))
hl.bind('ALT + Y', hl.dsp.exec_cmd('~/.config/scripts/pipewire-audio-source.sh'))
hl.bind('MOD3 + CONTROL + 1', hl.dsp.exec_cmd('cliphist wipe'))
hl.bind('MOD3 + 3', hl.dsp.exec_cmd('~/.config/scripts/wayland/change-res.sh'))
hl.bind('MOD3 + 6', hl.dsp.exec_cmd('~/.config/scripts/wayland/togglemonitors.sh; ' .. bar_kill .. '; ' .. bar_run))

hl.bind('MOD3 + T', hl.dsp.exec_cmd(wallpaper .. ' wayland-gui'))
hl.bind('MOD3 + Z', hl.dsp.exec_cmd('grim - | wl-copy'))
hl.bind('MOD3 + C', hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy'))
hl.bind('MOD3 + X', hl.dsp.exec_cmd('hyprpicker | wl-copy'))

-- Laptop multimedia keys for volume and LCD brightness
hl.bind('XF86MonBrightnessUp', hl.dsp.exec_cmd('brightnessctl -q s +10%'))
hl.bind('XF86MonBrightnessDown', hl.dsp.exec_cmd('brightnessctl -q s 10%-'))
hl.bind('XF86AudioRaiseVolume', hl.dsp.exec_cmd('wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+'), { locked = true, repeating = true })
hl.bind('XF86AudioLowerVolume', hl.dsp.exec_cmd('wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-'), { locked = true, repeating = true })
hl.bind('XF86AudioMute', hl.dsp.exec_cmd('wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle'), { locked = true, repeating = true })
hl.bind('XF86AudioMicMute', hl.dsp.exec_cmd('wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle'), { locked = true, repeating = true })
hl.bind('Print', hl.dsp.exec_cmd('grim - | wl-copy'))

hl.bind('code:238', hl.dsp.exec_cmd('brightnessctl -d smc::kbd_backlight s +10'))
hl.bind('code:237', hl.dsp.exec_cmd('brightnessctl -d smc::kbd_backlight s 10-'))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind('SUPER + mouse:272', hl.dsp.window.drag(), { mouse = true })
hl.bind('SUPER + mouse:273', hl.dsp.window.resize(), { mouse = true })
hl.bind('SUPER + mouse:274', hl.dsp.window.float { action = 'toggle' }, { mouse = true })

-- ###############
-- ### LAYOUTS ###
-- ###############

hl.config {
    general = {
        layout = 'master',
    },
    master = {
        mfact = 0.5,
    },
}

hl.config {
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        middle_click_paste = false,
        enable_swallow = true,
        swallow_regex = '^(a|A)lacritty$',
        background_color = 'rgb(000000)',
    },
}

-- ##############################
-- ### WINDOWS AND WORKSPACES ###
-- ##############################

hl.window_rule {
    -- Ignore maximize requests from all apps. You'll probably like this.
    name = 'suppress-maximize-events',
    match = { class = '.*' },

    suppress_event = 'maximize',
}

hl.window_rule {
    -- Fix some dragging issues with XWayland
    name = 'fix-xwayland-drags',
    match = {
        class = '^$',
        title = '^$',
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },

    no_focus = true,
}
