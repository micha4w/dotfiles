{ config, pkgs, pkgsStable, flakes, ... }:
{

  environment.systemPackages = with pkgs; [
    vscode

    # (vscode-with-extensions.override {
    #   vscodeExtensions = with pkgs.vscode-extensions;
    #     with flakes.nix-vscode-extensions.extensions."${pkgs.system}";
    #     [
    #       eamodio.gitlens
    #
    #       vscodevim.vim
    #       ms-vscode.hexeditor
    #       ms-vscode-remote.remote-ssh
    #       aaron-bond.better-comments
    #       # vscode-marketplace.MS-vsliveshare.vsliveshare
    #
    #       ms-vscode.cpptools
    #       ms-vscode.cmake-tools
    #       ms-vscode.makefile-tools
    #       ms-python.python
    #       ms-pyright.pyright
    #       # ms-python.vscode-pylance
    #
    #       vscode-marketplace.pedro-w.tmlanguage
    #       vadimcn.vscode-lldb
    #       rust-lang.rust-analyzer
    #       twxs.cmake
    #       #bbenoist.nix
    #       jnoortheen.nix-ide
    #       arrterian.nix-env-selector
    #       tamasfe.even-better-toml
    #       svelte.svelte-vscode
    #       vscode-marketplace.mrmlnc.vscode-scss
    #       vscode-marketplace.florianbaer.pb-syntax
    #
    #       streetsidesoftware.code-spell-checker
    #       vscode-marketplace.streetsidesoftware.code-spell-checker-swiss-german
    #       catppuccin.catppuccin-vsc-icons
    #       catppuccin.catppuccin-vsc
    #       vscode-marketplace.mesonbuild.mesonbuild
    #       vscode-marketplace.jeff-hykin.better-cpp-syntax
    #       vscode-marketplace.kuba-p.glsl-lsp
    #       golang.go
    #     ];
    # })
  ];
}
