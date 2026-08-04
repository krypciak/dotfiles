if status is-interactive
    set fish_greeting

    source /usr/share/autojump/autojump.fish

    atuin init fish | source

    atuin gen-completions --shell fish | source

    function lsp
        ls -d "$PWD/$argv" | head -c -1
    end

    if test -n "$WAYLAND_DISPLAY"
        alias pwdc='pwd | head -c -1 | wl-copy'
        alias pwdv='cd "$(wl-paste)"'

        function lspc 
            lsp "$argv" | wl-copy
        end

        function lsc
            ls "$argv" | head -c -1 | wl-copy
        end

    else
        alias pwdc='pwd | xsel -ib'
        alias pwdv='cd "$(xsel -ob)"'

        function lspc 
            lsp "$argv" | xsel -ib
        end

        function lsc
            ls "$argv" | head -c -1 | xsel -ib
        end
    end


    function last_history_item
        echo $history[1]
    end
    abbr -a !! --position anywhere --function last_history_item

    source ~/.config/aliases.sh

    alias topcmds='history | awk "{print \$1}" | sort | uniq -c | sort -nr | head -20'

    function doas
        if test "$argv[1]" = 'su' -o "$argv[1]" = 'bash' -o "$argv[1]" = 'fish'
            echo no
        else
            /usr/bin/doas $argv
        end
    end
end

function fish_right_prompt
    set -l cmd_status $status
    if test $cmd_status -ne 0
        echo -n (set_color red)"✘ $cmd_status"
    end
end

function fish_prompt
    if test -n "$SSH_TTY"
        echo -n (set_color brred)"$USER"(set_color white)'@'(set_color yellow)(prompt_hostname)' '
    end

    echo -n (set_color blue)(prompt_pwd)' '

    set_color -o
    if fish_is_root_user
        echo -n (set_color red)'# '
    end
    echo -n (set_color red)'❯'(set_color yellow)'❯'(set_color green)'❯ '
    set_color --reset
end
