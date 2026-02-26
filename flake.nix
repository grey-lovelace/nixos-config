{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-25.11";
    };
    nixpkgs2411 = {
      url = "github:NixOS/nixpkgs/nixos-24.11";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... } @ inputs: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          nixpkgs2411 = import inputs.nixpkgs2411 {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
        };
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.grey = import ./home.nix;
          }
        ];
      };
    };
  };
}