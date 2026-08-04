function apply_theme
    set --global fish_color_autosuggestion BD93F9
    set --global fish_color_cancel --reverse
    set --global fish_color_command F8F8F2
    set --global fish_color_comment 6272A4
    set --global fish_color_cwd green
    set --global fish_color_cwd_root red
    set --global fish_color_end 50FA7B
    set --global fish_color_error FFB86C
    set --global fish_color_escape 00a6b2
    set --global fish_color_history_current --bold
    set --global fish_color_host normal
    set --global fish_color_host_remote
    set --global fish_color_keyword
    set --global fish_color_match --background=brblue
    set --global fish_color_normal normal
    set --global fish_color_operator 00a6b2
    set --global fish_color_option
    set --global fish_color_param FF79C6
    set --global fish_color_quote F1FA8C
    set --global fish_color_redirection 8BE9FD
    set --global fish_color_search_match white --background=brblack
    set --global fish_color_selection white --bold --background=brblack
    set --global fish_color_status red
    set --global fish_color_user brgreen
    set --global fish_color_valid_path --underline
    set --global fish_pager_color_background
    set --global fish_pager_color_completion normal
    set --global fish_pager_color_description B3A06D
    set --global fish_pager_color_prefix normal --bold --underline
    set --global fish_pager_color_progress brwhite --background=cyan
    set --global fish_pager_color_secondary_background
    set --global fish_pager_color_secondary_completion
    set --global fish_pager_color_secondary_description
    set --global fish_pager_color_secondary_prefix
    set --global fish_pager_color_selected_background --background=brblack
    set --global fish_pager_color_selected_completion
    set --global fish_pager_color_selected_description
    set --global fish_pager_color_selected_prefix
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

if status is-interactive
    set fish_greeting
    apply_theme

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
