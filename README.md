#  lvdund dotfiles

## Requirement

- Install stow
- Install fzf & ripgrep for [Telescope](https://github.com/nvim-telescope/telescope.nvim)
- Replace rm by `trash-cli` in [neo-tree](https://github.com/nvim-neo-tree/neo-tree.nvim)
- Install Lazygit, Lazydocker
- Install Neovim v0.10+
- Install tmux
    - Ubuntu
    ```bash
    sudo apt install -y stow git fzf ripgrep trash-cli tmux wl-clipboard kitty wget curl i3 xclip rofi feh maim lsd playerctl baobab
    ## Neovim
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    sudo rm -rf /opt/nvim
    sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
    ```
    - Arch
    ```bash
    paru -S stow git fzf ripgrep trash-cli lazygit lazydocker neovim wl-clipboard kitty tmux extension-manager xclip ibus-bamboo lsd bash-completion maim clang rofi
    ```
- Install Ibus-Bamboo:
    ```bash
    echo 'deb http://download.opensuse.org/repositories/home:/lamlng/Debian_12/ /' | sudo tee /etc/apt/sources.list.d/home:lamlng.list
    curl -fsSL https://download.opensuse.org/repositories/home:lamlng/Debian_12/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_lamlng.gpg > /dev/null
    sudo apt update
    sudo apt install ibus-bamboo
    ibus restart
    env DCONF_PROFILE=ibus dconf write /desktop/ibus/general/preload-engines "['BambooUs', 'Bamboo']" && gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('ibus', 'Bamboo')]"
    ```
- Install FiraCode Nerd Font:
    ```bash
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraCode.zip
    unzip FiraCode.zip -d FiraCode
    sudo mv FiraCode /usr/share/fonts/opentype/
    ```

- Clean
```bash
rm ~/.bashrc
rm ~/.tmux.conf
rm -rf ~/.tmux
rm -rf ~/.config/kitty
rm -rf ~/.config/i3
rm -rf ~/.config/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.local/share/nvim
rm -rf ~/.cache/nvim
```

## Run

- Run with ```stow```
```bash
git clone https://github.com/lvdund/dotfiles.git ~/.dotfiles
cd ~/.dotfiles 
stow bash
stow nvim
stow tmux
stow kitty
cd
source ~/.bashrc
```
- Install golang
```bash
mkdir -p ~/env/golang/gopath/go1.24.4/{bin,pkg,src}
mkdir -p ~/env/golang/goroot
wget https://dl.google.com/go/go1.24.4.linux-amd64.tar.gz
tar -C ~/env/golang/goroot -zxvf go1.24.4.linux-amd64.tar.gz
mv ~/env/golang/goroot/go ~/env/golang/goroot/go1.24.4
# rm ~/go1.24.4.linux-amd64.tar.gz
```
- Install Golang dependencies:
```bash
go install golang.org/x/tools/gopls@latest
go install mvdan.cc/gofumpt@latest
go install golang.org/x/tools/cmd/goimports@latest
go install github.com/fatih/gomodifytags@latest
go install github.com/jesseduffield/lazygit@latest
go install github.com/jesseduffield/lazydocker@latest
```
- Install java:
```bash
wget https://dlcdn.apache.org/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.tar.gz
sudo tar -xvzf apache-maven-3.9.9-bin.tar.gz -C ~/env/java
wget https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.tar.gz
sudo tar -xvzf jdk-21_linux-x64_bin.tar.gz -C ~/env/java
```

## Hyprland

```bash
paru -S hyprland hyprpaper waybar rofi swaync pavucontrol
```

## i3 arch linux

```bash
paru -S i3-wm i3status dunst dmenu pwvucontrol ttf-firacode-nerd feh maim thunar gvfs
```

## Zsh - debian 12

```bash
sudo apt install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

## Auto mount disk

- check uuid
```bash
lsblk -o NAME,FSTYPE,UUID,MOUNTPOINT
# or
blkid
```

- create mount
```bash
# create mount folder
sudo mkdir -p /mnt/"?????"

# add auto mount
sudo nano /etc/fstab
# UUID=10e-b3-4e-88-ca5  /mnt/"?????"  ext4  defaults  0  0
```
a0c06ff8-d8d7-44b9-a522-83fb296cc60c
- mount
```bash
sudo systemctl daemon-reload
sudo mount -a
```
