{ config, pkgs, options, lib, ... }:

{
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };

  sound = {
    enable = true;
    mediaKeys = {
      enable = true;
      volumeStep = "5%";
    };
  };

  hardware = {
    ksm.enable = true;
    bluetooth = {
      enable = true;
      package = pkgs.bluezFull;
    };
    pulseaudio = {
      enable = false;
      package = pkgs.pulseaudioFull;
      daemon.config = {
        default-sample-format = "float32ne";
        resample-method = "src-sinc-best-quality";
        alternate-sample-rate = 48000;
      };
      extraModules = [ pkgs.pulseaudio-modules-bt ];
      extraConfig = ''
        load-module module-switch-on-connect
      '';
    };
    video.hidpi.enable = true;
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        vaapiIntel
        libvdpau-va-gl
        vaapiVdpau
        vulkan-loader
        intel-media-driver
      ];
    };
    cpu.intel.updateMicrocode = true;
    trackpoint = {
      enable = true;
      emulateWheel = true;
      sensitivity = 255;
      speed = 150;
    };
  };

  systemd.paths.trackpoint = {
    pathConfig = {
      PathExists = "/sys/devices/rmi4-00/rmi4-00.fn03/serio2";
      Unit = "trackpoint.service";
    };
  };

  systemd.services.trackpoint.script = ''
    ${config.systemd.package}/bin/udevadm trigger --attr-match=name="${config.hardware.trackpoint.device}"
  '';

  services.udev = {
    extraRules = ''
      SUBSYSTEM=="usb", MODE="0666"
      # KMonad user access to /dev/uinput
      KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
      # kaleidoscope keyboards
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="2300", SYMLINK+="model01", ENV{ID_MM_DEVICE_IGNORE}:="1", ENV{ID_MM_CANDIDATE}:="0", TAG+="uaccess", TAG+="seat"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="2301", SYMLINK+="model01", ENV{ID_MM_DEVICE_IGNORE}:="1", ENV{ID_MM_CANDIDATE}:="0", TAG+="uaccess", TAG+="seat"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="2302", SYMLINK+="Atreus2", ENV{ID_MM_DEVICE_IGNORE}:="1", ENV{ID_MM_CANDIDATE}:="0", TAG+="uaccess", TAG+="seat"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="2303", SYMLINK+="Atreus2", ENV{ID_MM_DEVICE_IGNORE}:="1", ENV{ID_MM_CANDIDATE}:="0", TAG+="uaccess", TAG+="seat"

      ACTION=="add", SUBSYSTEM=="net", NAME=="enp*", RUN+="${pkgs.ethtool}/bin/ethtool -s $name wol d"
    '';
  };

  services.thermald.enable = true;
  services.thinkfan.enable = true;
  services.power-profiles-daemon.enable = false;
  services.tlp.enable = true;
  services.tlp.settings = {
    SATA_LINKPWR_ON_BAT = "min_power";
  };

  services.undervolt = {
    enable = true;
    coreOffset = -75;
    uncoreOffset = -75;
    gpuOffset = -50;
    analogioOffset = -75;
  };

  services.cron = {
      # "@reboot root echo 80 > /sys/class/power_supply/BAT0/charge_start_threshold"
      # "@reboot root echo 85 > /sys/class/power_supply/BAT0/charge_stop_threshold"
      # "@reboot root echo 80 > /sys/class/power_supply/BAT1/charge_start_threshold"
      # "@reboot root echo 85 > /sys/class/power_supply/BAT1/charge_stop_threshold"
    systemCronJobs = [
      "@reboot root echo powersave > /sys/module/pcie_aspm/parameters/policy"
    ];
  };

  powerManagement = {
    enable = true;
    # scsiLinkPolicy = "min_power";
    # powertop.enable = true;
    cpuFreqGovernor = "schedutil";
  };

  services.xserver = {
    videoDrivers = [ "modesetting" ];
    useGlamor = true;
    libinput = {
      enable = true;
      touchpad = {
        disableWhileTyping = true;
      };
    };
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
}
