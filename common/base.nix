{
  pkgs,
  config,
  ...
}:

{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    consoleLogLevel = 3;
    kernelParams = [ "quiet" ];
    supportedFilesystems = [
      "ntfs"
      "exfat"
    ];
    extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
    initrd.kernelModules = [ "atkbd" ];
    kernelModules = [ "v4l2loopback" ];
    extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=1 card_label="OBS Camera" exclusive_caps=1
    '';

    tmp.cleanOnBoot = true;

    kernel.sysctl = {
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestioncontrol" = "bbr";
      "vm.swappiness" = 3;
      "vm.vfs_cache_pressure" = 50;
      "vm.watermark_scale_factor" = 200;
      "vm.dirty_ratio" = 3;
      "vm.dirty_background_ratio" = 3;
      "vm.dirty_writeback_centisecs" = 1500;
      "vm.laptop_mode" = 5;
    };
  };

  hardware = {
    ksm.enable = true;
    graphics.enable = true;
  };

  console = {
    earlySetup = true;
    font = "Lat2-Terminus16";
    keyMap = "emacs";
  };

  time.timeZone = "Asia/Omsk";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "ru_RU.UTF-8/UTF-8"
    ];
  };

  services = {
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
    libinput.enable = true;
  };

  security = {
    sudo.enable = true;
    polkit.enable = true;
  };

  environment.systemPackages = with pkgs; [
    aria2
    bat
    coreutils
    curl
    fd
    file
    findutils
    htop
    killall
    libnotify
    ripgrep
    unzip
    vim
    wget
    which
    zip
  ];

  systemd.extraConfig = ''
    DefaultTimeoutStopSec=10s
  '';

  stylix = {
    enable = true;
    image = ../gui/wall.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";
  };

  users.mutableUsers = true;
  users.extraGroups.plugdev = { };

  system.stateVersion = "24.05";
}
