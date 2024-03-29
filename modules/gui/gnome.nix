{ config, pkgs, options, lib, ... }:

let
  exwmServiceStartList = [
    "udiskie"
  ];
  exwmServiceStopList = [
    "emacs" "emacs.socket"
  ];
  exwmServices = action: list: lib.concatMapStringsSep "\n"
    (x: "systemctl --user ${action} ${x}") list;
in
{
  imports = [ ./xmonad.nix ];
  services.xserver = {
    displayManager = {
      gdm.enable = true;
      gdm.wayland = false;
      defaultSession = "gnome-xorg";
      sessionCommands = ''
        # keep alacritty font size normal
        export WINIT_X11_SCALE_FACTOR=1

        # set backround image and cursor
        ${pkgs.feh}/bin/feh --bg-scale ~/.config/wall.jpg &
        # xsetroot -cursor_name left_ptr &

        if [ "$XDG_SESSION_DESKTOP" = "none+exwm" ]; then
           export XMODIFIERS=@im=exwm-xim
           export GTK_IM_MODULE=xim
           export QT_IM_MODULE=xim
           export CLUTTER_IM_MODULE=xim
           ${exwmServices "stop" exwmServiceStopList}
           ${exwmServices "start" exwmServiceStartList}
        else
           ${exwmServices "stop" exwmServiceStartList}
           ${exwmServices "start" exwmServiceStopList}
        fi
      '';
    };
    desktopManager = {
      gnome.enable = true;
    };
  };

  environment.systemPackages = with pkgs.gnomeExtensions; [
    gnome-40-ui-improvements
    transparent-window-moving
    quake-mode
    clipboard-indicator
    sound-output-device-chooser
    bluetooth-quick-connect
    tray-icons-reloaded
    proxy-switcher
    dash-to-panel
    unite
  ];
}
