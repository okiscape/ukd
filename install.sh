#!/usr/bin/env sh
set -eu

echo '
            88                88
            88                88
            88                88
88       88 88   ,d8  ,adPPYb,88
88       88 88 ,a8"  a8"    `Y88
88       88 8888[    8b       88
"8a,   ,a88 88`"Yba, "8a,   ,d88
 `"YbbdP'"'"'Y8 88   `Y8a `"8bbdP"Y8
~ unified   okiscape     dots  ~
'

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$ID"
    else
        echo "unknown"
    fi
}

. "$REPO_DIR/scripts/lib/ask.sh"
. "$REPO_DIR/scripts/lib/confirm.sh"
. "$REPO_DIR/scripts/lib/menu.sh"

DISTRO=$(detect_distro)
echo " > distro detected: $DISTRO" >&2

if [ "$(id -u)" == 0 ]; then
  echo " ! root perms detected"
fi

if [ "$DISTRO" = "nixos" ]; then
    STAGE=$(menu "select stage:" \
        "install configuration")
else
    STAGE=$(menu "select stage:" \
        "install configuration"\
        "full system installation")
fi

echo " > stage: $STAGE" >&2

case "$DISTRO" in
    nixos)
        cd "$REPO_DIR/hosts/nixos-desktop"
        sh "hosts/nixos-desktop/install.sh"
        ;;

    ubuntu|debian)
        case "$STAGE" in
            "full system installation")
                sh "$REPO_DIR/hosts/ubuntu-server/root.sh"
                ;;
            "install configuration")
                sh "$REPO_DIR/hosts/ubuntu-server/install.sh"
                ;;
        esac
        ;;

    arch)
        case "$STAGE" in
            "full system installation")
                sh "$REPO_DIR/hosts/arch-desktop/root.sh"
                ;;
            "install configuration")
                sh "$REPO_DIR/hosts/arch-desktop/install.sh"
                ;;
        esac
        ;;

    *)
        echo " ! this dots doesnt know '$DISTRO' yet" >&2
        exit 1
        ;;
esac

echo " ! All done"
