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
      extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" "vboxusers" "docker" "libvirtd" "i2c" "dialout" "wireshark" ];
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
        flakes.catppuccin.homeManagerModules.catppuccin
      ];

      wayland.windowManager.hyprland = {
        enable = true;
        # catppuccin.enable = true;
        package = flakes.hyprland.packages.${pkgs.system}.default;
        settings = {
          source = [ "~/.config/hypr/hyprland-user.conf" ];
          env = [ "NIXOS_OZONE_WL,1" ];
        };
        plugins = [
          # hyprsplit.packages.${pkgs.system}.default
          # flakes.split-monitor-workspaces.packages.${pkgs.system}.default
          flakes.hypr-darkwindow.packages.${pkgs.system}.Hypr-DarkWindow
          # flakes.hyprland-plugins.packages.${pkgs.system}.hyprexpo
        ];
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
        };
        packages = with pkgs; [
          grc
        ];
      };

      catppuccin = {
        gtk.enable = true;
        kvantum = {
          enable = true;
          apply = true;
        };
      };

      xdg = {
        enable = true;
        cacheHome = "/home/${user}/.local/cache";
      };

      gtk = {
        enable = true;
        cursorTheme = {
          name = "Bibata-Modern-Classic";
          size = 20;
        };
        iconTheme = {
          package = pkgs.papirus-icon-theme.override {
            withElementary = true;
          };
          name = "ePapirus-Dark";
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

      home.stateVersion = "23.11";
    };
  };
}
