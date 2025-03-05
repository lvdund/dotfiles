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
    sudo apt install -y stow git fzf ripgrep trash-cli tmux
    ## Lazygit
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit -D -t /usr/local/bin/
    ## Neovim
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    sudo rm -rf /opt/nvim
    sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
    rm nvim-linux-x86_64.tar.gz
    ## Then add this to your shell config (~/.bashrc, ~/.zshrc, ...):
    echo 'export PATH=$PATH:/opt/nvim-linux-x86_64/bin' >> .bashrs
    ```
    - Arch
    ```bash
    paru -S stow git fzf ripgrep trash-cli lazygit neovim wl-clipboard kitty tmux
    ```

- Clean
```bash
rm ~/.bashrc
rm ~/.tmux.conf
rm -rf ~/.tmux
rm -rf ~/.config/kitty
rm -rf ~/.config/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.local/share/nvim
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
mkdir -p ~/env/golang/gopath/go1.23.6/{bin,pkg,src}
mkdir -p ~/env/golang/goroot/go1.23.6
wget https://dl.google.com/go/go1.23.6.linux-amd64.tar.gz
sudo tar -C ~/env/golang/goroot/go1.23.6 -zxvf go1.23.6.linux-amd64.tar.gz
```
- Install Golang dependencies:
```bash
go install golang.org/x/tools/gopls@latest
go install mvdan.cc/gofumpt@latest
go install golang.org/x/tools/cmd/goimports@latest
go install github.com/fatih/gomodifytags@latest
## Lazydocker
go install github.com/jesseduffield/lazydocker@latest
```
