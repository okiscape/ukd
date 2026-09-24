#!/usr/bin/env sh
set -eu

echo " # ubuntu-server/install.sh starting (configuration + software)"

echo " ! this module currenly not available, we're working on it. stay tuned!"


# \/ AI WRITTEN, NEEDS CHECK AND DEBUGGING

# CUR_DIR="$(cd "$(dirname "$0")" && pwd)"
# REPO_DIR="$(cd "$CUR_DIR/../.." && pwd)"

# . "$REPO_DIR/scripts/lib/ask.sh"
# . "$REPO_DIR/scripts/lib/confirm.sh"

# install_apt_packages() {
#     echo " --- installing apt packages..."
#     sudo apt-get update
#     PACKAGES=$(grep -v '^#' "$CUR_DIR/packages.txt" | tr '\n' ' ')

#     sudo apt-get install -y $PACKAGES
# }

# configure_server() {
#     echo " --- configuring server..."

#     HOSTNAME=$(ask " ? hostname" "ubuntu-server")

#     echo "  > setting hostname..."
#     sudo hostnamectl set-hostname "$HOSTNAME"

#     echo "  > enabling firewall (allow ssh)..."
#     if command -v ufw >/dev/null 2>&1; then
#         sudo ufw allow OpenSSH >/dev/null 2>&1 || true
#         sudo ufw --force enable >/dev/null 2>&1 || true
#     fi

#     echo "  > enabling fail2ban..."
#     if command -v systemctl >/dev/null 2>&1; then
#         sudo systemctl enable --now fail2ban 2>/dev/null || true
#     fi
# }

# install_apt_packages
# configure_server

# echo ""
# echo " ^ ubuntu-server install.sh done"
