{
  pkgs,
  unstable,
  nixpkgs,
  nixpkgs-unstable,
  stylix,
  zen-browser,
  ...
}:

{
  nix = {
    extraOptions = "experimental-features = nix-command flakes";
    registry.nixpkgs.flake = nixpkgs;
    registry.unstable.flake = nixpkgs-unstable;
    settings = {
      trusted-users = [ "root" ];
      auto-optimise-store = true;
    };
    nixPath = [
      "nixpkgs=${pkgs.path}"
      "unstable=${unstable.path}"
    ];
  };

  nixpkgs.config = {
    allowUnfree = true;
    joypixels.acceptLicense = true;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit
        unstable
        nixpkgs
        nixpkgs-unstable
        stylix
        zen-browser
        ;
    };
  };
}
