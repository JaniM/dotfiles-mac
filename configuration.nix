{ pkgs, ... }:

{
  environment.systemPackages =
    [ pkgs.vim
    ];

  homebrew = {
    enable = true;
    brews = [];
    casks = [
      { name = "tidal"; greedy = true; }
    ];
  };

  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  nix.settings.experimental-features = "nix-command flakes";

  programs.zsh.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  users.users.janimustonen = {
    name = "janimustonen";
    home = "/Users/janimustonen";
  };
}
