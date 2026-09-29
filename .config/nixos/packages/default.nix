{config, pkgs, pkgsStable, flakes, system, ... }@inputs:
{
  imports = [ ./vscode.nix ];

  fonts = {
    packages = with pkgs; [
      nerd-fonts.caskaydia-mono
      nerd-fonts.droid-sans-mono
      font-awesome
      noto-fonts
      noto-fonts-color-emoji
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
        libX11
        libXext
        libxcb
        libdrm
        chromium

        libusb1 glib.out krb5.lib ncurses5 udev
      ];
    };
    # command-not-found.enable = true;
    nix-index.enable = true;
    direnv = {
      enable = true;
      enableFishIntegration = false;
      nix-direnv.enable = true;
    };
    appimage = {
      enable = true;
      binfmt = true;
    };
    hyprland.enable = true;
    hyprlock = {
      enable = true;
      # package = flakes.hyprlock.packages.${system}.hyprlock;
    };
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
    git = {
        enable = true;
        lfs.enable = true;
    };
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
    firefox = {
      enable = true;
      autoConfig = /* js */ ''
        // First line must be a comment
        const attachKeybindings = (win) => {
          const urlbar = win.document.getElementById("urlbar-input");
          if (!urlbar) return;

          urlbar.addEventListener("keydown", (e) => {
            if (e.ctrlKey && e.key.toLowerCase() === "j") {
              e.preventDefault();
              e.stopImmediatePropagation();
              urlbar.dispatchEvent(new win.KeyboardEvent("keydown", {
                key: "ArrowDown",
                code: "ArrowDown",
                keyCode: 40,
                bubbles: true,
                cancelable: true
              }));
            } else if (e.ctrlKey && e.key.toLowerCase() === "k") {
              e.preventDefault();
              e.stopImmediatePropagation();
              urlbar.dispatchEvent(new win.KeyboardEvent("keydown", {
                key: "ArrowUp",
                code: "ArrowUp",
                keyCode: 38,
                bubbles: true,
                cancelable: true
              }));
            }
          }, true); // Capture phase ensures we intercept before Firefox's default Ctrl+J / Ctrl+K handlers
        };

        const delayedStartupObserver = (subject, topic) => {
          if (topic !== "browser-delayed-startup-finished") return;

          try {
          // Services.obs.removeObserver(delayedStartupObserver, topic);
            attachKeybindings(subject);
          } catch (e) {
            Cu.reportError(e);
          }
        };

        try {
          Services.obs.addObserver(delayedStartupObserver, "browser-delayed-startup-finished");
        } catch (e) {
          Cu.reportError(e);
        }
      '';
    };
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
      enableKvm = true;
      addNetworkInterface = false;
      package = pkgsStable.virtualbox;
    };
    # libvirtd = {
    #   enable = true;
    #   qemu = {
    #     # smaller than normal qemu
    #     package = pkgs.qemu_kvm; #.override { smbdSupport = true; };
    #     # package = pkgs.qemu; #.override { smbdSupport = true; };
    #     # ovmf.packages = [ pkgs.OVMFFull.fd ];
    #     swtpm.enable = true;
    #   };
    # };
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

  systemd.user.tmpfiles.rules = [
    "d %h/.local/share/LTspice 0755 - - -"
    "L+ %h/.local/share/LTspice/lib - - - - %h/.local/share/ltspice/drive_c/users/%u/AppData/Local/LTspice/lib"
  ];

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
    (wineWow64Packages.stableFull.override { waylandSupport = true; })
    # (wineWow64Packages.unstableFull.overrideAttrs (oldAttrs: {
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
    mpremote
    mypy

    # Coding
    gnumake
    cmake
    ninja
    gcc
    mold
    gdb
    meson
    pkg-config
    rustup
    lldb
    platformio-core
    go
    pi-coding-agent

    nil
    nixd
    nixfmt
    tree-sitter

    # Apps
    kicad
    ltspice

    pavucontrol
    gnome-system-monitor
    alacritty
    nemo-with-extensions
    # nemo-fileroller
    pix
    gimp
    pkgsStable.krita
    prismlauncher
    # android-studio
    tigervnc
    inkscape
    usbutils
    xmoto
    file-roller
    gparted

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
