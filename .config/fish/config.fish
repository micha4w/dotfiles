if status is-interactive
    if not set -q TMUX && [ "$TERM_PROGRAM" != "vscode" ]
        exec tmux
    end

    fish_add_path -m /usr/local/go/bin/
    fish_add_path -m ~/.local/bin/
    fish_add_path -m ~/.cargo/bin/
    fish_add_path -m ~/.local/kitty.app/bin/

    set -x LC_ALL en_US.UTF-8
    set -x PAGER "/usr/bin/nvim -R"
    set -x MANPAGER "/usr/bin/nvim +Man!"
    set -x MANWIDTH 999
end

fish_add_path -m /home/micha4w/.nvm/versions/node/v19.8.1/bin
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

function fish_user_key_bindings
    bind -M insert \cf forward-char
    bind -M insert \e\x7F backward-kill-word
end

fish_vi_key_bindings

function fish_greeting
end
