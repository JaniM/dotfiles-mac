{ config, pkgs, lib, ... }:

{
  home.username = "janimustonen";
  home.homeDirectory = "/Users/janimustonen";

  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    discord
    rustup
  ];
}
