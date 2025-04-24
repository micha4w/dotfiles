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
            inherit system;

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
                "${flakes.nixos-hardware}/lenovo/thinkpad/p14s/intel/default.nix"
                ./hardware-configuration-thinkpad.nix
                ./vpns
                ./packages
                ./micha4w.nix
                ./nix.nix
                ./system.nix
              ];

              services.throttled.enable = true;

              system.stateVersion = "23.11";
            }
          ];
        };
      };
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgsStable.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # hyprwayland-scanner = {
    #   # url = "git+https://github.com/hyprwm/Hyprland?rev=9a09eac79b85c846e3a865a9078a3f8ff65a9259&submodules=1";
    #   url = "git+https://github.com/hyprwm/hyprwayland-scanner?ref=refs/tags/v0.4.0";
    # };
    # aquamarine = {
    #   url = "github:hyprwm/aquamarine?ref=v0.4.4";
    # };
    # hyprutils = {
    #   url = "github:hyprwm/hyprutils?ref=v0.5.0";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    hyprland = {
      # url = "git+https://github.com/hyprwm/Hyprland?rev=9a09eac79b85c846e3a865a9078a3f8ff65a9259&submodules=1";
      url = "git+https://github.com/hyprwm/Hyprland?ref=refs/tags/v0.48.1&submodules=1";
      # inputs.hyprwayland-scanner.follows = "hyprwayland-scanner";
      # inputs.aquamarine.follows = "aquamarine";
      # inputs.hyprutils.follows = "hyprutils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # split-monitor-workspaces = {
    #   url = "github:Duckonaut/split-monitor-workspaces?rev=1d4742b30aa9f3d01ea227a9c726985ffa832368";
    #   inputs.hyprland.follows = "hyprland";
    # };
    #    hyprsplit = {
    #      url = "github:shezdy/hyprsplit?rev=fd31d08d2f9756ba487541a4d2f5a2cbf0eb16aa";
    #      inputs.hyprland.follows = "hyprland";
    #    };
    hypr-darkwindow = {
      url = "github:micha4w/Hypr-DarkWindow?ref=v0.48.1";
      inputs.hyprland.follows = "hyprland";
    };
    # hyprlock = {
    #   url = "github:micha4w/hyprlock";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # hyprland-plugins = {
    #   url = "github:hyprwm/hyprland-plugins?rev=8571aa9badf7db9c4911018a5611c038cc776256";
    #   inputs.hyprland.follows = "hyprland";
    # };

    nxBender = {
      url = "github:micha4w/nxBender";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags = {
      url = "github:Aylur/ags?ref=v1.8.2";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
#    anyrun.url = "github:anyrun-org/anyrun";
#    anyrun-shell-shortcuts.url = "github:micha4w/anyrun-shell-shortcuts";
    brightnessctl =  {
      url = "github:Hummer12007/brightnessctl";
      flake = false;
    };
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
#    watershot = {
#      url = "github:Kirottu/watershot?ref=v0.2.2";
#      inputs.nixpkgs.follows = "nixpkgs";
#    };
  };
}
