{
  description = "Home Manager configuration";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        home = custom: home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          modules = [ ./home.nix custom ];
        };
      in {
        packages.homeConfigurations = {
          "janimustonen@jazz" = home ./jazz.nix;
          "janimustonen@treble" = home ./treble.nix;
        };
      }
    );
}
