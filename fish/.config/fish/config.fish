# theme
fish_config theme choose "Dracula Official"

# fish env
set -U fish_greeting ""

if status is-interactive
    # Commands to run in interactive sessions can go here
end

# ========================= PATH setup =========================
set -x PATH /sbin $PATH
set -x PATH $HOME/.local/bin $PATH
set -x PATH $PATH /opt/nvim-linux-x86_64/bin

# ====================== Aliases (functions) ======================
abbr -a sfish 'source ~/.config/fish/config.fish'
abbr -a vfish 'nvim ~/.config/fish/config.fish'
function ls
    command lsd $argv
end 
function bat
    command batcat $argv
end 
function lsla
    command lsd -la $argv
end
function v
    command nvim $argv
end
function cls
    printf '\033[2J\033[3J\033[1;1H'
end
function grep
    command grep --color=auto $argv
end

abbr -a spython 'source ~/env/pyenv/main/bin/activate.fish'

# git
function ga
    git add $argv
end

function gs
    git status $argv
end

function gcm
    git commit -m $argv
end

function gcm-0
    git commit --allow-empty-message -m ''
end

# ssh
function ssh-kitty
    kitty +kitten ssh $argv
end

function ssh-vagrant-kitty
    env TERM=xterm-256color vagrant ssh $argv
end

# tmux
function tmux-create-ss
    tmux new -s $argv
end

function tmux-attach-last
    tmux attach-session
end

function tmux-attach
    tmux attach-session -t $argv
end

function tmux-ls
    tmux ls
end

function tmux-kill
    tmux kill-session -t $argv
end

function tmux-kill-all
    tmux kill-server
end

# ====================== env ======================
set GoVer go1.24.4
if test -z "$GoVer"
    echo "GoVer is not set. No export."
else
    set -x GOPATH /home/vd/env/golang/gopath/$GoVer
    set -x GOROOT /home/vd/env/golang/goroot/$GoVer
    set -x PATH $PATH $GOPATH/bin $GOROOT/bin
    set -x GO111MODULE auto
end

# Rust
set -x PATH $HOME/.cargo/bin $PATH

# vagrant
#set vagrant_completion (string match -r ".*/vagrant-[^/]+/contrib/bash/completion.sh" (ls /opt/vagrant/embedded/gems/gems/vagrant-*/contrib/bash/completion.sh))
#if test -f $vagrant_completion
#    bass source $vagrant_completion
#end


