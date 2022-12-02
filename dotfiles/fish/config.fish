if status is-interactive
    set fish_greeting
    alias ls='lsd'
    alias l='lsd -l'
    alias la='lsd -a'
    alias lla='lsd -la'
    alias lt='lsd --tree'
    alias tree='lsd --tree'

    alias reboot='loginctl reboot'
    alias poweroff='loginctl poweroff'
    alias suspend='awesome-client "suspend()"'
    alias hibernate='awesome-client "hibernate()"'
    
    alias f='fdisk -l'

    alias motherboard='cat /sys/devices/virtual/dmi/id/board_{vendor,name,version}'
    alias topcmds='history | awk \'{print $1}\' | sort | uniq -c | sort -nr | head -20'

    source /usr/share/autojump/autojump.fish

    atuin init fish | source
    
    alias cat=bat
    alias htop=btm
    alias top=btm
    alias diff=difft
    alias du='echo Use dust.'
    alias find='echo Use fd.'
    alias ti='hyperfine'
    alias df='echo Use lfs.'
    alias ps='echo Use procs.'

end
