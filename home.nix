# config = the whole home-manager configuration
{ config, pkgs, lib, ... }:

let
  isDarwin = pkgs.stdenv.targetPlatform.isDarwin;
  dotfiles = "${config.home.homeDirectory}/.config/home-manager";
  dotfilesLink = path:
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";

in {
  imports = [
    ./modules/jujutsu.nix
  ];

  options = {
    identity = {
      email = lib.mkOption { type = lib.types.str; };
      name = lib.mkOption { type = lib.types.str; };
    };
  };

  config = {
    nix = {
      package = pkgs.nix;
      settings.experimental-features = [ "nix-command" "flakes" ];
    };

    home.packages = with pkgs; [
      nodejs
      neovim

      # Utilities
      ranger
      bat
      tldr
      fzf
      ripgrep
      jq
      git-branchless

      # Fonts
      (nerdfonts.override { fonts = [ "Noto" ]; })
    ];

    home.file = {
      # Allow live ediiing of the configuration
      ".config/nvim".source = dotfilesLink ".config/nvim";
      "scripts".source = dotfilesLink "scripts";
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
        keyMode = "vi";
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
          export PATH="$HOME/scripts:$PATH"
          export PATH="$HOME/.local/bin:$PATH"
        '';
      };

      thefuck.enable = true;
      zoxide.enable = true;

      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      # Let Home Manager install and manage itself.
      home-manager.enable = true;
    };
  };
}
