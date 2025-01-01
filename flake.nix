{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix";

    # kmonad.url = "github:kmonad/kmonad?dir=nix";
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      nixos-hardware,
      home-manager,
      stylix,
      # kmonad,
      ...
    }:
    let
      unstable =
        system: cudaSupport:
        import nixpkgs-unstable {
          inherit system;
          config = {
            allowUnfree = true;
            cudaSupport = cudaSupport;
          };
        };
    in
    {
      nixosConfigurations = {
        omen15 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit
              nixpkgs
              nixpkgs-unstable
              nixos-hardware
              home-manager
              stylix
              ;
            unstable = unstable "x86_64-linux" false;
            hostName = "omen15";
          };
          modules =
            (with nixos-hardware.nixosModules; [
              common-cpu-amd
              common-cpu-amd-pstate
              common-gpu-nvidia
              common-pc-laptop
              common-pc-ssd
            ])
            ++ [
              stylix.nixosModules.stylix
              home-manager.nixosModules.home-manager
              ./common/packages-config.nix
              ./common/base.nix
              ./common/bluetooth.nix
              ./common/network.nix
              ./common/services.nix
              ./common/programs.nix
              ./common/shells.nix
              ./common/virtualisation.nix
              ./machines/omen15/packages-config.nix
              ./machines/omen15/hardware-configuration.nix
              ./machines/omen15/base.nix
              ./machines/omen15/services.nix
              ./machines/omen15/programs.nix
              ./gui
              ./users/suess.nix
            ];
        };

        nix450s = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit
              nixpkgs
              nixpkgs-unstable
              nixos-hardware
              home-manager
              ;
            unstable = unstable "x86_64-linux" false;
            hostName = "nix450s";
          };
          modules = [
            nixos-hardware.nixosModules.lenovo-thinkpad-t450s
            stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager
            # kmonad.nixosModules.default
            ./common/packages-config.nix
            ./common/base.nix
            ./common/bluetooth.nix
            ./common/network.nix
            ./common/services.nix
            ./common/programs.nix
            ./common/shells.nix
            ./common/virtualisation.nix
            ./machines/nix450s/hardware-configuration.nix
            ./machines/nix450s/base.nix
            ./machines/nix450s/network.nix
            ./machines/nix450s/services.nix
            ./gui
            ./users/suess.nix
          ];
        };
      };
    };
}
