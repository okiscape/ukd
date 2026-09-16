echo " # scripts/nix/install.sh starting..."

CUR_DIR="$(cd "$(dirname "$0")" && pwd)"
LIB_DIR="$(cd "$CUR_DIR/../lib" && pwd)"
REPO_DIR="$(cd "$CUR_DIR/../.." && pwd)"

cd "$REPO_DIR/hosts/nixos-desktop"

. "$REPO_DIR/scripts/lib/ask.sh"
. "$REPO_DIR/scripts/lib/confirm.sh"

sh "$CUR_DIR/hardware_configuration.sh"

if confirm "\"nixos-rebuild switch\" now?"; then
    echo " - - - - - - - "
    sudo nixos-rebuild switch --flake ".#${HOSTNAME}"
    echo " - - - - - - - "

else
    echo " ! ok, bye"
fi
