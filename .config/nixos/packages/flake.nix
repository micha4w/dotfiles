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
      packages.default = pkgs.stdenv.mkDerivation {
        name = "brightnessctl";

        src = "${flakes.brightnessctl}";

        postPatch = ''
          substituteInPlace Makefile \
            --replace "pkg-config" "$PKG_CONFIG"
        '';

        makeFlags = [ "PREFIX=" "DESTDIR=$(out)" "ENABLE_LOGIND=1" "HAVE_LIBSYSTEMD=1" ];

        nativeBuildInputs = with pkgs; [ pkg-config ];
        buildInputs = with pkgs; [ systemd ];
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
    hyprutils = {
      url = "git+https://github.com/hyprwm/hyprutils";
    };
    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?rev=918d8340afd652b011b937d29d5eea0be08467f5&submodules=1";
      inputs.hyprutils.follows = "hyprutils";
    };
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces?rev=81adb1c51b2db8a9073dd24f8ac3cb23c9d96dac";
      inputs.hyprland.follows = "hyprland";
    };
    #    hyprsplit = {
    #      url = "github:shezdy/hyprsplit?rev=fd31d08d2f9756ba487541a4d2f5a2cbf0eb16aa";
    #      inputs.hyprland.follows = "hyprland";
    #    };
    hypr-darkwindow = {
      url = "github:micha4w/Hypr-DarkWindow?ref=v0.41.1";
      inputs.hyprland.follows = "hyprland";
    };
    # hyprland-plugins = {
    #   url = "github:hyprwm/hyprland-plugins?rev=8571aa9badf7db9c4911018a5611c038cc776256";
    #   inputs.hyprland.follows = "hyprland";
    # };

    nxBender.url = "github:micha4w/nxBender";
    ags.url = "github:Aylur/ags?ref=v1.8.2";
    anyrun.url = "github:anyrun-org/anyrun";
    anyrun-shell-shortcuts.url = "github:micha4w/anyrun-shell-shortcuts";
    brightnessctl =  {
      url = "github:Hummer12007/brightnessctl";
      flake = false;
    };
    catppuccin.url = "github:catppuccin/nix";
    watershot = {
      url = "github:Kirottu/watershot?ref=v0.2.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}

