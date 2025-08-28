{ pkgs, ... }:

{
  system.primaryUser = "janimustonen";
  homebrew.casks = [ ];
  services.tailscale.enable = true;
}
