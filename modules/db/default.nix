{ config, pkgs, options, lib, ... }:

{
  services = {
    postgresql = {
      enable = true;
      package = pkgs.postgresql;
      enableTCPIP = true;
      authentication = pkgs.lib.mkOverride 10 ''
        local all all trust
        host all all ::1/128 trust
        host all all 127.0.0.1/32 trust
      '';
      initialScript = pkgs.writeText "backend-initScript" ''
        CREATE ROLE admin WITH LOGIN PASSWORD 'admin' CREATEDB;
        CREATE DATABASE admin;
        GRANT ALL PRIVILEGES ON DATABASE admin TO admin;
      '';
    };
    mongodb = { enable = true; };
  };
}
