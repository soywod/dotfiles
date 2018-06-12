# General
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias vimb='vim ~/.bashrc'
alias vimc='vim ~/.dotfiles/vim/vimrc'
alias krate='xset r rate 250 33'
alias dc='docker-compose'
alias o='xdg-open'
alias ga='git add'
alias gcm='git commit -m'
alias gcam='git commit -a -m'
alias gd='git diff'
alias gpush='git push'
alias gpull='git pull'
alias gco='git checkout'
alias glog='git log --oneline --decorate --graph'
alias gss='git status'

meteo() {
  while true; do
    METEO=`curl -s fr.wttr.in/chaville?T?1?q`
    clear
    echo "$METEO"
    sleep 60
  done
}

