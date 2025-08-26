{
  description = "A simple NixOS flake";

  inputs = {
    # nixpkgs = {
    #   url = "github:NixOS/nixpkgs/nixos-25.05";
    # };
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    # nixpkgs2405 = {
    #   url = "github:NixOS/nixpkgs/nixos-24.05";
    # };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... } @ inputs: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # specialArgs = {
        #   inherit inputs;
        #   nixpkgs2405 = import inputs.nixpkgs2405 {
        #     system = "x86_64-linux";
        #     config.allowUnfree = true;
        #   };
        #   nixpkgs-unstable = import inputs.nixpkgs-unstable {
        #     system = "x86_64-linux";
        #     config.allowUnfree = true;
        #   };
        # };
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