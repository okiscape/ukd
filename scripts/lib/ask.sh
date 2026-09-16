#!/usr/bin/env sh

ask() {
    prompt="$1"
    default="${2:-}"
    printf '%s [%s]: ' "$prompt" "$default" >&2
    read -r answer
    echo "${answer:-$default}"
}
