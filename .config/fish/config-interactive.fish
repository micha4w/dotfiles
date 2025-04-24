alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias ls='ls -Ah --color'

function bind_bang
    switch (commandline --current-token)[-1]
    case "!"
        commandline --current-token -- $history[1]
        commandline --function repaint
    case "*"
        commandline --insert !
    end
end

function fish_user_key_bindings
    bind -M insert \cf forward-char
    bind -M insert \e\x7F backward-kill-word

    bind -M insert ! bind_bang
end

function color
    # fish -c "$argv" 2>| begin; set_color red; cat; end >&2
    bash -c "fish -c '$argv' 2> >(sed \$'s,.*,\e[31m&\e[m,'>&2)"
end

function activate_direnv
    fish -C "direnv hook fish | source"
end

fish_vi_key_bindings
set fish_cursor_default block
set fish_cursor_insert line
set fish_cursor_replace_one underscore

function fish_greeting
end
