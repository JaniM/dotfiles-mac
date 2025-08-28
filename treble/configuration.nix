{ pkgs, ... }:

{
  system.primaryUser = "janimustonen";
  homebrew.casks = [
    "tunnelblick"
    "temurin" # java
  ];
}
