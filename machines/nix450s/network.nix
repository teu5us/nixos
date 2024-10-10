{ lib, ... }:

{
  networking.firewall = {
    enable = lib.mkForce true;
    allowedTCPPorts = [
      22
      22000
    ];
    allowedUDPPorts = [
      22000
      21027
    ];
  };
}
