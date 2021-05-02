autoload -Uz \
	compinit \
	promptinit \
	vcs_info \
	edit-command-line \
	bashcompinit

compinit -d ~/.cache/zsh/zcompdump
promptinit
bashcompinit

typeset -U path          # enable path array

setopt prompt_subst      # to enable functions in prompt

zle -N edit-command-line # to edit command in $EDITOR
zle -N zle-line-init     # call on init (setting PROMPT to inital)
zle -N zle-keymap-select # call on vim selection mode change

path=(
  ~/.local/bin 
	~/.npm-global/bin
  $path[@]
)

################################################################################
# external sources 
################################################################################

plugins=(
	/usr/share/bash-completion/completions
	/usr/share/doc/fzf/completion.zsh
	/usr/share/doc/fzf/key-bindings.zsh
	/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

	~/dev/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
)

for file in ${plugins[@]}; do 
	source "${file}"
done

eval $(dircolors -b ~/.config/zsh/.dircolors)

# local zsh tools
for file in ~/.config/zsh/functions/*.zsh; do 
	source "${file}"
done

################################################################################
# key bindings
################################################################################

bindkey -v # vim bindings

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

bindkey -s '^b' 'launch_nnn^M' # launch nnn

################################################################################
# zstyle config
################################################################################

zstyle ':vcs_info:*'             check-for-changes true
zstyle ':vcs_info:*'             stagedstr '%F{green} •%f'
zstyle ':vcs_info:*'             unstagedstr '%F{red} •%f'
zstyle ':vcs_info:*'             formats '%F{yellow}%b%c%u%f'

zstyle ':completion:*'           special-dirs true			# add slash on ./ ../
zstyle ':completion:*'           rehash true
zstyle ':completion::complete:*' gain-privileges 1			# auto-complete sudo cmds
zstyle ':completion:*' 		 matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 	# case insensitive completion

################################################################################
# zsh options
################################################################################

# history
export HISTFILE=~/.cache/zsh/zhistory
export HISTSIZE=1000
export SAVEHIST=5000
export HISTCONTROL=ignorespace
setopt INC_APPEND_HISTORY   # add commands directly to history (no on closing)
setopt HIST_IGNORE_SPACE    # ignore commands with space prefixed
setopt HIST_FIND_NO_DUPS    # skip duplicates in history file
setopt HIST_IGNORE_ALL_DUPS # do not write duplicates to history file
setopt SHARE_HISTORY        # share history between sessions

# completion
ZLE_RPROMPT_INDENT=0	# disable right padding
KEYTIMEOUT=1 		# make vi mode transitions faster

################################################################################
# aliases
################################################################################

alias ls="exa"
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"
alias cat="bat"
alias kctl="kubectl"
alias dockerc="docker-compose"
alias gco="git checkout"

################################################################################
# tool options
################################################################################

# globals
export EDITOR=nvim

# fzf
export FZF_DEFAULT_COMMAND='fd \
	--type f \
	--hidden \
	--follow \
	--exclude .git \
	--exclude .cache \
	--exclude node_modules'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden . ~'
export FZF_DEFAULT_OPTS='
  --color fg:8,bg:-1,hl:5,fg+:7,bg+:-1,hl+:7
  --color info:4,prompt:5,spinner:3,pointer:6,marker:2'

# nnn
export NNN_TRASH=1 # use trash-cli

# bat 
export BAT_THEME="ansi"

################################################################################
# prompt
################################################################################

function zle-line-init zle-keymap-select {
  VIM_PROMPT="%B%F{yellow}[NORMAL]%f%b "
	RPROMPT='${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/}$(last_return_code)$(last_cmd_exec_time)'
  zle reset-prompt
}

PROMPT='%F{magenta}%~%f$(vcs_data)$(k8s_data)'$'\n''$(current_date) %F{green}%B→%b%f '
RPROMPT="" # needs to bet set - otherwise its zle-line-init is not loaded on startup

################################################################################
# startup
################################################################################

STARTX_LOG="$HOME/.local/share/xorg/startx.log"

if [[ ! $DISPLAY && $(tty) == "/dev/tty1" ]]; then
	[[ -f $STARTX_LOG ]] && mv -f $STARTX_LOG $STARTX_LOG.old
	exec startx 1> $STARTX_LOG 2>&1
fi

#
# launch tmux if display is set (x server running), interactive and 
# no tmux session is running
#

if [[ ! -z $DISPLAY ]] && [[ $- == *i* ]] && [[ -z "$TMUX" ]]; then
	exec tmux
fi
