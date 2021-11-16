shopt -s autocd
shopt -s checkjobs
shopt -s checkwinsize
shopt -s cdspell
shopt -s histappend

stty -ixon

prompt_color() {
  if [ -n "$IN_NIX_SHELL" ]; then
    echo "33"
  else
    echo "31"
  fi
}

export JAVA_HOME=/usr/lib/jvm/default
export JAVA_SDK=$JAVA_HOME
export JAVA_SDK=$JAVA_HOME/jre
export PATH=$PATH:$JAVA_HOME/bin
export ANDROID_HOME=/opt/android-sdk/
export ANDROID_SDK_ROOT=/opt/android-sdk/

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

export GIT_PROMPT_FETCH_REMOTE_STATUS=0
export GIT_PROMPT_IGNORE_SUBMODULES=1
export GIT_PROMPT_WITH_VIRTUAL_ENV=0
export GIT_PROMPT_SHOW_UNTRACKED_FILES="no"
export GIT_PROMPT_START="_LAST_COMMAND_INDICATOR_ \[\e[36m\]\W\[\e[m\]"
export GIT_PROMPT_END=" \[\e[$(prompt_color)m\]➜\[\e[m\] "
export GIT_PROMPT_COMMAND_OK=""

export HISTCONTROL=ignoreboth:erasedups
export HISTFILE=~/.bash_eternal_history
export HISTFILESIZE=-1
export HISTSIZE=-1
export HISTTIMEFORMAT="[%F %T] "

export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
export FZF_DEFAULT_OPTS='--color fg:#5b6268,bg:#282c34,hl:reverse:#ecbe7b,fg+:regular:#bbc2cf,bg+:#282c34,hl+:regular:reverse:#ecbe7b,pointer:#c678dd,info:#5b6268,spinner:#c678dd,header:#c678dd,prompt:regular:#46d9ff,marker:#ecbe7b'

export GOOGLE_APPLICATION_CREDENTIALS="${HOME}/Documents/service-account-file.json"
export GPG_TTY=`tty`

export LOCALE_ARCHIVE="/usr/lib/locale/locale-archive"

if [ -f "/usr/share/bash-completion/bash_completion" ]
then
	source "/usr/share/bash-completion/bash_completion"
fi

if [ -f "/usr/lib/bash-git-prompt/gitprompt.sh" ]
then
  source "/usr/lib/bash-git-prompt/gitprompt.sh"
fi

if [ -f "${HOME}/.bash_aliases" ]
then
	source "${HOME}/.bash_aliases"
fi

# Nix
if [ -f "${HOME}/.nix-profile/etc/profile.d/nix.sh" ]
then
	source "${HOME}/.nix-profile/etc/profile.d/nix.sh"
fi

eval "$(stack --bash-completion-script stack)"

[ -f "${HOME}/.fzf.bash" ] && source "${HOME}/.fzf.bash"

export PATH="${HOME}/.cargo/bin:$PATH"

# PAM GnuPG
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

# Pass store dir
export PASSWORD_STORE_DIR="${HOME}/Dropbox/password-store"

# Ledger journal file path
export LEDGER_FILE="${HOME}/Dropbox/hledger.journal"

# Swan config
# source ~/.swan.sh
source "/home/soywod/.rover/env"
