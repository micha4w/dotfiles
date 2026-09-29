{ config, pkgs, pkgsStable, flakes, ... }:
  let
    user = "micha4w";
  in
{
  catppuccin = {
    flavor = "mocha";
    accent = "maroon";

    plymouth.enable = true;
    tty.enable = true;
  };

  users = {
    users.${user} = {
      isNormalUser = true;
      initialPassword = "passWORD?";
      extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" "vboxusers" "libvirtd" "i2c" "dialout" "wireshark" ];
      shell = pkgs.fish;
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${user} = {
      imports = [
        flakes.ags.homeManagerModules.default
        # flakes.anyrun.homeManagerModules.default
        flakes.catppuccin.homeModules.catppuccin
      ];

      wayland.windowManager.hyprland = {
        enable = true;
        # catppuccin.enable = true;
        package = flakes.hyprland.packages.${pkgs.system}.default;
        # configType = "lua";
        configType = "hyprlang";
        settings = {
          source = [ "~/.config/hypr/hyprland-user.conf" ];
          env = [ "NIXOS_OZONE_WL,1" ];
        };
        # extraConfig = ''
        #   require("hyprland-user.conf")
        # '';
        plugins = [
          # hyprsplit.packages.${pkgs.system}.default
          # flakes.split-monitor-workspaces.packages.${pkgs.system}.default
          flakes.hypr-darkwindow.packages.${pkgs.system}.Hypr-DarkWindow
          # flakes.hyprland-plugins.packages.${pkgs.system}.hyprexpo
        ];
      };

      services.kanshi = {
        enable = true;
        profiles = {
          undocked = {
            outputs = [
              {
                criteria = "eDP-1";
                position = "0,0";
                scale = 1.2;
              }
              # { criteria = "*"; }
            ];
          };
          papa = {
            outputs = [
              {
                criteria = "eDP-1";
                position = "0,0";
                scale = 1.2;
              }
              {
                criteria = "Dell Inc. DELL P2720D C178643";
                position = "-2400,-512";
                scale = 1.066;
              }
              {
                criteria = "Dell Inc. DELL P2720D JV69F99J07US";
                position = "-4800,-512";
                scale = 1.066;
              }
            ];
          };
          gaming = {
            outputs = [
              {
                criteria = "eDP-1";
                position = "0,0";
                scale = 1.2;
              }
              {
                criteria = "Samsung Electric Company Odyssey G65B H1AK500000";
                position = "1600,0";
              }
              {
                criteria = "BNQ BenQ XL2410T 2BB01461SL0";
                position = "4160,600";
              }
            ];
          };
          gaming2 = {
            outputs = [
              {
                criteria = "eDP-1";
                position = "0,0";
                scale = 1.2;
              }
              {
                criteria = "Samsung Electric Company Odyssey G65B H1AK500000";
                position = "1600,0";
              }
            ];
          };
        };
      };

      home = {
        username = "${user}";
        homeDirectory = "/home/${user}";
        sessionVariables = {

          LC_ALL = "en_US.UTF-8";
          # PAGER "nvim";
          PAGER = "less";
          MANPAGER = "nvim +Man!";
          MANWIDTH = 999;
          EDITOR = "nvim";
          PLATFORMIO_CORE_DIR = "/home/${user}/.local/share/platformio";
          PYTHON_BASIC_REPL = 1;
        };
        packages = with pkgs; [
          grc
        ];
        pointerCursor = {
          enable = true;
          name = "Bibata-Modern-Classic";
          size = 20;
          package = pkgs.bibata-cursors;

          gtk.enable = true;
          dotIcons.enable = true;
          hyprcursor.enable = true;
          x11.enable = true;
        };
      };

      catppuccin = {
        # gtk.enable = true;
        kvantum = {
          enable = true;
          apply = true;
        };
      };

      xdg = {
        enable = true;
        cacheHome = "/home/${user}/.local/cache";
      };
      
      dconf.settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
        };
      };

      gtk = let
        gtkThemeNoBackdrop = {
          name = "Adwaita-dark";
          package = import ./packages/remove-gtk-backdrop { inherit pkgs; theme = pkgs.gnome-themes-extra; };
        };
      in {
        enable = true;

        theme = gtkThemeNoBackdrop;
        gtk4.theme = gtkThemeNoBackdrop;
        colorScheme = "dark";

        iconTheme = {
          package = pkgs.papirus-icon-theme;
          name = "Papirus-Dark";
        };
      };

      qt = {
        enable = true;
        platformTheme.name = "kvantum";
        style.name = "kvantum";
      };

      programs = {
        ags = {
          enable = true;
        };
        fish = {
          enable = true;
          plugins = [
            { name = "grc"; src = pkgs.fishPlugins.grc.src; }
          ];
          # shellInit = ''
          #   export WAS_FISH=1
          # '';
          interactiveShellInit = ''
            # set NIX_BUILD_SHELL '${ (pkgs.callPackage ./packages/fish-nix-shell.nix { }) }/bin/fish-nix-shell'

            ${pkgs.any-nix-shell}/bin/any-nix-shell fish | source
            # --info-right 
            source ~/.config/fish/config-interactive.fish
          '';
        };
        # anyrun = {
        #   enable = true;
        #   config = {
        #     plugins = [
        #       flakes.anyrun.packages.${pkgs.system}.applications
        #       flakes.anyrun.packages.${pkgs.system}.rink
        #       flakes.anyrun.packages.${pkgs.system}.shell
        #       flakes.anyrun.packages.${pkgs.system}.symbols
        #       flakes.anyrun.packages.${pkgs.system}.dictionary
        #       flakes.anyrun-shell-shortcuts.packages.${pkgs.system}.default
        #     ];
        #     x.fraction = 0.5;
        #     y.fraction = 0.5;
        #     width.absolute = 500;
        #     height.absolute = 500;
        #     ignoreExclusiveZones = true;
        #     #                      hideIcons = false;
        #     #                      layer = "overlay";
        #     #                      hidePluginInfo = false;
        #     closeOnClick = true;
        #     #                      showResultsImmediately = false;
        #     #                      maxEntries = null;
        #   };
        #   extraCss = ''@import url("anyrun.css");'';
        # };
      };

      systemd.user.services.onedriver = {
        Unit = {
          Description = "OneDriver";
          After = [ "network-online.target" ];
          Wants = [ "network-online.target" ];
        };

        Service = {
          ExecStart = "${pkgs.onedriver}/bin/onedriver /home/micha4w/OneDrive/";
          Restart = "on-failure";
        };

        Install = {
          # WantedBy = [ "default.target" ];
        };
      };

      home.stateVersion = "23.11";
    };
  };
}
