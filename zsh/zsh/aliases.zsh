#!/bin/zsh

## navigation aliases
alias dev="cd ~/jam-dev/"
alias home="cd ~/jam-dev/home/"
alias study="cd ~/jam-dev/study/in7/"
alias work="cd ~/jam-dev/work/cris/"

## other
alias du='du -sh'
alias df='df -h'
alias ffs='sudo !!'
alias myip='curl http://ipecho.net/plain; echo'
alias c="cht.sh"
alias copy="pbcopy"
alias brewup="brew update; brew upgrade; brew cleanup; brew doctor"
alias vimup="brew upgrade neovim --fetch-HEAD"
alias grep="rg"
alias grip="grip -b"
alias drawio="/Applications/draw.io.app/Contents/MacOS/draw.io"

## vim,tmux,zsh
alias vim='nvim'
alias v='nvim'
alias vimc="nvim ~/.config/nvim/init.lua"
alias tm=tmuxinator
alias zshconfig="nvim ~/.zshrc"
alias zshreload="source ~/.zshrc"
alias ssh="TERM=xterm-256color ssh" # needed for ssh to work properly

## terraform
alias tf='terraform'
alias tfv='terraform validate'
alias tfi='terraform init'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfm='terraform fmt -recursive'
