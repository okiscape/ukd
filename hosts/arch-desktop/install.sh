#!/usr/bin/env sh
set -eu

echo " # arch-desktop/install.sh starting (configuration + software)"

CUR_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(cd "$CUR_DIR/../.." && pwd)"

. "$REPO_DIR/scripts/lib/ask.sh"
. "$REPO_DIR/scripts/lib/confirm.sh"
. "$REPO_DIR/scripts/lib/ignore.sh"
. "$REPO_DIR/scripts/lib/link.sh"

ukd_ignore_load "$REPO_DIR/.ukdignore" || exit 1

install_system_config() {
    echo " --- installing system configuration..."

    if ! ukd_is_ignored "konawalls" && [ -f "$CUR_DIR/system/konawalls.conf" ]; then
        TARGET_USER="${SUDO_USER:-${USER:-}}"

        if getent group wallpapers >/dev/null 2>&1; then
            echo "  > wallpapers group already exists"
        else
            sudo groupadd -f wallpapers
            echo "  > wallpapers group created"
        fi

        if [ -z "$TARGET_USER" ] || [ "$TARGET_USER" = "root" ]; then
            echo " ! cannot detect desktop user, add it manually: sudo usermod -aG wallpapers <user>"
        elif id -nG "$TARGET_USER" | tr ' ' '\n' | grep -qx "wallpapers"; then
            echo "  > user $TARGET_USER is already in wallpapers group"
        else
            sudo usermod -aG wallpapers "$TARGET_USER"
            echo "  > user $TARGET_USER added to wallpapers group (relogin to apply)"
        fi

        sudo install -Dm644 "$CUR_DIR/system/konawalls.conf" /etc/tmpfiles.d/ukd-konawalls.conf
        sudo systemd-tmpfiles --create /etc/tmpfiles.d/ukd-konawalls.conf
        echo "  > wallpapers tmpfiles rules applied"
    fi
}

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
    if ! ukd_is_ignored "driftwm" && [ -f "$REPO_DIR/common/driftwm.toml" ]; then
        link_config "$REPO_DIR/common/driftwm.toml" "$CONFIG_DIR/driftwm/config.toml" "$CONFIG_DIR/driftwm"
        echo "  > driftwm config linked"
    fi

    # kitty
    if ! ukd_is_ignored "kitty" && [ -f "$REPO_DIR/common/kitty.conf" ]; then
        link_config "$REPO_DIR/common/kitty.conf" "$CONFIG_DIR/kitty/kitty.conf" "$CONFIG_DIR/kitty"
        echo "  > kitty config linked"
    fi

    # quickshell
    if ! ukd_is_ignored "quickshell" && [ -d "$REPO_DIR/common/quickshell" ]; then
        link_dir "$REPO_DIR/common/quickshell" "$CONFIG_DIR/quickshell"
        echo "  > quickshell config linked"
    fi

    # konawalls
    if ! ukd_is_ignored "konawalls" && [ -f "$REPO_DIR/common/konawalls.json" ]; then
        link_config "$REPO_DIR/common/konawalls.json" "$CONFIG_DIR/konawalls/config.json" "$CONFIG_DIR/konawalls"
        echo "  > konawalls config linked"
    fi

    # hellwal
    if ! ukd_is_ignored "hellwal" && [ -d "$REPO_DIR/common/hellwal" ]; then
        link_dir "$REPO_DIR/common/hellwal" "$CONFIG_DIR/hellwal/templates"
        echo "  > hellwal config linked"
    fi

    # fish
    if ! ukd_is_ignored "fish" && [ -f "$REPO_DIR/common/fish_init.sh" ]; then
        mkdir -p "$CONFIG_DIR/fish"
        grep -q "fish_init" "$CONFIG_DIR/fish/config.fish" 2>/dev/null || \
            echo "source '$REPO_DIR/common/fish_init.sh'" >> "$CONFIG_DIR/fish/config.fish"
        echo "  > fish config linked"
    fi

    # starship
    if ! ukd_is_ignored "starship" && [ -f "$REPO_DIR/common/starship.toml" ]; then
        link_config "$REPO_DIR/common/starship.toml" "$CONFIG_DIR/starship.toml"
        echo "  > starship config linked"
    fi

    # fastfetch
    if ! ukd_is_ignored "fastfetch" && [ -f "$REPO_DIR/common/fastfetch-logo.png" ]; then
        link_config "$REPO_DIR/common/fastfetch-logo.png" "$CONFIG_DIR/fastfetch/logo.png" "$CONFIG_DIR/fastfetch"
        echo "  > fastfetch logo linked"
    fi

    # grub theme
    if ! ukd_is_ignored "grub" && [ -d "$REPO_DIR/common/grub-theme" ] && confirm " ? install grub theme?"; then
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
install_system_config

echo ""
echo " ^ arch-desktop install.sh done"
