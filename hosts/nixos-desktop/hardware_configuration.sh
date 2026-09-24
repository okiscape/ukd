echo " # scripts/nix/hardware_configuration.sh starting..."

CUR_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(cd "$CUR_DIR/../.." && pwd)"

FORCE=false
for arg in "$@"; do
    case "$arg" in
        --force) FORCE=true ;;
    esac
done

if [ ! -f hardware-configuration.nix ] || [ "$FORCE" = true ]; then
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
