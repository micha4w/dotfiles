{
  outputs =
    flakes@{ self
    , nixpkgs
    , nixpkgsStable
    , ...
    }:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        inf-thinkpad = nixpkgs.lib.nixosSystem {
          system = "${system}";
          specialArgs = {
            inherit flakes;

            pkgsStable = import nixpkgsStable {
              config.allowUnfree = true;
              localSystem = { inherit system; };
            };
          };

          modules = [
            flakes.catppuccin.nixosModules.catppuccin
            flakes.home-manager.nixosModules.home-manager
            {
              imports = [
                ./hardware-configuration-thinkpad.nix
                ./vpns
                ./packages
                ./micha4w.nix
                ./nix.nix
                ./system.nix
              ];

              system.stateVersion = "23.11";
            }
          ];
        };
      };
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgsStable.url = "github:NixOS/nixpkgs/nixos-24.05";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
#    hyprwayland-scanner = {
#      # url = "git+https://github.com/hyprwm/Hyprland?rev=9a09eac79b85c846e3a865a9078a3f8ff65a9259&submodules=1";
#      url = "git+https://github.com/hyprwm/hyprwayland-scanner?ref=refs/tags/v0.4.0";
#    };
    aquamarine = {
      url = "github:hyprwm/aquamarine?ref=v0.4.4";
    };
    hyprland = {
      # url = "git+https://github.com/hyprwm/Hyprland?rev=9a09eac79b85c846e3a865a9078a3f8ff65a9259&submodules=1";
      url = "git+https://github.com/hyprwm/Hyprland?ref=refs/tags/v0.45.2&submodules=1";
      # inputs.hyprwayland-scanner.follows = "hyprwayland-scanner";
      inputs.aquamarine.follows = "aquamarine";
    };
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces?rev=131bc5bd02d7f558a66d1a6c4d0013d8545823e0";
      inputs.hyprland.follows = "hyprland";
    };
    #    hyprsplit = {
    #      url = "github:shezdy/hyprsplit?rev=fd31d08d2f9756ba487541a4d2f5a2cbf0eb16aa";
    #      inputs.hyprland.follows = "hyprland";
    #    };
    hypr-darkwindow = {
      url = "github:micha4w/Hypr-DarkWindow?ref=v0.45.0";
      inputs.hyprland.follows = "hyprland";
    };
    # hyprland-plugins = {
    #   url = "github:hyprwm/hyprland-plugins?rev=8571aa9badf7db9c4911018a5611c038cc776256";
    #   inputs.hyprland.follows = "hyprland";
    # };

    nxBender.url = "github:micha4w/nxBender";
    ags.url = "github:Aylur/ags?ref=v1.8.2";
#    anyrun.url = "github:anyrun-org/anyrun";
#    anyrun-shell-shortcuts.url = "github:micha4w/anyrun-shell-shortcuts";
    brightnessctl =  {
      url = "github:Hummer12007/brightnessctl";
      flake = false;
    };
    catppuccin.url = "github:catppuccin/nix";
#    watershot = {
#      url = "github:Kirottu/watershot?ref=v0.2.2";
#      inputs.nixpkgs.follows = "nixpkgs";
#    };
  };
}
