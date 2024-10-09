{ pkgs, ... }:

{
  fonts = {
    packages = with pkgs; [
      (nerdfonts.override {
        fonts = [
          "FiraCode"
          "Iosevka"
        ];
      })
      corefonts
      dejavu_fonts
      fira-sans
      joypixels
      noto-fonts
      open-sans
      roboto-mono
      unifont
    ];
    fontconfig = {
      enable = true;
      hinting = {
        autohint = false;
        enable = true;
      };
      subpixel.lcdfilter = "default";
      antialias = true;
      includeUserConf = true;
      defaultFonts = {
        serif = [ "DejaVu Serif" ];
        sansSerif = [ "DejaVu Sans" ];
        monospace = [ "FiraCode Nerd Font" ];
      };
    };
  };

}
