ENV_NIX="$HOME/.config/nixos/nix/env.nix"
HOST=$(nix eval --raw -f "$ENV_NIX" hostname)
OLD=$(pwd)
cd ~/.config/nixos/nix
nixos-rebuild build-image --image-variant iso --flake .#$HOST --impure
cd $OLD
