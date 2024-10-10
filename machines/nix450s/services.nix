{ ... }:

{
  services.kmonad = {
    enable = true;
    keyboards.nix450s = {
      device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
      config = builtins.readFile ./files/keyboard.kbd;
    };
  };

  services.cron = {
    # "@reboot root echo 80 > /sys/class/power_supply/BAT0/charge_start_threshold"
    # "@reboot root echo 85 > /sys/class/power_supply/BAT0/charge_stop_threshold"
    # "@reboot root echo 80 > /sys/class/power_supply/BAT1/charge_start_threshold"
    # "@reboot root echo 85 > /sys/class/power_supply/BAT1/charge_stop_threshold"
    systemCronJobs = [ "@reboot root echo powersave > /sys/module/pcie_aspm/parameters/policy" ];
  };

  services.thermald.enable = true;
}
