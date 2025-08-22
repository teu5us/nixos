{ pkgs, ... }:

{
  fonts = {
    packages =
      with pkgs;
      [
        corefonts
        dejavu_fonts
        fira-sans
        joypixels
        noto-fonts
        open-sans
        roboto-mono
        unifont
      ]
      ++ (with pkgs.nerd-fonts; [
        fira-code
        iosevka
      ]);
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
