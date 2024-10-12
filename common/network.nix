{ pkgs, hostName, ... }:

{
  networking = {
    hostName = hostName;
    networkmanager.enable = true;
    firewall.enable = false;
    hosts = {
      "200:33c5:d35:b3bf:7ed4:2aa4:83cb:196f" = [ "omen15" ];
      "202:9e4b:8cad:eb23:9340:178a:c29:e344" = [ "nix450s" ];
    };
  };
}
