# dotfiles
Dotfiles first edition

## Installing
You need to install fish, nvim and tmux yourself

```sh
# Install AstroNvim
git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim

# Clone this repo
cd ~
git init --bare .dotfiles
cd .dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dotfiles remote add origin git@github.com:micha4w/dotfiles.git
dotfiles pull --set-upstream origin main
dotfiles submodule init
dotfiles submodule update

# Set your shell
chsh -s /usr/bin/fish
```

If you now restart your Terminal, you should be spawned in a tmux session running fish! Do Shift-F1 + I do install tmux plugins
For max customization, run fish_conifig and remap Shift-Space to Shift-F1 in your Terminal Emulator.

## Other important Stuff
- [Fisher](https://github.com/jorgebucaran/fisher)
- [nvm.fish](https://github.com/jorgebucaran/nvm.fish)

### Firefox
Firefox has some terrible default settings?

in about:preferences enable `Allow pages to choose their own fonts`
in about:config enable `media.ffmpeg.vaapi.enabled`

