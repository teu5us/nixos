{ pkgs, ... }:

{
  services = {
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "yes";
        X11Forwarding = false;
        PasswordAuthentication = false;
      };
    };

    xserver.videoDrivers = [ "modesetting" ];

    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
          user = "greeter";
        };
      };
    };

    udev.extraHwdb = ''
      evdev:input:b0005v056Ep0133*
       KEYBOARD_KEY_90002=btn_left
       KEYBOARD_KEY_90007=btn_right
    '';

    udev.extraRules = ''
      ${builtins.readFile ./69-probe-rs.rules}

      ${builtins.readFile ./69-adb.rules}
    '';

    yggdrasil = {
      enable = true;
      persistentKeys = true;
      settings = {
        Peers = [ "tls://213.226.68.79:14578" ];
        MulticastInterfaces = [
          {
            Beacon = false;
            Listen = false;
            Regex = ".*";
            Port = 0;
            Priority = 0;
            Password = "";
          }
        ];
      };
    };

    nscd.enable = true;
    cron.enable = true;
    blueman.enable = true;
    udisks2.enable = true;
  };
}
