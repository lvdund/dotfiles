sudo apt update -y

sudo apt install -y zip unzip tar wget curl stow net-tools \
    sway swaybg waybar fish kitty fuzzel greetd tuigreet \
    mesa-utils intel-media-va-driver \
    xwayland dbus-user-session polkitd \
    brightnessctl pavucontrol pipewire wireplumber \
    network-manager grim slurp wl-clipboard nautilus fastfetch \
    tmux git lsd \
    fcitx5 fcitx5-unikey fcitx5-config-qt

# curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

getent passwd _greetd
