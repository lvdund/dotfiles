#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '

# alias
# alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ls='lsd'
alias v='nvim'
alias grep='grep --color=auto'
alias cls="printf '\033[2J\033[3J\033[1;1H'"
alias gs='git status'
alias paru-clean='paru -Rns $(paru -Qtdq)'
alias vbash='nvim /home/vd/.bashrc'

# bash auto complete
complete -cf sudo

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

# nodejs
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

