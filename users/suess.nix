{ pkgs, ... }:

{
  users.users.suess = {
    isNormalUser = true;
    home = "/home/suess";
    uid = 1000;
    shell = pkgs.zsh;
    group = "users";
    extraGroups = [
      "wheel"
      "video"
      "audio"
      "disk"
      "networkmanager"
      "input"
      "dialout"
      "docker"
      "kvm"
      "libvirtd"
      "tty"
      "fuse"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCugOg/RDYhJA3tvGdg7bsZiqGzWIrhwIrmauFN9BYGdjRhMnJXOSC2JbiWcwXja0pqavyYybEqhSKZO4lR0vc4I/hw1vuWgmPg0cl6/D/z8vm8dMG+ONxjD9uDsq1VzKr1KAXBlpfhQJc0LAxZ9HfVvogwmPsFUCEfO6K29wC+bmryGvX1sH+paJKSyozzWjs7pIVXetRk0wnZ+fxv1FE2ojogqF+ZEeqG0AijbHqFrjSW/sHUnxR/pF/p203AljEeKirb2BQg1Yau+hpA6Ditvi83baQ5Uia15YUbKCnrljTvIgUZlV066oL6sL26ThxneTKsXGB/VPAvO5uZwScFFmYnF2apqnqFvGbidrl4GEdeAdZu0cIxjsL2pBeFUHha6+icjpjytnRzoUaz4al3pTDBP4bvlV9CSYRjlIN/aExk2qPDtJbSdNIt1ioB5V0okts37B15CjPZanI+Yeitn3/9chwmTmrv5F3MhZsN3x7Mco+Dmj7RGKbZNfzT+1c= suess@omen15"
    ];
  };

  home-manager.users.suess = import ./hm/suess.nix;
}
