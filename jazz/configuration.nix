{ pkgs, ... }:

{
  homebrew.casks = [
    "steam"
  ];
  services.tailscale.enable = true;
}
