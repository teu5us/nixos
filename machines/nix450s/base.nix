{ pkgs, ... }:

{
    boot.kernelParams = [
      "pcie_aspm=force"
      "usbcore.autosuspend=1"
      "intel_pstate=active"
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

  hardware.opengl.extraPackages = with pkgs; [ intel-media-driver ];
  hardware.trackpoint = {
      enable = true;
      emulateWheel = true;
      speed = 150;
      sensitivity = 255;
  };
}
