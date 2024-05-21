{ config, pkgs, pkgsStable, flakes, ... }:
{
  boot = {
    kernelParams = [ "quiet" ];
    loader = {
      timeout = 0;
      systemd-boot = {
        enable = true;
        configurationLimit = 20;
      };
      efi.canTouchEfiVariables = true;
    };
    initrd = {
      systemd.enable = true;
      luks.devices = {
        root = {
          device = "/dev/nvme0n1p5";
          preLVM = true;
        };
      };
    };
    plymouth = {
      enable = true;
      catppuccin.enable = true;
    };
    tmp.cleanOnBoot = true;
  };

  networking = {
    hostName = "inf-thinkpad";
    networkmanager.enable = true;
    # wireless.enable = true; # TODO iwd?
  };

  sound.enable = true;
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        libGL
        intel-vaapi-driver
        intel-media-driver
        libvdpau-va-gl
      ];
    };
  };

  time = {
    timeZone = "Europe/Zurich";
    hardwareClockInLocalTime = true;
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    # extraLocaleSettings = { LC_TIME = "ch_DE.UTF-8"; };
  };
  console = {
    # font = "Lat2-Terminus16";
    useXkbConfig = true;
    catppuccin.enable = true;
  };

  services = {
    udev = {
      extraRules = ''
        # Crazyradio (normal operation)
        SUBSYSTEM=="usb", ATTRS{idVendor}=="1915", ATTRS{idProduct}=="7777", MODE="0664", GROUP="plugdev"
        # Bootloader
        SUBSYSTEM=="usb", ATTRS{idVendor}=="1915", ATTRS{idProduct}=="0101", MODE="0664", GROUP="plugdev"
        # Crazyflie (over USB)
        SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="5740", MODE="0664", GROUP="plugdev"
        # STM (Debugger)
        SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3748", MODE="0664", GROUP="plugdev"
      '';
    };
    logind = {
      powerKey = "ignore";
      lidSwitch = "suspend-then-hibernate";
      lidSwitchExternalPower = "ignore";
    };
    pppd.enable = true;
    displayManager = {
      # autoLogin = {
      #   enable = true;
      #   user = "micha4w";
      # };
      sddm = {
        #       package = pkgs-stable.plasma5Packages.sddm;
        enable = true;
        # autoLogin.relogin = true;
        # theme = "chili";
        catppuccin.enable = true;
      };
    };
    libinput.enable = true;
    xserver = {
      enable = true;
      xkb = {
        layout = "ch";
        variant = "de_nodeadkeys";
        options = "caps:escape";
      };
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;

    upower = {
      enable = true;
      usePercentageForPolicy = true;
      percentageAction = 3;
      percentageCritical = 5;
      percentageLow = 15;
      criticalPowerAction = "Hibernate";
    };

    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_MAX_PERF_ON_AC = 100;
        CPU_MAX_PERF_ON_BAT = 60;
      };
    };
  };
}
