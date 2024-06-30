{ pkgs, ... }:

# See https://github.com/LnL7/nix-darwin/tree/master/modules
let
  scriptDerivation = name: path: pkgs.stdenv.mkDerivation {
    name = name;
    src = path;
    installPhase = ''
      mkdir -p $out/bin
      cp * $out/bin
    '';
  };
in {
  environment.systemPackages =
    [ pkgs.vim
    ];

  fonts.fontDir.enable = true;
  fonts.fonts = [
    # Noto for terminal
    # Sketchybar requires Hack Nerd Font
    (pkgs.nerdfonts.override { fonts = [ "Noto" "Hack" ]; })
    pkgs.sketchybar-app-font
  ];

  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";
    brews = [
      "imagemagick"
    ];
    casks = [
      { name = "tidal"; }
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
    top_padding         = 10;
    bottom_padding      = 10;
    left_padding        = 10;
    right_padding       = 10;
    window_gap          = 10;
  };
  services.yabai.extraConfig = ''
    yabai -m rule --add app='^System Settings$' manage=off

    # sketchybar event-s (.yabairc)
    yabai -m signal --add event=window_focused action="sketchybar -m --trigger window_focus &> /dev/null"
    yabai -m signal --add event=window_minimized action="sketchybar -m --trigger window_focus &> /dev/null"
    yabai -m signal --add event=window_title_changed action="sketchybar -m --trigger title_change &> /dev/null"

    # 40pz padding for sketchybar
    yabai -m config external_bar all:40:0
  '';

  services.sketchybar = {
    enable = true;
    extraPackages = [
      (scriptDerivation "sketchybar-plugins" ./sketchybar/plugins)
      pkgs.jq
    ];
    config = builtins.readFile ./sketchybar/config.sh;
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
    # Let sketchybar manage the status bar
    NSGlobalDomain._HIHideMenuBar = true;

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
