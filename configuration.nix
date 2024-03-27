{ pkgs, ... }:

# See https://github.com/LnL7/nix-darwin/tree/master/modules
{
  environment.systemPackages =
    [ pkgs.vim
    ];

  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";
    brews = [];
    casks = [
      { name = "tidal"; }
      { name = "ticktick"; }
    ];
  };

  # You have to disable System Integrity Protection to use yabai
  # https://github.com/koekeishiya/yabai/wiki/Disabling-System-Integrity-Protection
  services.yabai.enable = true;
  services.yabai.enableScriptingAddition = true;
  services.yabai.config = {
    layout = "bsp";
    mouse_modifier = "fn";
    focus_follows_mouse = "autoraise";
    mouse_follows_focus = "off";
    auto_balance = "off";
    window_placement    = "second_child";
    window_opacity      = "on";
    active_window_opacity = 1;
    normal_window_opacity = 0.9;
    top_padding         = 0;
    bottom_padding      = 0;
    left_padding        = 0;
    right_padding       = 0;
    window_gap          = 10;
  };
  services.yabai.extraConfig = ''
    yabai -m rule --add app='^System Settings$' manage=off
  '';

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
