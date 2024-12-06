{ config, pkgs, pkgsStable, flakes, kernel, ... }@inputs:
{
  imports = [ ./vscode.nix ];

  fonts = {
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "CascadiaCode" "DroidSansMono" ]; })
      font-awesome
      noto-fonts
      noto-fonts-emoji
      liberation_ttf
    ];

    fontconfig = {
      defaultFonts = {
        serif = [  "Noto Serif" "Noto Color Emoji" ];
        sansSerif = [ "Noto Sans" "Noto Color Emoji" ];
        monospace = [ "Noto Sans Mono" "Noto Color Emoji" ];
      };
    };
  };

  programs = {
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        xorg.libX11
        xorg.libXext
        xorg.libxcb
        libdrm
        chromium

        libusb1 glib.out krb5.lib ncurses5 udev
      ];
    };
    direnv = {
      enable = true;
      enableFishIntegration = false;
      nix-direnv.enable = true;
    };
    hyprland.enable = true;
    fish.enable = true;
    wireshark.enable = true;
#     bash = {
#       interactiveShellInit = ''
#         if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
#         then
#           shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
#           exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
#         fi
#
# #        if [[ -z ''${WAS_FISH} && -z ''${BASH_EXECUTION_STRING} ]]
# #        then
# #          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
# #          exec ${pkgs.tmux}/bin/tmux -c "${pkgs.fish}/bin/fish $LOGIN_OPTION"
# #        fi
#       '';
#     };
    git.enable = true;
    htop.enable = true;
    tmux = {
      enable = true;
      newSession = false;
      baseIndex = 1;
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
      enableOnBoot = false;
#      rootless = {
#        enable = true;
#        setSocketVariable = true;
#      };
    };
    virtualbox.host = {
      enable = true;
      #enableKvm = true;
    };
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm; #.override { smbdSupport = true; };
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
          {
            command = "${pkgs.callPackage ./windows_reboot {}}/bin/windows_reboot";
            options = [ "NOPASSWD" ];
          }
        ];
      }];
    };
  };

  environment.systemPackages = with pkgs; [
    any-nix-shell

    hyprpaper
    pyprland
    bibata-cursors
    papirus-icon-theme
    catppuccin
    catppuccin-gtk

    albert

    config.boot.kernelPackages.cpupower
    (pkgs.callPackage ./brightnessctl.nix { inherit flakes; })
    ddcutil
    playerctl
    pamixer
    home-manager
    polkit_gnome

    # ags
    dunst
    swaylock
    swayidle
    dart-sass
    bun
    libdbusmenu-gtk3

    networkmanagerapplet
    sddm-chili-theme

    grim
    slurp
    swappy
    wl-clipboard
    xclip # for wine
    unzip
    zip
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
    jc
    libnotify
    fzf
    zenity
    (wineWowPackages.unstableFull.override { waylandSupport = true; })
    # (wineWowPackages.unstableFull.overrideAttrs (oldAttrs: {
    #   buildInputs = oldAttrs.buildInputs ++ [ samba ];
    # }))
    wireshark

    quickemu
    verible

    ranger
    bat # for ranger coloring

    # cx-master
    clang-tools
    pyright

    python3
    python3Packages.numpy
    python3Packages.scipy
    python3Packages.pygame

    # Coding
    gnumake
    cmake
    ninja
    gcc
    gdb
    meson
    pkg-config
    rustup
    platformio-core


    # Apps
    pavucontrol
    gnome-system-monitor
    alacritty
    nemo-with-extensions
    # nemo-fileroller
    pix
    gimp
    prismlauncher
    android-studio
    libreoffice-qt-fresh

    nixpkgs-fmt

    
    (pkgs.writeShellApplication {
      name = "windows_reboot";
      text = "sudo ${pkgs.callPackage ./windows_reboot {}}/bin/windows_reboot";
    })

    (pkgs.writeShellApplication {
      name = "xdg-terminal-exec";
      runtimeInputs = with pkgs; [ alacritty ];
      text = "exec alacritty -e \"$@\"";
    })
  ];
}
