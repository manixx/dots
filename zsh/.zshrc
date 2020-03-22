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

#
# style options 
#

zstyle ':vcs_info:*'   check-for-changes true
zstyle ':vcs_info:*'   stagedstr '%F{green} •%f'
zstyle ':vcs_info:*'   unstagedstr '%F{red} •%f'
zstyle ':vcs_info:*'   formats '%F{red}%b%c%u%f'
zstyle ':completion:*' special-dirs true # add slash on ./ ../

#
# functions
#

vcs_data() { # print branch name 
  vcs_info

  if [ -n "$vcs_info_msg_0_" ]; then
    echo " | ${vcs_info_msg_0_}"
  fi
}

k8s_data() { # print k8s context 
  echo " | %F{green}$(kubectl config current-context)%f"
}

n() { # launch nnn 
  export NNN_TMPFILE=~/.config/nnn/.lastd
  nnn "$@"
  if [ -f $NNN_TMPFILE ]; then
    . $NNN_TMPFILE
    rm -f $NNN_TMPFILE
  fi
}

#
# prompt
#

# todo why copy PROMPT? 
function zle-line-init zle-keymap-select {
  VIM_PROMPT="%B%F{yellow}[NORMAL]%f%b "
  RPROMPT='${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/}%F{8}[${?}]%f %F{magenta}%~%f$(vcs_data)'
  zle reset-prompt
}

PROMPT='%F{8}$(date +"[%H:%M:%S]")%f %F{green}→%f '
RPROMPT='%F{magenta}%~%f$(vcs_data)'

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

#
# global settings  
#

export EDITOR=nvim
export GOPATH=~/dev/go
export NNN_TRASH=1 # use trash-cli
export NNN_USE_EDITOR=1
export NVM_DIR=~/.nvm
export FZF_DEFAULT_COMMAND='find'
#export FZF_DEFAULT_COMMAND='find \
  #--type f \
  #--hidden \
  #--follow \
  #--exclude .git \
  #--exclude .cache \
  #--exclude node_modules
#'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='
  --color fg:7,bg:-1,hl:5,fg+:7,bg+:-1,hl+:7
  --color info:4,prompt:5,spinner:3,pointer:6,marker:2
'

#
# setup dircolors 
#

[ -e ~/.config/zsh/.dircolors ] && eval $(dircolors -b ~/.config/zsh/.dircolors) || 
  eval $(dircolors -b)

#
# launch i3 
#  

if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx
fi
