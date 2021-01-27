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

export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:/opt/android-studio/gradle/gradle-4.4/bin
export PATH=$PATH:~/.local/bin
export PATH=$PATH:~/.yarn/bin
export PATH=$PATH:~/.npm-global/bin
export PATH=$PATH:~/.gem/ruby/2.6.0/bin
export PATH=$PATH:/opt/platform-tools
export PATH=$PATH:/opt/flutter/bin

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

export GOOGLE_APPLICATION_CREDENTIALS='/home/soywod/Documents/service-account-file.json'
export GPG_TTY=`tty`

if [ -f ~/.bash-git-prompt/gitprompt.sh ]; then
	source ~/.bash-git-prompt/gitprompt.sh
fi

if [ -f ~/.bash_aliases ]; then
	source ~/.bash_aliases
fi

if [ -f /usr/share/bash-completion/bash_completion ]; then
	source /usr/share/bash-completion/bash_completion
fi

eval "$(stack --bash-completion-script stack)"

if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx
fi

# [ -f ~/.fzf.bash ] && source ~/.fzf.bash

export PATH="$HOME/.cargo/bin:$PATH"

# opam configuration
test -r /home/soywod/.opam/opam-init/init.sh && . /home/soywod/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true

# >>> coursier install directory >>>
export PATH="$PATH:/home/soywod/.local/share/coursier/bin"
# <<< coursier install directory <<<
