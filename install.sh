#!/usr/bin/env sh
set -eu

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

detect_distro() {
    if [ -f /etc/os-release ]; then
        # shellcheck disable=SC1091
        . /etc/os-release
        echo "$ID"
    else
        echo "unknown"
    fi
}

ask() {
    # ask "вопрос" "default"
    prompt="$1"
    default="${2:-}"
    printf '%s [%s]: ' "$prompt" "$default" >&2
    read -r answer
    echo "${answer:-$default}"
}

confirm() {
    printf '%s [y/N]: ' "$1" >&2
    read -r answer
    case "$answer" in
        y|Y|yes) return 0 ;;
        *) return 1 ;;
    esac
}

DISTRO=$(detect_distro)
echo "Обнаружен дистрибутив: $DISTRO" >&2

case "$DISTRO" in
    nixos)
        echo "== NixOS =="
        HOST=$(ask "Имя хоста (flake output)" "$(hostname)")
        cd "$REPO_DIR/hosts/nixos-desktop"
        if confirm "Пересобрать систему сейчас (nixos-rebuild switch)?"; then
            sudo nixos-rebuild switch --flake ".#${HOST}"
        else
            echo "Ок, конфиг лежит в hosts/nixos-desktop, собери вручную:"
            echo "  sudo nixos-rebuild switch --flake .#${HOST}"
        fi
        ;;

    ubuntu|debian)
        echo "== Ubuntu/Debian =="
        if confirm "Это сервер (без GUI)?"; then
            PROFILE="server"
        else
            PROFILE="desktop"
        fi
        sh "$REPO_DIR/scripts/install-debian.sh" "$PROFILE"
        ;;

    arch)
        echo "== Arch Linux =="
        sh "$REPO_DIR/scripts/install-arch.sh"
        ;;

    *)
        echo "Дистрибутив '$DISTRO' не поддерживается" >&2
        exit 1
        ;;
esac

echo "Готово."
