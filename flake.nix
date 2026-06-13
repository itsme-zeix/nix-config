{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    disko,
    ...
  }: {
    nixosConfigurations.nixos-vm-1 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        disko.nixosModules.disko
        ./disko.nix
        ./common.nix
        ./hosts/nixos-vm-1.nix
      ];
    };
  };
}
