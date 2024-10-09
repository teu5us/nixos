{ ... }:

{
  services.kmonad = {
    enable = true;
    keyboards.nix450s = {
      device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
      config = builtins.readFile ./files/keyboard.kbd;
    };
  };
}
