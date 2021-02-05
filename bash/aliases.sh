if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

alias dc='docker-compose'

alias ga='git add'
alias gcam='git commit --amend --no-edit'
alias gcams='gcam -S'
alias gcm='git commit -m'
alias gcms='git commit -S -m'
alias gco='git checkout'
alias gd='git diff'
alias glog='git log --oneline --decorate --graph'
alias gpull='git pull origin $(git rev-parse --abbrev-ref HEAD)'
alias gpush='git push origin $(git rev-parse --abbrev-ref HEAD)'
alias gfpush='gpush --force'
alias gss='git status'
alias grm='git pull origin master --rebase'

alias vi='nvim'
alias vim='nvim'
alias vimc='nvim ~/.config/nvim/init.vim'
alias vimd='nvim ~/.config/lexy/definitions.yml'
alias k='nvim +K'

alias s='source ~/.bashrc'

alias xcopy='xclip -selection clipboard'
alias xpaste='xclip -selection clipboard -o'

alias kb='setxkbmap -layout us,ru -variant "dvorak-alt-intl", -option grp:shifts_toggle && xset r rate 250 33'

alias rjpeg="exiv2 -r '%Y%m%d-%H%M%S-1' mv"
alias u="unfog"

alias vat-for="hledger bal --effective --monthly --cleared --tree --period"
