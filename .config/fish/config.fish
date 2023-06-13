if status is-interactive
    if not set -q TMUX && [ "$TERM_PROGRAM" != "vscode" ] && [ -z "$VSCODE_RESOLVING_ENVIRONMENT" ]
        set UNATTACHED_SESSION_ID (tmux ls -F "#{session_name}|#{?session_attached,attached,not attached}" | grep "not attached\$" | tail -n 1 | cut -d '|' -f1)

        if [ -n "$UNATTACHED_SESSION_ID" ]
            exec tmux attach -t $UNATTACHED_SESSION_ID
        else
            exec tmux
        end
    end

    set -x LC_ALL en_US.UTF-8
    set -x PAGER "/usr/bin/nvim -R"
    set -x MANPAGER "/usr/bin/nvim +Man!"
    set -x MANWIDTH 999
end


fish_add_path -m /usr/local/go/bin/
fish_add_path -m ~/.local/bin/
fish_add_path -m ~/.cargo/bin/
fish_add_path -m ~/.local/kitty.app/bin/
fish_add_path -m /opt/gradle/bin/

fish_add_path -m /home/micha4w/.nvm/versions/node/v19.8.1/bin
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias antlr4='java -jar ~/.m2/repository/org/antlr/antlr4/4.12.0/antlr4-4.12.0-complete.jar'

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

fish_vi_key_bindings

function fish_greeting
end
