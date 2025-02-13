{ pkgs, ... }:

{
  imports = [ ./fonts.nix ];

  programs.hyprland.enable = true;

  xdg.portal = {
    enable = true;
    config = {
      config.default = [
        "hyprland"
        "gtk"
        "kde"
      ];
    };
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
      xdg-desktop-portal-kde
    ];
  };

  systemd.tmpfiles.rules = [
    "L+ /usr/libexec/xdg-desktop-portal - - - - ${pkgs.xdg-desktop-portal}/libexec/xdg-desktop-portal"
    "L+ /usr/libexec/xdg-desktop-portal-kde - - - - ${pkgs.xdg-desktop-portal-kde}/libexec/xdg-desktop-portal-kde"
  ];

  environment.systemPackages = with pkgs; [
    firefox
    wofi
  ];

  programs.chromium = {
    enable = true;
    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
      "hfjbmagddngcpeloejdejnfgbamkjaeg" # vimium c
      "eimadpbcbfnmbkopoojfekhnkhdbieeh" # darkreader
      "chphlpgkkbolifaimnlloiipkdnihall" # onetab
      "djflhoibgkdhkhhcedjiklpkjnoahfmg" # user-agent switcher
      "fhcgjolkccmbidfldomjliifgaodjagh" # cookieautodelete
      "gphhapmejobijbbhgpjhcjognlahblep" # gnome extensions
      "aleakchihdccplidncghkekgioiakgal" # h264ify
      "dpjamkmjmigaoobjbekmfgabipmfilij" # empty new tab page
      "padekgcemlokbadohgkifijomclgjgif" # switchyomega
    ];
  };

}
