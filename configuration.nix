{ pkgs, ... }:

# See https://github.com/LnL7/nix-darwin/tree/master/modules
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

  services.karabiner-elements.enable = true;
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

  system.defaults = {
    NSGlobalDomain.ApplePressAndHoldEnabled = false;
    NSGlobalDomain.InitialKeyRepeat = 20;
    NSGlobalDomain.KeyRepeat = 2;

    dock.autohide = true;
    dock.mru-spaces = false;
    dock.orientation = "bottom";
    dock.showhidden = true;

    trackpad.Clicking = true;
  };
}
