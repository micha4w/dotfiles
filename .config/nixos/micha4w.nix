{ config, pkgs, pkgsStable, flakes, ... }:
  let
    user = "micha4w";
  in
{
  catppuccin.flavour = "mocha";
  catppuccin.accent = "maroon";

  users = {
    users.${user} = {
      isNormalUser = true;
      initialPassword = "passWORD?";
      extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" "vboxusers" "docker" "libvirtd" ];
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${user} = {
      imports = [
        flakes.ags.homeManagerModules.default
        flakes.anyrun.homeManagerModules.default
        flakes.catppuccin.homeManagerModules.catppuccin
      ];

      wayland.windowManager.hyprland = {
        enable = true;
        catppuccin.enable = true;
        package = flakes.hyprland.packages.${pkgs.system}.default;
        settings = {
          source = [ "~/.config/hypr/hyprland-nix.conf" ];
        };
        plugins = [
          flakes.split-monitor-workspaces.packages.${pkgs.system}.default
          # hyprsplit.packages.${pkgs.system}.default
          flakes.hypr-darkwindow.packages.${pkgs.system}.Hypr-DarkWindow
          flakes.hyprland-plugins.packages.${pkgs.system}.hyprexpo
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
        };
        packages = with pkgs; [
          grc
        ];
      };

      xdg = {
        enable = true;
        cacheHome = "/home/${user}/.local/cache";
      };

      gtk = {
        enable = true;
        catppuccin.enable = true;
        cursorTheme = {
          name = "Bibata-Modern-Classic";
          size = 18;
        };
        iconTheme.name = "ePapirus-Dark";
      };

      qt = {
        enable = true;
        platformTheme.name = "qtct";
        style.name = "adwaita-dark";
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
          shellInit = ''
            export WAS_FISH=1
          '';
          interactiveShellInit = ''
            source ~/.config/fish/config-interactive.fish
          '';
        };
        anyrun = {
          enable = true;
          config = {
            plugins = [
              # An array of all the plugins you want, which either can be paths to the .so files, or their packages
              # flakes.anyrun.packages.${pkgs.system}.anyrun-with-all-plugins

              flakes.anyrun.packages.${pkgs.system}.applications
              # "${flakes.anyrun.packages.${pkgs.system}.anyrun-with-all-plugins}/lib/libapplications.so"
              "${flakes.anyrun.packages.${pkgs.system}.anyrun-with-all-plugins}/lib/libsymbols.so"
              "${flakes.anyrun.packages.${pkgs.system}.anyrun-with-all-plugins}/lib/librink.so"
              "${flakes.anyrun.packages.${pkgs.system}.anyrun-with-all-plugins}/lib/libshell.so"
              "${flakes.anyrun.packages.${pkgs.system}.anyrun-with-all-plugins}/lib/libdictionary.so"

              # libwebsearch.so
              # libstdin.so
            ];
            x.fraction = 0.5;
            y.fraction = 0.3;
            width.absolute = 500;
            height.absolute = 500;
            ignoreExclusiveZones = true;
            #                      hideIcons = false;
            #                      layer = "overlay";
            #                      hidePluginInfo = false;
            #                      closeOnClick = false;
            #                      showResultsImmediately = false;
            #                      maxEntries = null;
          };
          # extraCss = '' '';

          # extraConfigFiles."some-plugin.ron".text = ''
          #   Config(
          #     // for any other plugin
          #     // this file will be put in ~/.config/anyrun/some-plugin.ron
          #     // refer to docs of xdg.configFile for available options
          #   )
          # '';
        };
      };

      home.stateVersion = "23.11";
    };
  };
}
