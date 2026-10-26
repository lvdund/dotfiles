#!/bin/sh

FONT_DIR=/usr/local/share/fonts/FiraCodeNerd
FONT_ARCHIVE=/tmp/FiraCode.zip

sudo mkdir -p "$FONT_DIR"

wget -O "$FONT_ARCHIVE" \
  https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip

sudo unzip -o "$FONT_ARCHIVE" \
  -d "$FONT_DIR"

sudo fc-cache -fv

fc-list | grep -i "FiraCode Nerd"
