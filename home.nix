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
    ./modules/git.nix
    ./modules/jujutsu.nix
    (import ./modules/zsh.nix { inherit dotfiles; })
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

      # Karabiner Elements configuration
      (if isDarwin then goku else pkgs.null)

      # Fonts
      (nerdfonts.override { fonts = [ "Noto" ]; })
    ];

    home.file = {
      # Allow live ediiing of the configuration
      ".config/nvim".source = dotfilesLink ".config/nvim";
      ".config/karabiner".source = dotfilesLink ".config/karabiner";
      ".config/karabiner.edn".source = dotfilesLink ".config/karabiner.edn";
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
        extraConfig = ''
          hide_window_decorations titlebar-only
        '';
      };

      tmux = {
        enable = true;
        keyMode = "vi";
        extraConfig = lib.concatStrings [
          (builtins.readFile ./tmux-gruvbox.conf)
          (builtins.readFile ./tmux.conf)
        ];
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
