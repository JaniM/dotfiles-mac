{
  description = "Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let
    include = path: if builtins.pathExists path then path else null;
    withoutNulls = list: builtins.filter (x: x != null) list;

    mkSystem = root: nix-darwin.lib.darwinSystem {
      modules = withoutNulls [
        # Set Git commit hash for darwin-version.
        { system.configurationRevision = self.rev or self.dirtyRev or null; }

        ./configuration.nix
        ./overlays.nix
        (include (root + "/configuration.nix"))

        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.janimustonen = import ./home.nix;

          home-manager.extraSpecialArgs.modules = [(root + "/home.nix")];
        }
      ];
    };
  in {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .
    darwinConfigurations."jazz" = mkSystem ./jazz;
    darwinConfigurations."treble" = mkSystem ./treble;
  };
}
