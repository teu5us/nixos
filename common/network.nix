{ pkgs, hostName, ... }:

{
  networking = {
    hostName = hostName;
    networkmanager.enable = true;
    firewall.enable = false;
  };
}
