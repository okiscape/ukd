#!/usr/bin/env sh

menu() {
    prompt="$1"
    shift

    printf '\n ? %s\n\n' "$prompt" >&2

    i=1
    for opt in "$@"; do
        case "$opt" in
            \(disabled\):*)
                label="${opt#(disabled):}"
                printf '   %d) %s (unavailable)\n' "$i" "$label" >&2
                ;;
            *)
                printf '   %d) %s\n' "$i" "$opt" >&2
                ;;
        esac
        i=$((i + 1))
    done

    printf '\n' >&2

    while true; do
        printf ' > choice [1-%d]: ' "$((i - 1))" >&2
        if ! read -r choice; then
            printf ' ! aborted\n' >&2
            return 1
        fi

        if [ -z "$choice" ]; then
            choice=1
        fi

        if [ "$choice" -ge 1 ] 2>/dev/null && [ "$choice" -le "$((i - 1))" ] 2>/dev/null; then
            j=1
            for opt in "$@"; do
                if [ "$j" -eq "$choice" ]; then
                    case "$opt" in
                        \(disabled\):*)
                            printf ' ! this option is unavailable\n' >&2
                            ;;
                        *)
                            echo "$opt"
                            return 0
                            ;;
                    esac
                fi
                j=$((j + 1))
            done
        else
            printf ' ! invalid choice\n' >&2
        fi
    done
}
