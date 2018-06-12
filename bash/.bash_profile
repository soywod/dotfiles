if [ -f ~/.bash_aliases ]; then
	source ~/.bash_aliases
fi

GIT_PROMPT_START="\[\e[36m\]\w\[\e[m\]"
GIT_PROMPT_END=" \[\e[31m\]➜\[\e[m\] "

if [ -f ~/.bash-git-prompt/gitprompt.sh ]; then
	source ~/.bash-git-prompt/gitprompt.sh
fi

export ANDROID_HOME="$HOME/Android/Sdk"
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
export FZF_DEFAULT_OPTS='--color fg:#494B53,bg:#fafafa,hl:#50a14f,fg+:#494B53,bg+:#f0f0f0,hl+:#50a14f,pointer:#f0f0f0,info:#4078f2,spinner:#4078f2,header:#4078f2,prompt:#a626a4'
export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH="$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
export PATH="$PATH:$ANDROID_HOME/tools"
export PATH="$PATH:$ANDROID_HOME/platform-tools"
export PATH="$HOME/.cargo/bin:$PATH"

