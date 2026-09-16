echo " # scripts/nix/hardware_configuration.sh starting..."

CUR_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(cd "$CUR_DIR/../.." && pwd)"

cd "$REPO_DIR/hosts/nixos-desktop"

if [ ! -f hardware-configuration.nix ]; then
    echo "  > generating hardware-configuration.nix..."
    echo "  - - - - - - - "
    sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix
    git add -N hardware-configuration.nix
    git update-index --skip-worktree hardware-configuration.nix
    echo "  - - - - - - - "
else
    echo "  > hardware-configuration.nix already exists"
fi

echo " ^ scripts/nix/hardware_configuration.sh done"
