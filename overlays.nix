{ config, pkgs, lib, ... }:

{
  nixpkgs.overlays = [
    (self: super: {
      yabai =
        if builtins.compareVersions super.yabai.version "7.1.5" >= 0
        then super.yabai
        else super.yabai.overrideAttrs (old: rec {
          version = "7.1.5";
          src = super.fetchzip {
            url = "https://github.com/koekeishiya/yabai/releases/download/v${version}/yabai-v${version}.tar.gz";
            hash = "sha256-o+9Z3Kxo1ff1TZPmmE6ptdOSsruQzxZm59bdYvhRo3c=";
          };
      });
    })
  ];
}
