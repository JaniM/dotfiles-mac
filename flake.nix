{
  description = "Home Manager configuration of janimustonen";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "aarch64-darwin";
      pkgs = import nixpkgs {
        system = system;
        config.allowUnfree = true;
      };
    in {
      homeConfigurations = {
        "janimustonen@jazz" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [ ./home.nix ./jazz.nix ];
        };
        "janimustonen@treble" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [ ./home.nix ./treble.nix ];
        };
      };
    };
}
