cd $NIX_SYSTEM_CONFIGURATION_PATH
sudo nixos-rebuild --flake ".#$(hostname)" switch
cd -
