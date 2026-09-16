# /bin/bash

set -g fish_greeting

starship init fish | source

fish_add_path ~/.local/bin
fish_add_path ~/.local/share/pnpm

set -gx EDITOR nvim
