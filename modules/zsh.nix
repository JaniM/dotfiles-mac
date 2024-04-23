{ dotfiles }:
{ config, ... }:

{
  programs.zsh = {
    enable = true;

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      "vim" = "nvim";
      "git" = "git-branchless wrap --";
      "update" = "${dotfiles}/install";
      "dc" = "docker compose";
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
}

