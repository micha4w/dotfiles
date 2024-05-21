{ config, pkgs, pkgsStable, flakes, ... }:
{
  imports = [ ./vscode.nix ];

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "CascadiaCode" "DroidSansMono" ]; })
    font-awesome
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
  ];

  programs = {
    hyprland.enable = true;
    fish.enable = true;
    bash = {
      interactiveShellInit = ''
        if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
        then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
        fi

#        if [[ -z ''${WAS_FISH} && -z ''${BASH_EXECUTION_STRING} ]]
#        then
#          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
#          exec ${pkgs.tmux}/bin/tmux -c "${pkgs.fish}/bin/fish $LOGIN_OPTION"
#        fi
      '';
    };
    git.enable = true;
    htop.enable = true;
    tmux = {
      enable = true;
      newSession = true;
    };
    neovim = {
      enable = true;
      # package = pkgs.neovim;
      viAlias = true;
      vimAlias = true;
      withNodeJs = true;
    };
    # wshowkeys.enable = true;
    file-roller.enable = true;
    firefox.enable = true;
    seahorse.enable = true;
  };

  virtualisation = {
    waydroid.enable = true;
    docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
    virtualbox.host = {
      enable = true;
      #enableKvm = true;
    };
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
        swtpm.enable = true;
      };
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      #  pantheon.xdg-desktop-portal-pantheon
    ];
  };
  security = {
    polkit.enable = true;
    pam.services = {
      swaylock = { };
      micha4w.enableGnomeKeyring = true;
    };
    sudo = {
      extraRules = [{
        users = [ "micha4w" ];
        commands = [
          {
            command = "${pkgs.systemd}/bin/systemctl start anyconnect.service";
            options = [ "NOPASSWD" ];
          }
          {
            command = "${pkgs.systemd}/bin/systemctl stop anyconnect.service";
            options = [ "NOPASSWD" ];
          }
          {
            command = "${pkgs.systemd}/bin/systemctl restart anyconnect.service";
            options = [ "NOPASSWD" ];
          }
          {
            command = "${pkgs.systemd}/bin/systemctl status anyconnect.service";
            options = [ "NOPASSWD" ];
          }
        ];
      }];
    };
  };

  environment.systemPackages = with pkgs; [
    hyprpaper
    pyprland
    bibata-cursors
    papirus-icon-theme
    catppuccin
    catppuccin-gtk

    adwaita-qt6
    gnome.adwaita-icon-theme

    brightnessctl
    playerctl
    pamixer
    home-manager
    polkit_gnome

    # ags
    dunst
    pkgsStable.albert
    swaylock
    swayidle
    dart-sass
    libdbusmenu-gtk3

    networkmanagerapplet
    sddm-chili-theme

    grim
    slurp
    swappy
    wl-clipboard
    unzip
    imagemagick

    # Linux
    file
    tldr
    lua
    luajit
    stylua
    ripgrep
    fd
    jq
    gnome.zenity

    wineWowPackages.waylandFull
    quickemu

    ranger
    bat # for ranger coloring

    # cx-master
    clang-tools
    nodePackages.pyright

    python311
    python311Packages.numpy
    python311Packages.scipy
    python311Packages.pygame

    # Coding
    gnumake
    cmake
    ninja
    gccStdenv
    gdb
    meson
    pkg-config
    rustup


    # Apps
    pavucontrol
    gnome.gnome-system-monitor
    alacritty
    cinnamon.nemo-with-extensions
    cinnamon.nemo-fileroller
    cinnamon.pix
    gimp
    prismlauncher

    nixpkgs-fmt
  ];
}
