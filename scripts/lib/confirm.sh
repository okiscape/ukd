#!/usr/bin/env sh

confirm() {
    prompt="$1"
    default="${2:-n}"

    case "$default" in
        y|Y) hint="Y/n" ;;
        *)   hint="y/N" ;;
    esac

    printf ' ? %s [%s]: ' "$prompt" "$hint" >&2
    read -r answer
    answer="${answer:-$default}"

    case "$answer" in
        y|Y|yes|Yes|YES) return 0 ;;
        *) return 1 ;;
    esac
}
