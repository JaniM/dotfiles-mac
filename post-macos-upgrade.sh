# https://github.com/LnL7/nix-darwin/wiki/Upgrading-macOS
sudo mv /etc/bashrc /etc/bashrc.orig
sudo mv /etc/zshrc /etc/zshrc.orig
sudo mv /etc/zprofile /etc/zprofile.orig
sudo /nix/var/nix/profiles/system/activate
exit # Start a new shell to reload the environment.
