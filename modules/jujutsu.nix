{ config, ... }:

{
  programs.jujutsu = {
    enable = true;
    settings = {
      user = { inherit (config.identity) name email; };
      ui.paginate = "never";
      ui.default-command = "log";
      ui.diff-editor = ":builtin";
      revsets = {
        log = ''
          @ | trunk()
            | ancestors(bookmarks(), 2)
            | (ancestors(immutable_heads().., 2) ~ ::(remote_bookmarks() ~ bookmarks()))
        '';
      };
      revset-aliases = {
        "work(x)" = "immutable_heads()..((immutable_heads().. & (author(x) | committer(x)))::)";
      };
    };
  };
}

