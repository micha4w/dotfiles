{ config, pkgs, pkgsStable, flakes, lib, ... }:
{
  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
    kernelParams = [ "quiet" ];
    kernelModules = [ "ddcci_backlight" ];
    extraModulePackages = [
      (pkgs.callPackage ./packages/ddcci-driver.nix {
        inherit flakes;
        kernel = config.boot.kernelPackages.kernel;
      })
    ];

    loader = {
      timeout = 0;
      systemd-boot = {
        enable = true;
        consoleMode = "max";
        configurationLimit = 20;
        extraInstallCommands = ''
          default_cfg=$(${pkgs.coreutils}/bin/cat /boot/loader/loader.conf | ${pkgs.gnugrep}/bin/grep default | ${pkgs.gawk}/bin/awk '{print $2}')
          tmp=$(${pkgs.coreutils}/bin/mktemp -d)

          ${pkgs.coreutils}/bin/echo -ne "$default_cfg\0" | ${pkgs.iconv}/bin/iconv -f utf-8 -t utf-16le > $tmp/efivar.txt

          ${pkgs.efivar}/bin/efivar -n 4a67b082-0a4c-41cf-b6c7-440b29bb8c4f-LoaderEntryLastBooted -w -f $tmp/efivar.txt
          ${pkgs.systemd}/bin/bootctl set-default @saved
        '';
      };
      efi.canTouchEfiVariables = true;
    };
    initrd = {
      systemd.enable = true;
      luks.devices = {
        root = {
          device = "/dev/nvme0n1p6";
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

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        libGL
        intel-vaapi-driver
        intel-media-driver
        libvdpau-va-gl
      ];
    };
    # for ddcutil
    i2c.enable = true;
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

  systemd.services = {
    waydroid-container.wantedBy = lib.mkForce [ ];

    display-manager.after = [ "multi-user.target" ];
    "ddcci_backlight@" = {
      scriptArgs = "%i";
      script = ''
        echo "Trying to attach ddcci to $1"
        id=$(echo "$1" | cut -d "-" -f 2)
        if ${pkgs.ddcutil}/bin/ddcutil getvcp 10 -b $id; then
          echo ddcci 0x37 > "/sys/bus/i2c/devices/$1/new_device"
        fi
      '';
      serviceConfig.Type = "oneshot";
    };
  };
  services = {
    udev = {
      # packages = with pkgs; [
      #   platformio-core.udev
      #   openocd
      # ];
      extraHwdb = ''
        evdev:atkbd:*
          KEYBOARD_KEY_01=capslock
          KEYBOARD_KEY_3a=esc

        *
          KEYBOARD_KEY_70029=capslock
          KEYBOARD_KEY_70039=esc
      '';
      extraRules = ''
        SUBSYSTEM=="i2c-dev", ACTION=="add",\
          ATTR{name}=="AMDGPU DM i2c *",\
          TAG+="ddcci",\
          TAG+="systemd",\
          ENV{SYSTEMD_WANTS}+="ddcci_backlight@$kernel.service"


        # stm32 discovery boards, with onboard st/linkv1
        # ie, STM32VL.

        SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3744", \
            MODE="660", GROUP="plugdev", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1", \
            SYMLINK+="stlinkv1_%n"
        # stm32 nucleo boards, with onboard st/linkv2-1
        # ie, STM32F0, STM32F4.

        SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374b", \
            MODE="660", GROUP="plugdev", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1", \
            SYMLINK+="stlinkv2-1_%n"

        SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3752", \
            MODE="660", GROUP="plugdev", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1", \
            SYMLINK+="stlinkv2-1_%n"

        # stm32 discovery boards, with onboard st/linkv2
        # ie, STM32L, STM32F4.

        SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3748", \
            MODE="660", GROUP="plugdev", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1", \
            SYMLINK+="stlinkv2_%n"
        # stlink-v3 boards (standalone and embedded) in usbloader mode and standard (debug) mode

        SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374d", \
            MODE="660", GROUP="plugdev", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1", \
            SYMLINK+="stlinkv3loader_%n"

        SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374e", \
            MODE="660", GROUP="plugdev", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1", \
            SYMLINK+="stlinkv3_%n"

        SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374f", \
            MODE="660", GROUP="plugdev", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1", \
            SYMLINK+="stlinkv3_%n"

        SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3753", \
            MODE="660", GROUP="plugdev", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1", \
            SYMLINK+="stlinkv3_%n"

        SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3754", \
            MODE="660", GROUP="plugdev", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1", \
            SYMLINK+="stlinkv3_%n"

        SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3755", \
            MODE="660", GROUP="plugdev", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1", \
            SYMLINK+="stlinkv3loader_%n"

        SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3757", \
            MODE="660", GROUP="plugdev", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1", \
            SYMLINK+="stlinkv3_%n"

      #   Crazyradio (normal operation)
      #   SUBSYSTEM=="usb", ATTRS{idVendor}=="1915", ATTRS{idProduct}=="7777", MODE="0664", GROUP="plugdev"
      #   Bootloader
      #   SUBSYSTEM=="usb", ATTRS{idVendor}=="1915", ATTRS{idProduct}=="0101", MODE="0664", GROUP="plugdev"
      #   Crazyflie (over USB)
      #   SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="5740", MODE="0664", GROUP="plugdev"
      #   STM (Debugger)
      #   SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3748", MODE="0664", GROUP="plugdev"
      '';
    };
    logind = {
      powerKey = "ignore";
      lidSwitch = "suspend-then-hibernate";
      lidSwitchExternalPower = "ignore";
    };
    pppd.enable = true;
    displayManager = {
      autoLogin = {
        enable = true;
        user = "micha4w";
      };
      sddm = {
        enable = true;
        # autoLogin.relogin = true;
        theme = "chili";
        # catppuccin.enable = true;
      };
    };
    libinput.enable = true;
    xserver = {
      enable = true;
      xkb = {
        layout = "ch";
        variant = "de_nodeadkeys";
#        options = "caps:escape";
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

    printing = {
      enable = true;
      drivers = with pkgs; [
        dcp9020cdwlpr
      ];
      webInterface = false;
    };
    avahi = { # printer autodiscovery
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

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
