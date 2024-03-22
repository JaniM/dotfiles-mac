{ config, ... }:

let
  removeNewlines = str: builtins.replaceStrings ["\n"] [""] str;
in {
  programs.git = {
    enable = true;
    aliases.co = "checkout";
    aliases.st = "status";
    aliases.lg = removeNewlines ''
      log --graph --abbrev-commit --decorate --date=relative
        --format=format:'%C(bold blue)%h%C(reset)
        - %C(bold green)(%ar)%C(reset)
        %C(white)%s%C(reset)
        %C(dim white)-
        %an%C(reset)%C(bold yellow)%d%C(reset)'
    '';
    userName = config.identity.name;
    userEmail = config.identity.email;
  };
}
