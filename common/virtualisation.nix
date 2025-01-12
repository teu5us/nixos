{ pkgs, ... }:

{
  programs.virt-manager.enable = true;

  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = true;
    };

    spiceUSBRedirection.enable = true;

    libvirtd = {
      enable = true;
      onShutdown = "shutdown";
      qemu = {
        ovmf = {
          enable = true;
          packages = [ pkgs.OVMFFull ];
        };
        swtpm = {
          enable = true;
          package = pkgs.swtpm;
        };
        verbatimConfig = ''
          user = "suess"
          group = "libvirtd"
        '';
      };
    };
  };
}
