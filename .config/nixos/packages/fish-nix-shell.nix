{ pkgs }:
  pkgs.writeScriptBin "fish-nix-shell"
    ''
      #!${pkgs.bashInteractive}/bin/bash

      # when using nix-shell, we will be invoked like this:
      #
      #     /path/to/result --rcfile /path/to/file
      #
      # When using nix-shell -i, we will be invoked like this:
      #
      #     /path/to/result /path/to/file
      #
      # We use the presence of --rcfile to decide if we're supposed
      # to be run interactively or not.

      if [[ "$1" = "--rcfile" ]]; then
        rcfile="$2"
        # shellcheck source=/dev/null
        source "$rcfile"

        exec ${pkgs.fish}/bin/fish
      else
        exec ${pkgs.bashInteractive}/bin/bash "$@"
      fi
    ''

