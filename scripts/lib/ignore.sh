#!/usr/bin/env sh

# ukd_ignore_load <file>
# loads program names that must not have their configuration installed.
ukd_ignore_load() {
    if [ "$#" -ne 1 ]; then
        echo " ! ukd_ignore_load: expected one file path" >&2
        return 2
    fi

    UKD_IGNORE_FILE=$1
    UKD_IGNORED_CONFIGS=

    if [ ! -e "$UKD_IGNORE_FILE" ]; then
        return 0
    fi

    if [ ! -f "$UKD_IGNORE_FILE" ] || [ ! -r "$UKD_IGNORE_FILE" ]; then
        echo " ! cannot read ignore file: $UKD_IGNORE_FILE" >&2
        return 1
    fi

    while IFS='	 ' read -r UKD_IGNORE_NAME UKD_IGNORE_REST ||
        [ -n "${UKD_IGNORE_NAME:-}${UKD_IGNORE_REST:-}" ]; do
        case "$UKD_IGNORE_NAME" in
            ''|'#'*)
                continue
                ;;
        esac

        case "$UKD_IGNORE_REST" in
            ''|'#'*) ;;
            *)
                echo " ! invalid entry in $UKD_IGNORE_FILE: $UKD_IGNORE_NAME $UKD_IGNORE_REST" >&2
                return 2
                ;;
        esac

        UKD_IGNORED_CONFIGS="${UKD_IGNORED_CONFIGS}${UKD_IGNORE_NAME}
"
    done < "$UKD_IGNORE_FILE"
}

# ukd_is_ignored <program>
# Returns success when the exact program name is listed in .ukdignore.
ukd_is_ignored() {
    if [ "$#" -ne 1 ] || [ -z "$1" ]; then
        return 1
    fi

    case "
${UKD_IGNORED_CONFIGS:-}
" in
        *"$1
"*) return 0 ;;
        *) return 1 ;;
    esac
}
