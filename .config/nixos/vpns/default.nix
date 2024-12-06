{ config, pkgs, pkgsStable, flakes, ... }:
{
  systemd.services = {
    anyconnect = {
      after = [ "network.target" ];

      path = with pkgs; [
        bash
        openconnect
        oath-toolkit
      ];
      script = "${./scripts/anyconnect-wrapper.sh}";
      serviceConfig = {
        Type = "notify";
        KillSignal = "SIGINT";
        NotifyAccess = "all";
        LoadCredentialEncrypted = [
          "ethz:/root/systemd-creds/ethz.cred"
          "ethz-totp:/root/systemd-creds/ethz-totp.cred"
        ];
      };
    };
    netextender = {
      after = [ "network.target" ];

      path = with pkgs; [
        bash
        oath-toolkit
        openresolv
        flakes.nxBender.packages.${pkgs.system}.default
      ];
      script = "${./scripts/netextender-wrapper.sh}";
      serviceConfig = {
        Type = "notify";
        KillSignal = "SIGINT";
        NotifyAccess = "all";
        LoadCredentialEncrypted = [
          "inf-netextender:/root/systemd-creds/inf-netextender.cred"
          "inf-netextender-totp:/root/systemd-creds/inf-netextender-totp.cred"
        ];
      };
    };
  };
}
