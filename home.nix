# config = the whole home-manager configuration
{ config, pkgs, lib, modules, ... }:

let
  isDarwin = pkgs.stdenv.targetPlatform.isDarwin;
  # TODO: I want a way to avoid hardcoding the path to the dotfiles
  dotfiles = "${config.home.homeDirectory}/dotfiles";
  dotfilesLink = path:
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";

in {
  imports = modules ++ [
    ./modules/jujutsu.nix
  ];

  options = {
    identity = {
      email = lib.mkOption { type = lib.types.str; };
      name = lib.mkOption { type = lib.types.str; };
    };
  };

  config = {
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
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

        shellAliases = {
          "vim" = "nvim";
          "git" = "git-branchless wrap --";
          "update" = "${dotfiles}/install";
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
