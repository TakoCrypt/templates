{
  description = "A simple home-manager flake using Aux";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";

      # The `follows` keyword in inputs is used for inheritance.
      # we do this in order to prevent duplication of the nixpkgs input, and potential
      # issues with different versions of given packages.
      # However, it should be noted that this can lead to having to rebuild packages from source.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      username = builtins.abort "You need to fill in your username"; # Set this variable equal to your username
    in
    {
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          ./home.nix

          { home.username = username; }
        ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = {
          inherit inputs;
        };
      };
    };
}
