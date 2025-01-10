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
      "plugdev"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCugOg/RDYhJA3tvGdg7bsZiqGzWIrhwIrmauFN9BYGdjRhMnJXOSC2JbiWcwXja0pqavyYybEqhSKZO4lR0vc4I/hw1vuWgmPg0cl6/D/z8vm8dMG+ONxjD9uDsq1VzKr1KAXBlpfhQJc0LAxZ9HfVvogwmPsFUCEfO6K29wC+bmryGvX1sH+paJKSyozzWjs7pIVXetRk0wnZ+fxv1FE2ojogqF+ZEeqG0AijbHqFrjSW/sHUnxR/pF/p203AljEeKirb2BQg1Yau+hpA6Ditvi83baQ5Uia15YUbKCnrljTvIgUZlV066oL6sL26ThxneTKsXGB/VPAvO5uZwScFFmYnF2apqnqFvGbidrl4GEdeAdZu0cIxjsL2pBeFUHha6+icjpjytnRzoUaz4al3pTDBP4bvlV9CSYRjlIN/aExk2qPDtJbSdNIt1ioB5V0okts37B15CjPZanI+Yeitn3/9chwmTmrv5F3MhZsN3x7Mco+Dmj7RGKbZNfzT+1c= suess@omen15"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCq0y7v3jkbf6y0JO8w8AMwwaVR8bRGorApkRHU3A2yKOF91BsN4EGcdNs1bj3zSD+cXVihARacILRFkN5FHKNakLsZ4AQzhMpXwT0vdVaWDM5KNaeHLoZDHEXj2UFTOndwmfLb0YOgkCbTx2gWKvEzd50AJLH4PRbkQO3SM5ZUKswQNHTATsIOwZ3Y51a2lBIXHA8TMM9IdjV5g/V/3VQLV8EuE5ASt/wusLltek8bHrNKtEP691/bHNP6neCSCHKbT9TMfxzC1ovb/IJWKyNVBdI8FKwgAsLIBZ1vLhgx2kUGISpacnvz/OWRZRKfhztLpiKclIpIc+dJURyhq9/SDqLBNmY/gzvhs5V42ZmmYiwMzZBUaLRXfuJKqbdY93qYbd+LjfxnxeB8RFjoEDLQL68b0k5opdgRiEwsbxyg/4VCh09XDqqN7V7kk0FLZoH9UyI0Lg8/3jOKHU+4U/znASoSf9S6SCFcGocddpvs9kszQy6KX1lFJ9yQxSUeRuw2KcYcKm8fODtb+hmzdiXEenUtILWR6tPJ5IN8OR91V5mXQCYatM5BMP0NcfNemJMjvNp/n++eVfAeHXf2Vax2CjxJfUq/yAZsQmHH5Drg/FE/NC3AyeyQpQmLY80bvbga8T5o/bmmRnLvNOE8pBuIjZkApP1OHdRpQfKutdNCIw== u0_a305@localhost"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDTeX0ggapBoUza15oDhmrNNmrdmqSKFe/QWIQdRGF2sEYTk6jTR+ylBpoCOP7QtV6ip9VBFEtnLiSl01s5+PijrampYGnlzTXmFYbBfJZ4asS2b3PHSjfC5K2zCP5TLod7vUIgxhh2QCtCAE7ptnIOInTSjDrb32fTDBY6QwqwMDpZ1irdUp7pew1DdDADhBCGXLZXd0cBJBScB/z+5dx/YWQSDwYh50ehKlHnuqp1G6MKu67T96ydBmV4jb+7C5rylZYedJsxa+/nqa9hjStceciDERC3lJcn0+deE9unyUh8Ocx8SKQkPwKwq+z5r16rPWnHfgnevpFfojM/FPYFUseLcTFcZZsop7uA9b03TZvps3AEhmzWppXE/svTyIyK5HIUMQv1Dv+4vy0rlDabIIbCfJ95DwbQhBXDUWcridlnxWkJe2+KzE6AwxdoCHSIw8SYMeh+OGfBAf/oMKKSQ/wmT7s96OVgs4xqF37I83HVhX0LOi5Q19dWq0XK15ZPkjViIx8ZnaN39Eej6p4UN/qNb7Xp6LzRYe58zNOukoEbqN3eeuWU9yBHqY6YvEKzDr/J47cN5zxn8Xwq46IOCL2b/AnbIJFdrWpEI1M/xLmXulU5fq3oYXMUafMnYcaMa8sQX7+dI4smkJPhkoDUEPVccvRlGYPADORCyUgFXQ== paul@nix450s"
    ];
  };

  home-manager.users.suess = import ./hm/suess.nix;
}
