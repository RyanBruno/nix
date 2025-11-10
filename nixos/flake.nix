{
  description = "Ryan's NixOS Configuration Flake";
     
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {nixpkgs, ...} @ inputs:
  {
    nixosConfigurations.ishtar = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        inputs.disko.nixosModules.default
        (import ./disko.nix { device = "/dev/sda"; })

        ./nixosModules
        ./hosts/ishtar/configuration.nix
              
        inputs.impermanence.nixosModules.impermanence
        inputs.home-manager.nixosModules.default
      ];
    };
    nixosConfigurations.thorax = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        inputs.disko.nixosModules.default
        (import ./disko.nix { device = "/dev/sda"; })

        ./nixosModules
        ./hosts/thorax/configuration.nix
              
        inputs.impermanence.nixosModules.impermanence
        inputs.home-manager.nixosModules.default
      ];
    };
  };
}
