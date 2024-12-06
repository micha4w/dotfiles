set IS_TTY (tty | grep '/dev/tty')

function fish_prompt --description 'Write out the prompt'
    set -l laststatus $status

    if [ -n "$IS_TTY" ]
        set -f FISH_STATUS_BEGIN '<'
        set -f FISH_STATUS_SEPERATOR '|'
        set -f FISH_STATUS_END '>'

        set -f FISH_GIT_UP '↑'
        set -f FISH_GIT_DOWN '↓'
        set -f FISH_GIT_PLUS  '+'
        set -f FISH_GIT_X     'x'
        set -f FISH_GIT_STAR  '*'
        set -f FISH_GIT_RIGHT '→'
        set -f FISH_GIT_EQ    '='
        set -f FISH_GIT_NEQ   '!='

        set -f FISH_STATUS_NIX '*'
        set -f FISH_STATUS_SUCCESS
        set -f FISH_STATUS_FAILURE 'x'

        set -f FISH_PROMPT_END ' »'
    else
        set -f FISH_STATUS_BEGIN '❰'
        set -f FISH_STATUS_SEPERATOR '❙'
        set -f FISH_STATUS_END '❱'

        set -f FISH_GIT_UP '⬆'
        set -f FISH_GIT_DOWN '⬇'
        set -f FISH_GIT_PLUS  '✚'
        set -f FISH_GIT_X     '✖'
        set -f FISH_GIT_STAR  '✱'
        set -f FISH_GIT_RIGHT '➜'
        set -f FISH_GIT_EQ    '═'
        set -f FISH_GIT_NEQ   '≠'

        set -f FISH_STATUS_NIX ''
        set -f FISH_STATUS_SUCCESS '✔'
        set -f FISH_STATUS_FAILURE '✘'

        set -f FISH_PROMPT_END '≻'
    end

    set -l git_info
    if set -l git_branch (command git symbolic-ref HEAD 2>/dev/null | string replace refs/heads/ '')
        set git_branch (set_color -o blue)"$git_branch"
        set -l git_status
        if not command git diff-index --quiet HEAD --
            if set -l count (command git rev-list --count --left-right $upstream...HEAD 2>/dev/null)
                echo $count | read -l ahead behind
                if test "$ahead" -gt 0
                    set git_status "$git_status"(set_color red)$FISH_GIT_UP
                end
                if test "$behind" -gt 0
                    set git_status "$git_status"(set_color red)$FISH_GIT_DOWN
                end
            end
            for i in (git status --porcelain | string sub -l 2 | sort | uniq)
                switch $i
                    case "."
                        set git_status "$git_status"(set_color green)FISH_GIT_X
                    case " D"
                        set git_status "$git_status"(set_color red)FISH_GIT_PLUS
                    case "*M*"
                        set git_status "$git_status"(set_color green)FISH_GIT_STAR
                    case "*R*"
                        set git_status "$git_status"(set_color purple)FISH_GIT_RIGHT
                    case "*U*"
                        set git_status "$git_status"(set_color brown)FISH_GIT_EQ
                    case "??"
                        set git_status "$git_status"(set_color red)FISH_GIT_NEQ
                end
            end
        else
            set git_status (set_color green):
        end
        set git_info "(git$git_status$git_branch"(set_color white)")"
    end

    set -l nix_shell_info (
      if test -n "$IN_NIX_SHELL"
        echo -n (set_color blue)" "
      end
    )

    # Disable PWD shortening by default.
    set -q fish_prompt_pwd_dir_length
    or set -lx fish_prompt_pwd_dir_length 0

    set_color -b black
    printf '%s%s%s%s%s%s%s%s%s%s%s%s%s' (set_color -o white) $FISH_STATUS_BEGIN (set_color green) $USER (set_color white) $FISH_STATUS_SEPERATOR (set_color yellow) (prompt_pwd) (set_color white) $git_info (set_color white) $FISH_STATUS_END (set_color white)
    if test $laststatus -eq 0
        echo -n (set_color -o green)$FISH_STATUS_SUCCESS
    else
        echo -n (set_color -o red)$FISH_STATUS_FAILURE
    end
    printf "%s%s$FISH_PROMPT_END%s " $nix_shell_info (set_color white) (set_color normal)
end
