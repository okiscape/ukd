#!/usr/bin/env sh

# link_config <source> <target>
# symlink source to target.
# if target already exists and its content differs from source,
# it is backed up to target.bak first (target.bak.N if .bak is taken).

link_config() {
    SOURCE="$1"
    TARGET="$2"

    if [ -e "$TARGET" ] || [ -L "$TARGET" ]; then
        if ! cmp -s "$SOURCE" "$TARGET"; then
            BAK="$TARGET.bak"
            N=1
            while [ -e "$BAK" ] || [ -L "$BAK" ]; do
                BAK="$TARGET.bak.$N"
                N=$((N + 1))
            done
            mv "$TARGET" "$BAK"
            echo "  > existing $TARGET backed up to $BAK"
        fi
    fi

    ln -sf "$SOURCE" "$TARGET"
}
