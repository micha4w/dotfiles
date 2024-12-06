{ pkgs }:

pkgs.writeShellApplication {
  name = "windows_reboot";
  runtimeInputs = with pkgs; [ coreutils iconv efivar ];
  text = ./windows_reboot;
}
