#!/bin/sh

# wget https://dl.google.com/go/go1.26.2.linux-amd64.tar.gz
# sudo tar -C /usr/local -zxvf go1.26.2.linux-amd64.tar.gz
# mkdir -p ~/env/gopath_main/{bin,pkg,src}



DOTFILES_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd) || exit 1

cd "$HOME/.config" || exit 1

rm -rf nvim fish kitty sway greetd waybar tmux

stow --dir="$DOTFILES_DIR" --target="$HOME/.config" config

FISH_SHELL=$(command -v fish) || {
    echo "fish is not installed" >&2
    exit 1
}
[ "$SHELL" = "$FISH_SHELL" ] || chsh -s "$FISH_SHELL"
