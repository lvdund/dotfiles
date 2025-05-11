#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '

# alias
# alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ls='lsd -la'
alias v='nvim'
alias grep='grep --color=auto'
alias cls="printf '\033[2J\033[3J\033[1;1H'"
alias gs='git status'
alias paru-clean='paru -Rns $(paru -Qtdq)'
alias vbash='nvim /home/vd/.bashrc'
alias ssh-kitty='kitty +kitten ssh'
alias ssh-vagrant-kitty='TERM=xterm-256color vagrant ssh'
alias sbash='source ~/.bashrc'

# Use bash-completion, if available
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion

# golang
GoVer=go1.23.6
# GoVer=go1.24.0
if [ -z "$GoVer" ]; then
  echo "GoVer is not set. No export."
else
  export GOPATH=/home/vd/env/golang/gopath/$GoVer
  export GOROOT=/home/vd/env/golang/goroot/$GoVer
  export PATH=$PATH:$GOPATH/bin:$GOROOT/bin
  export GO111MODULE=auto
fi

# jdk21
# export JAVA_HOME="/home/vd/env/java/jdk-21.0.7"
# export PATH="$PATH:$JAVA_HOME/bin"
# maven
# export M2_HOME=/home/vd/env/java/apache-maven-3.9.9
# export PATH=$M2_HOME/bin:$PATH


