{ config, ... }:

let
  removeNewlines = str: builtins.replaceStrings ["\n"] [""] str;
in {
  programs.git = {
    enable = true;
    settings.alias.co = "checkout";
    settings.alias.st = "status";
    settings.alias.lg = removeNewlines ''
      log --graph --abbrev-commit --decorate --date=relative
        --format=format:'%C(bold blue)%h%C(reset)
        - %C(bold green)(%ar)%C(reset)
        %C(white)%s%C(reset)
        %C(dim white)-
        %an%C(reset)%C(bold yellow)%d%C(reset)'
    '';
    settings.user.name = config.identity.name;
    settings.user.email = config.identity.email;
  };
}
