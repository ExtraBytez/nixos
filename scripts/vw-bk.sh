ENV_NIX="$HOME/.config/nixos/nix/env.nix"
NAME=$(nix eval --raw -f "$ENV_NIX" username)
SERVER=$(nix eval --raw -f "$ENV_NIX" server)
scp -r $NAME@$SERVER:/home/$NAME/backups/vaultwarden $HOME/.vw-backups
