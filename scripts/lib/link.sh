#!/usr/bin/env sh

# \/ by ai
# bak_name <path>
# prints a path.bak (or path.bak.N if .bak is taken) that does not exist yet
bak_name() {
    BAK="$1.bak"
    N=1
    while [ -e "$BAK" ] || [ -L "$BAK" ]; do
        BAK="$1.bak.$N"
        N=$((N + 1))
    done
    echo "$BAK"
}

# \/ by ai
# move_to_bak <path>
# renames a file or directory to a free *.bak name
move_to_bak() {
    BAK_PATH=$(bak_name "$1")
    mv "$1" "$BAK_PATH"
    echo "  > existing $1 backed up to $BAK_PATH"
}

# dirs already backed up as a whole during this run (colon-joined)
LINK_BAKED_DIRS=""

# \/ by ai
# already_baked <path>
# returns success if path was already backed up by this run
already_baked() {
    case ":$LINK_BAKED_DIRS:" in
        *":$1:"*) return 0 ;;
        *) return 1 ;;
    esac
}

# \/ by ai
# link_config <source> <target> [unit_dir]
# symlink source to target (parent dirs are created as needed).
# if target already exists and its content differs from source:
#   - with unit_dir: the whole unit_dir directory is renamed to *.bak once per
#     run, so user modifications inside the whole folder are preserved together;
#   - without: only the target file itself is renamed to *.bak.
link_config() {
    if [ "$#" -lt 2 ]; then
        echo " ! link_config: expected <source> <target> [unit_dir]" >&2
        return 2
    fi

    SOURCE="$1"
    TARGET="$2"
    UNIT_DIR="${3:-}"

    if [ -e "$TARGET" ] || [ -L "$TARGET" ]; then
        if ! cmp -s "$SOURCE" "$TARGET"; then
            if [ -n "$UNIT_DIR" ]; then
                if ! already_baked "$UNIT_DIR"; then
                    move_to_bak "$UNIT_DIR"
                    LINK_BAKED_DIRS="${LINK_BAKED_DIRS}:${UNIT_DIR}"
                fi
            else
                move_to_bak "$TARGET"
            fi
        fi
    fi

    mkdir -p "$(dirname "$TARGET")"
    ln -sf "$SOURCE" "$TARGET"
}

# \/ by ai
# link_dir <source_dir> <target_dir>
# links every file of source_dir into target_dir, mirroring the tree layout
# if target_dir exists and its contents differ from source_dir in any way
# (a file was changed, added or removed), the whole target_dir is renamed to
# *.bak before linking, so the user's modified copy is kept as a single folder
link_dir() {
    if [ "$#" -ne 2 ]; then
        echo " ! link_dir: expected <source_dir> <target_dir>" >&2
        return 2
    fi

    SOURCE_DIR="$1"
    TARGET_DIR="$2"

    if [ -e "$TARGET_DIR" ] || [ -L "$TARGET_DIR" ]; then
        if ! diff -rq "$SOURCE_DIR" "$TARGET_DIR" >/dev/null 2>&1; then
            move_to_bak "$TARGET_DIR"
        fi
    fi

    mkdir -p "$TARGET_DIR"

    while IFS= read -r FILE; do
        REL="${FILE#"$SOURCE_DIR"/}"
        link_config "$FILE" "$TARGET_DIR/$REL" "$TARGET_DIR"
    done <<EOF
$(find "$SOURCE_DIR" -type f)
EOF
}
