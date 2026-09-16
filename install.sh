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

ask() {
    prompt="$1"
    default="${2:-}"
    printf '%s [%s]: ' "$prompt" "$default" >&2
    read -r answer
    echo "${answer:-$default}"
}

confirm() {
    printf '%s [Y/n]: ' "$1" >&2
    read -r answer
    case "$answer" in
        n|N|no) return 1 ;;
        *) return 0 ;;
    esac
}

DISTRO=$(detect_distro)
echo " > distro detected: $DISTRO" >&2
echo

case "$DISTRO" in
    nixos)
        sh "$REPO_DIR/scripts/nix/install.sh"
        ;;

    ubuntu|debian)
        if confirm " ? does this machine needs gui?"; then
            PROFILE="server"
        else
            PROFILE="desktop"
        fi
        sh "$REPO_DIR/scripts/install-debian.sh" "$PROFILE"
        ;;

    arch)
        sh "$REPO_DIR/scripts/install-arch.sh"
        ;;

    *)
        echo " ! this dots doesnt know '$DISTRO' yet" >&2
        exit 1
        ;;
esac

echo " ! All done"
