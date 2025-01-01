{ pkgs, unstable, ... }:

{
  services = {
    ollama = {
      enable = false;
      package = pkgs.ollama;
      acceleration = "cuda";
      environmentVariables.CUDA_VISIBLE_DEVICES = "0";
      environmentVariables.HIP_VISIBLE_DEVICES = "-1";
    };

    onlyoffice = {
      enable = false;
      port = 8530;
    };
  };
}
