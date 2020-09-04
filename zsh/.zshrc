#
# zsh config 
# Manfred Mjka <manixx90@gmail.com>
# 

autoload -Uz compinit promptinit vcs_info edit-command-line bashcompinit

compinit -d ~/.cache/zsh/zcompdump
promptinit
bashcompinit

setopt prompt_subst      # to enable functions in prompt
zle -N edit-command-line # to edit command in $EDITOR
zle -N zle-line-init     # call on init (setting PROMPT to inital)
zle -N zle-keymap-select # call on vim selection mode change

# ignore commands with space prefixed 
setopt HIST_IGNORE_SPACE

#
# external sources 
#

source /usr/share/bash-completion/completions
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/fzf/completion.zsh
source /usr/share/fzf/key-bindings.zsh
source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

if [ -f ~/.vim/plugged/edge/zsh/.zsh-pure-power-light ]; then 
  source ~/.vim/plugged/edge/zsh/.zsh-pure-power-light
fi 

if [ -f /opt/az-cli/az.completion ]; then
  source /opt/az-cli/az.completion
fi 

if [ -f /opt/google-cloud-sdk/completion.zsh.inc ]; then
  source /opt/google-cloud-sdk/completion.zsh.inc
fi 

#
# key bindings 
#

bindkey -v 
bindkey '^j' up-history
bindkey '^k' down-history
bindkey '^w' backward-kill-word
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line 
bindkey '^h' backward-word 
bindkey '^l' forward-word
bindkey '^o' edit-command-line
bindkey '^p' clear-screen
bindkey "^?" backward-delete-char # delete chars after mode switch 

bindkey -s '^b' 'n^M' # launch nnn

if command -v k9s &> /dev/null; then 
	bindkey -s '^k' 'k9s^M'
fi

#
# style options 
#

zstyle ':vcs_info:*'             check-for-changes true
zstyle ':vcs_info:*'             stagedstr '%F{green} •%f'
zstyle ':vcs_info:*'             unstagedstr '%F{red} •%f'
zstyle ':vcs_info:*'             formats '%F{yellow}%b%c%u%f'
zstyle ':completion:*'           special-dirs true # add slash on ./ ../
zstyle ':completion:*'           rehash true
zstyle ':completion::complete:*' gain-privileges 1

#
# functions
#

last_cmd_timestamp='' 

preexec() {
	last_cmd_timestamp=$(date +%s) 
}

last_cmd_exec_time() {
	if [ -n "$last_cmd_timestamp" ]; then
		now=$(date +%s)
		exec_time=$(expr $now - $last_cmd_timestamp)
		measurement="s"

		if [ "$exec_time" -ge "60" ]; then 
			exec_time=$(expr $exec_time / 60)
			measurement="m"
		fi 

		if [ $exec_time -ge 60 ] && [ $measurement == "m" ]; then 
			exec_time=$(expr $exec_time / 60)
			measurement="h"
		fi

		echo " %F{8}[$exec_time$measurement]%f"
	fi 
}

reset_last_cmd_timestamp () {
	last_cmd_timestamp=''
  zle .accept-line
}
zle -N accept-line reset_last_cmd_timestamp

vcs_data() { # print branch name 
  vcs_info

  if [ -n "$vcs_info_msg_0_" ]; then
    echo " %F{8}| git%f %B${vcs_info_msg_0_}%b"
  fi
}

k8s_data() { # print k8s context 
	if command -v kubectl &> /dev/null; then	
		echo " %F{8}| k8s%f %F{green}$(kubectl config current-context)%f"
	fi
}

n() { # launch nnn 
  export NNN_TMPFILE=~/.config/nnn/.lastd
  nnn -A -d -H "$@" 
  if [ -f $NNN_TMPFILE ]; then
    . $NNN_TMPFILE
    rm -f $NNN_TMPFILE
  fi
}

last_return_code() {
	exit_code=$?
	color=8

	[[ $exit_code -ne 0 ]] && color=red
	echo "%F{$color}[$exit_code]%f"
}

current_date() {
	echo "%F{8}$(date +"[%H:%M:%S]")%f"
}

#
# prompt
#

function zle-line-init zle-keymap-select {
  VIM_PROMPT="%B%F{yellow}[NORMAL]%f%b "
	RPROMPT='${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/}$(last_return_code)$(last_cmd_exec_time)'
  zle reset-prompt
}

PROMPT='%F{magenta}%~%f$(vcs_data)$(k8s_data)'$'\n''$(current_date) %F{green}%B→%b%f '
RPROMPT="" # needs to bet set - otherwise its zle-line-init is not loaded on startup

#
# history settings
#

HISTFILE=~/.cache/zsh/zhistory
HISTSIZE=1000
SAVEHIST=5000
HISTCONTROL=ignorespace
KEYTIMEOUT=1

#
# aliases 
#

alias ls="exa"
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"
alias dev="cd ~/dev" 
alias downloads="cd ~/downloads"
alias dockerc="docker-compose"

alias gco="git checkout"
alias kctl="kubectl"

#
# global settings  
#

export EDITOR=nvim
export GOPATH=~/dev/go
export NNN_TRASH=1 # use trash-cli
export NNN_USE_EDITOR=1
export NVM_DIR=~/.nvm
export FZF_DEFAULT_COMMAND='fd \
	--type f \
	--hidden \
	--follow \
	--exclude .git \
	--exclude .cache \
	--exclude node_modules
'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden . ~'
export FZF_DEFAULT_OPTS='
  --color fg:8,bg:-1,hl:5,fg+:7,bg+:-1,hl+:7
  --color info:4,prompt:5,spinner:3,pointer:6,marker:2
'
STARTX_LOG='~/.local/share/xorg/startx.log'

#
# setup dircolors 
#

[ -e ~/.config/zsh/.dircolors ] && eval $(dircolors -b ~/.config/zsh/.dircolors) || 
  eval $(dircolors -b)

#
# launch i3 
#  

if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
	if [[ -f $STARTX_LOG ]]; then mv -f $STARTX_LOG $STARTX_LOG.old; fi
	exec startx 1> ~/.local/share/xorg/startx.log 2>&1
fi

