{ pkgs, ... }:

{
  boot = {
    kernelParams = [
      "resume_offset=119218176"
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    ];
    resumeDevice = "/dev/disk/by-uuid/8f21405c-a330-4cf3-a9f8-6a5e96653adb";
  };

  hardware = {
    opengl = {
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [ nvidia-vaapi-driver ];
      extraPackages32 = with pkgs.pkgsi686Linux; [ nvidia-vaapi-driver ];
    };

    amdgpu = {
      initrd.enable = true;
      amdvlk = {
        enable = true;
        support32Bit.enable = true;
      };
    };

    nvidia = {
      modesetting.enable = true;
      open = false;
      nvidiaSettings = true;
      dynamicBoost.enable = true;
      powerManagement.enable = true;
      prime = {
        offload.enable = true;
        amdgpuBusId = "PCI:6:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };

    nvidia-container-toolkit.enable = true;
  };

  services.xserver.videoDrivers = [
    "nvidia"
    "amdgpu"
  ];
}
