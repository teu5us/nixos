{ pkgs, ... }:

{
  programs = {
    amnezia-vpn.enable = true;

    mtr.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
}
