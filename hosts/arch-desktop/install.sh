#!/usr/bin/env sh
set -eu

echo " # arch-desktop/install.sh starting (configuration + software)"

CUR_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(cd "$CUR_DIR/../.." && pwd)"

. "$REPO_DIR/scripts/lib/ask.sh"
. "$REPO_DIR/scripts/lib/confirm.sh"
. "$REPO_DIR/scripts/lib/link.sh"

install_repo_packages() {
    echo " --- installing pacman packages..."
    PACKAGES=$(grep -v '^#' "$CUR_DIR/packages.txt" | tr '\n' ' ')

    sudo pacman -S --needed --noconfirm $PACKAGES
}

install_aur_packages() {
    echo " --- installing AUR packages..."

    if ! command -v paru >/dev/null 2>&1; then
        if ! command -v git >/dev/null 2>&1; then
            echo " ! git is required to bootstrap paru" >&2
            exit 1
        fi
        echo " > bootstrapping paru..."
        git clone https://aur.archlinux.org/paru.git /tmp/paru
        (cd /tmp/paru && makepkg -si --noconfirm)
        rm -rf /tmp/paru
    fi

    PACKAGES=$(grep -v '^#' "$CUR_DIR/aur.txt" | tr '\n' ' ')

    paru -S --needed --noconfirm $PACKAGES
}

install_configs() {
    echo " --- installing configuration..."

    CONFIG_DIR="$HOME/.config"
    mkdir -p "$CONFIG_DIR"

    # driftwm
    if [ -f "$REPO_DIR/common/driftwm.toml" ]; then
        mkdir -p "$CONFIG_DIR/driftwm"
        link_config "$REPO_DIR/common/driftwm.toml" "$CONFIG_DIR/driftwm/config.toml"
        echo "  > driftwm config linked"
    fi

    # kitty
    if [ -f "$REPO_DIR/hosts/${DISTRO_HOST:-arch-desktop}/kitty.conf" ] || [ -f "$CUR_DIR/kitty.conf" ]; then
        mkdir -p "$CONFIG_DIR/kitty"
        link_config "$CUR_DIR/kitty.conf" "$CONFIG_DIR/kitty/kitty.conf"
        echo "  > kitty config linked"
    fi

    # fish
    if [ -f "$REPO_DIR/common/fish_init.sh" ]; then
        mkdir -p "$CONFIG_DIR/fish"
        grep -q "fish_init" "$CONFIG_DIR/fish/config.fish" 2>/dev/null || \
            echo "source '$REPO_DIR/common/fish_init.sh'" >> "$CONFIG_DIR/fish/config.fish"
        echo "  > fish config linked"
    fi

    # starship
    if [ -f "$REPO_DIR/hosts/${DISTRO_HOST:-arch-desktop}/starship.toml" ] || [ -f "$CUR_DIR/starship.toml" ]; then
        link_config "$CUR_DIR/starship.toml" "$CONFIG_DIR/starship.toml"
        echo "  > starship config linked"
    fi

    # fastfetch
    if [ -f "$REPO_DIR/common/fastfetch-logo.png" ]; then
        mkdir -p "$CONFIG_DIR/fastfetch"
        link_config "$REPO_DIR/common/fastfetch-logo.png" "$CONFIG_DIR/fastfetch/logo.png"
        echo "  > fastfetch logo linked"
    fi

    # grub theme
    if [ -d "$REPO_DIR/common/grub-theme" ] && confirm " ? install grub theme?"; then
        sudo cp -r "$REPO_DIR/common/grub-theme" /boot/grub/themes/ukd
        if command -v grub-mkconfig >/dev/null 2>&1; then
            sudo sed -i 's|^#GRUB_THEME=.*|GRUB_THEME="/boot/grub/themes/ukd/theme.txt"|' /etc/default/grub
            sudo sed -i 's|^GRUB_THEME=.*|GRUB_THEME="/boot/grub/themes/ukd/theme.txt"|' /etc/default/grub
            sudo grub-mkconfig -o /boot/grub/grub.cfg
        fi
    fi
}

install_repo_packages
install_aur_packages
install_configs

echo ""
echo " ^ arch-desktop install.sh done"
