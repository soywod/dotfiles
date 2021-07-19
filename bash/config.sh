shopt -s autocd
shopt -s checkjobs
shopt -s checkwinsize
shopt -s cdspell

stty -ixon

export JAVA_HOME=/usr/lib/jvm/default
export JAVA_SDK=$JAVA_HOME
export JAVA_SDK=$JAVA_HOME/jre
export PATH=$PATH:$JAVA_HOME/bin
export ANDROID_HOME=/opt/android-sdk/
export ANDROID_SDK_ROOT=/opt/android-sdk/
export XDG_CURRENT_DESKTOP=sway
export XDG_SESSION_TYPE=wayland

export PATH=$PATH:$HOME/.emacs.d/bin
export PATH=$PATH:$HOME/.gem/ruby/2.6.0/bin
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/.npm-global/bin
export PATH=$PATH:$HOME/.yarn/bin
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:/opt/android-studio/gradle/gradle-4.4/bin
export PATH=$PATH:/opt/flutter/bin
export PATH=$PATH:/opt/platform-tools

prompt_color() {
  if [ -n "$IN_NIX_SHELL" ]; then
    echo "33"
  else
    echo "31"
  fi
}

export GIT_PROMPT_START="\[\e[36m\]\w\[\e[m\]"
export GIT_PROMPT_END=" \[\e[`prompt_color`m\]➜\[\e[m\] "

export HISTCONTROL=ignoreboth:erasedups
export HISTFILE=~/.bash_eternal_history
export HISTFILESIZE=-1
export HISTSIZE=-1
export HISTTIMEFORMAT="[%F %T] "

export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
export FZF_DEFAULT_OPTS='--color fg:#D8DEE9,bg:#2E3440,hl:#A3BE8C,fg+:#D8DEE9,bg+:#434C5E,hl+:#A3BE8C,pointer:#BF616A,info:#4C566A,spinner:#4C566A,header:#4C566A,prompt:#81A1C1,marker:#EBCB8B'

export GOOGLE_APPLICATION_CREDENTIALS="${HOME}/Documents/service-account-file.json"
export GPG_TTY=`tty`

if [ -f /usr/lib/bash-git-prompt/gitprompt.sh ]; then
  source /usr/lib/bash-git-prompt/gitprompt.sh
fi

if [ -f /usr/share/bash-completion/bash_completion ]; then
	source /usr/share/bash-completion/bash_completion
fi

if [ -f "${HOME}/.bash_aliases" ]; then
	source "${HOME}/.bash_aliases"
fi

eval "$(stack --bash-completion-script stack)"

[ -f "${HOME}/.fzf.bash" ] && source "${HOME}/.fzf.bash"

export PATH="${HOME}/.cargo/bin:$PATH"

# opam configuration
test -r ~/.opam/opam-init/init.sh && . ~/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true

# >>> coursier install directory >>>
export PATH="${PATH}:${HOME}/.local/share/coursier/bin"
# <<< coursier install directory <<<

# PAM GnuPG
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

# Pass store dir
export PASSWORD_STORE_DIR="${HOME}/Dropbox/password-store"

# Ledger journal file path
export LEDGER_FILE="${HOME}/Dropbox/hledger.journal"
