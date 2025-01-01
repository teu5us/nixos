{
  pkgs,
  config,
  lib,
  ...
}:

{
  boot.kernelParams = [
    "pcie_aspm=force"
    "usbcore.autosuspend=1"
    "intel_pstate=active"
    "intel_iommu=on"
    "iommu=pt"
    "acpi_backlight=video"
  ];

  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-label/cryptroot";
      preLVM = true;
      allowDiscards = true;
    };
    home = {
      device = "/dev/disk/by-label/crypthome";
      preLVM = true;
      allowDiscards = true;
    };
  };

  boot.extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];

  boot.extraModprobeConfig = ''
    options i915 modeset=1 enable_fbc=1 enable_dc=2 enable_psr=0 fastboot=1 enable_dpcd_backlight=3 enable_guc=0 enable_gvt=1
    options drm vblankoffdelay=1
    options snd_hda_intel power_save=1
    options iwlwifi power_save=1 power_level=5 swcrypto=0 uapsd_disable=0 d0i3_disable=0
    options iwlmvm power_scheme=3
    options thinkpad_acpi fan_control=1
    options kvm ignore_msrs=1
  '';

  fileSystems = {
    "/".options = [
      "noatime"
      "nodiratime"
      "discard"
    ];
    "/home".options = [
      "noatime"
      "nodiratime"
      "discard"
    ];
  };

  hardware = {
    graphics.extraPackages = with pkgs; [ intel-media-driver ];

    trackpoint = {
      enable = true;
      emulateWheel = true;
      speed = 255;
      sensitivity = 255;
    };
  };

  # set trackpoint sensitivity here, otherwise it gets reset
  services.udev.extraHwdb =
    let
      c = config.hardware.trackpoint;
    in
    lib.optionalString c.enable ''
      evdev:name:${c.device}:dmi:*:svnLENOVO:*:pvrThinkPad*:*
       POINTINGSTICK_SENSITIVITY=${builtins.toString c.sensitivity}
    '';
}
