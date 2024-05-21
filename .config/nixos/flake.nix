{

  outputs =
    flakes@{ self
    , nixpkgs
    , nixpkgsStable
    , ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations = {
        inf-thinkpad = nixpkgs.lib.nixosSystem {
          system = "${pkgs.system}";
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
                ./hardware-configuration.nix
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
    nixpkgsStable.url = "github:NixOS/nixpkgs/nixos-23.11";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland?ref=v0.40.0";
    };
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces?rev=b40147d96d62a9e9bbc56b18ea421211ee598357";
      inputs.hyprland.follows = "hyprland";
    };
    #    hyprsplit = {
    #      url = "github:shezdy/hyprsplit?rev=fd31d08d2f9756ba487541a4d2f5a2cbf0eb16aa";
    #      inputs.hyprland.follows = "hyprland";
    #    };
    hypr-darkwindow = {
      url = "github:micha4w/Hypr-DarkWindow?ref=v0.40.0";
      inputs.hyprland.follows = "hyprland";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins?rev=18daf37b7c4e6e51ca2bf8953ce4cff1c38ca725";
      inputs.hyprland.follows = "hyprland";
    };

    nxBender.url = "github:micha4w/nxBender";
    ags.url = "github:Aylur/ags?ref=v1.8.2";
    anyrun.url = "github:anyrun-org/anyrun";
    catppuccin.url = "github:catppuccin/nix";
    watershot = {
      url = "github:Kirottu/watershot?ref=v0.2.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}

