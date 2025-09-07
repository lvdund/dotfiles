# lvdund dotfiles

A comprehensive collection of configuration files for Linux development environments, supporting both Debian/Ubuntu and Arch Linux systems.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Cleanup](#cleanup)
- [Configuration](#configuration)
- [Additional Software](#additional-software)
- [Desktop Environments](#desktop-environments)
- [Auto Mount Disk](#auto-mount-disk)

## Prerequisites

### Required Packages

Install the following packages before proceeding:

- **stow** - For managing dotfiles symlinks
- **fzf & ripgrep** - Required for [Telescope](https://github.com/nvim-telescope/telescope.nvim)
- **trash-cli** - Replaces rm in [neo-tree](https://github.com/nvim-neo-tree/neo-tree.nvim)
- **Lazygit, Lazydocker** - Git and Docker TUI tools
- **Neovim v0.10+** - Modern text editor
- **tmux** - Terminal multiplexer

### System-Specific Installation

#### Ubuntu/Debian

```bash
# Core system packages
sudo apt install -y xorg i3 i3status i3lock xinit lightdm

# Development and utility packages
sudo apt install -y stow git fzf ripgrep trash-cli tmux wl-clipboard kitty fish \
    wget curl xclip rofi feh maim lsd playerctl gparted thunar \
    xarchiver gvfs pavucontrol gcc g++ linux-headers-amd64 lxappearance

# Install Neovim (latest version)
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
```

#### Arch Linux

```bash
paru -S stow git fzf ripgrep trash-cli lazygit lazydocker neovim wl-clipboard \
    kitty tmux extension-manager xclip ibus-bamboo lsd bash-completion maim \
    clang rofi
```

### Input Method (IBus-Bamboo)

For Vietnamese input support:

```bash
echo 'deb http://download.opensuse.org/repositories/home:/lamlng/Debian_12/ /' | \
    sudo tee /etc/apt/sources.list.d/home:lamlng.list

curl -fsSL https://download.opensuse.org/repositories/home:lamlng/Debian_12/Release.key | \
    gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_lamlng.gpg > /dev/null

sudo apt update
sudo apt install ibus-bamboo
ibus restart

env DCONF_PROFILE=ibus dconf write /desktop/ibus/general/preload-engines \
    "['BambooUs', 'Bamboo']" && \
    gsettings set org.gnome.desktop.input-sources sources \
    "[('xkb', 'us'), ('ibus', 'Bamboo')]"
```

### Fonts Installation

```bash
# Download and install Nerd Fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraCode.zip
unzip FiraCode.zip -d FiraCode
sudo mv FiraCode /usr/share/fonts/opentype/

# Install system fonts
sudo apt install fonts-dejavu fonts-liberation fonts-noto fonts-noto-core \
    fonts-freefont-ttf fonts-font-awesome fonts-noto-color-emoji
```

## Cleanup

Remove existing configuration files before installation:

```bash
rm ~/.bashrc
rm ~/.tmux.conf
rm -rf ~/.tmux
rm -rf ~/.config/kitty
rm -rf ~/.config/fish
rm -rf ~/.config/i3
rm -rf ~/.config/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.local/share/nvim
rm -rf ~/.cache/nvim
```

## Installation

### Clone and Setup Dotfiles

```bash
git clone https://github.com/lvdund/dotfiles.git ~/.dotfiles
cd ~/.dotfiles 

# Apply configurations using stow
stow bash_debian  # or bash_arch for Arch systems
stow nvim
stow tmux
stow kitty
stow fish
stow i3

cd
source ~/.bashrc
```

## Additional Software

### LibreWolf Browser

```bash
sudo apt update && sudo apt install extrepo -y
sudo extrepo enable librewolf
sudo apt update && sudo apt install librewolf -y
```

### Go Development Environment

#### Python Vir Env

```bash
mkdir -p ~/env/pyenv/
sudo apt install python3-venv -y
python3 -m venv main
```

#### Install Go

```bash
# Create Go directory structure
mkdir -p ~/env/golang/gopath/go1.24.4/{bin,pkg,src}
mkdir -p ~/env/golang/goroot

# Download and install Go
wget https://dl.google.com/go/go1.24.4.linux-amd64.tar.gz
tar -C ~/env/golang/goroot -zxvf go1.24.4.linux-amd64.tar.gz
mv ~/env/golang/goroot/go ~/env/golang/goroot/go1.24.4

# Clean up
rm go1.24.4.linux-amd64.tar.gz
```

#### Install Go Tools

```bash
go install golang.org/x/tools/gopls@latest
go install github.com/go-delve/delve/cmd/dlv@latest
go install mvdan.cc/gofumpt@latest
go install mvdan.cc/sh/v3/cmd/shfmt@latest
go install golang.org/x/tools/cmd/goimports@latest
go install github.com/fatih/gomodifytags@latest
go install github.com/jesseduffield/lazygit@latest
go install github.com/jesseduffield/lazydocker@latest
go install github.com/josharian/impl@latest
```

### Java Development Environment

```bash
# Install Maven
wget https://dlcdn.apache.org/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.tar.gz
sudo tar -xvzf apache-maven-3.9.9-bin.tar.gz -C ~/env/java

# Install JDK
wget https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.tar.gz
sudo tar -xvzf jdk-21_linux-x64_bin.tar.gz -C ~/env/java
```

### Bash Language Server

```bash
npm i -g bash-language-server
```

## Desktop Environments

### Hyprland (Wayland)

```bash
paru -S hyprland hyprpaper waybar rofi swaync pavucontrol
```

### i3 Window Manager (Arch Linux)

```bash
paru -S i3-wm i3status dunst dmenu pavucontrol ttf-firacode-nerd feh maim thunar gvfs
```

### Zsh Setup (Debian 12)

```bash
sudo apt install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

## Auto Mount Disk

### Check Disk UUID

```bash
lsblk -o NAME,FSTYPE,UUID,MOUNTPOINT
# or
blkid
```

### Create Mount Point and Configure Auto-mount

```bash
# Create mount folder (replace "disk_name" with your desired name)
sudo mkdir -p /mnt/disk_name

# Edit fstab for auto-mounting
sudo nano /etc/fstab

# Add line (replace UUID and mount point as needed):
# UUID=your-disk-uuid  /mnt/disk_name  ext4  defaults  0  0
```

### Apply Mount Configuration

```bash
sudo systemctl daemon-reload
sudo mount -a
```

### Create usb boot

- [USBImager](https://gitlab.com/bztsrc/usbimager)

## Configuration Structure

This dotfiles repository includes configurations for:

- **bash_debian/** - Bash configuration for Debian/Ubuntu
- **bash_arch/** - Bash configuration for Arch Linux  
- **fish/** - Fish shell configuration
- **nvim/** - Neovim configuration with plugins
- **tmux/** - Terminal multiplexer configuration
- **kitty/** - Kitty terminal emulator configuration
- **i3/** - i3 window manager configuration
- **hyprland/** - Hyprland compositor configuration
- **zsh_debian/** - Zsh configuration for Debian systems

