{ config, pkgs, lib, ... }:

{
  home.username = "janimustonen";
  home.homeDirectory = "/Users/janimustonen";

  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.
  
  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  home.packages = [
    pkgs.nodejs_21
    pkgs.neovim

    # Utilities
    pkgs.ranger
    pkgs.bat
    pkgs.tldr
    pkgs.fzf
    pkgs.ripgrep
    pkgs.git-branchless
    pkgs.jujutsu
    pkgs.tree

    # Fonts
    (pkgs.nerdfonts.override { fonts = [ "Noto" ]; })
  ];

  home.file = {
    ".config/nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink .config/nvim;
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  fonts.fontconfig.enable = true;

  programs = {
    kitty = {
      enable = true;
      font.name = "Noto Mono Regular";
      theme = "Gruvbox Material Dark Medium";
    };

    tmux = {
      enable = true;
      extraConfig = lib.concatStrings [
        (builtins.readFile ./tmux-gruvbox.conf)
        (builtins.readFile ./tmux.conf)
      ];
    };

    zsh = {
      enable = true;

      enableCompletion = true;
      enableAutosuggestions = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        "vim" = "nvim";
        "git" = "git-branchless wrap --";
        "update" = "~/.config/home-manager/install";
      };
      history.size = 10000;
      history.path = "${config.xdg.dataHome}/zsh/history";
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "thefuck" ];
        theme = "robbyrussell";
      };

      initExtra = ''
        export PATH="$HOME/.config/home-manager/scripts:$PATH"
        export PATH="$HOME/.local/bin:$PATH"
      '';
    };

    thefuck.enable = true;
    zoxide.enable = true;

    # Let Home Manager install and manage itself.
    home-manager.enable = true;
  };

  # Install MacOS applications to the user environment if the targetPlatform is Darwin
  home.file."Applications/home-manager".source = let
    apps = pkgs.buildEnv {
      name = "home-manager-applications";
      paths = config.home.packages;
      pathsToLink = "/Applications";
    };
  in lib.mkIf pkgs.stdenv.targetPlatform.isDarwin "${apps}/Applications";
}
