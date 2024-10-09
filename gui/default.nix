{ pkgs, ... }:

{
  imports = [ ./fonts.nix ];

  programs.hyprland.enable = true;

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
      "lhaoghhllmiaaagaffababmkdllgfcmc" # atomic-chrome
      "djflhoibgkdhkhhcedjiklpkjnoahfmg" # user-agent switcher
      "jinjaccalgkegednnccohejagnlnfdag" # violentmonkey
      "oboonakemofpalcgghocfoadofidjkkk" # keepassxc-browser
      "fhcgjolkccmbidfldomjliifgaodjagh" # cookieautodelete
      "gphhapmejobijbbhgpjhcjognlahblep" # gnome extensions
      "aleakchihdccplidncghkekgioiakgal" # h264ify
      "fmkadmapgofadopljbjfkapdkoienihi" # react devtools
      "lmhkpmbekcpmknklioeibfkpmmfibljd" # redux devtools
      "ndlbedplllcgconngcnfmkadhokfaaln" # graphql network inspector
      "dpjamkmjmigaoobjbekmfgabipmfilij" # empty new tab page
    ];
  };

}
