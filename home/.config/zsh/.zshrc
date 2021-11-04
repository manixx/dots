path=(
	~/.local/bin 
	~/.npm-global/bin
	~/go/bin
	$path[@]
)

################################################################################
# zsh options
################################################################################

autoload -Uz \
	compinit \
	promptinit \
	vcs_info \
	edit-command-line \
	bashcompinit

compinit -d ~/.cache/zsh/zcompdump
promptinit
bashcompinit

setopt INC_APPEND_HISTORY   # add commands directly to history (not on closing)
setopt HIST_IGNORE_SPACE    # ignore commands with space prefixed
setopt HIST_FIND_NO_DUPS    # skip duplicates in history file
setopt HIST_IGNORE_ALL_DUPS # do not write duplicates to history file
setopt SHARE_HISTORY        # share history between sessions
setopt PROMPT_SUBST         # to enable functions in prompt
setopt AUTO_CD              # just use .. and omit cd

ZLE_RPROMPT_INDENT=0           # disable right padding in prompt
KEYTIMEOUT=1                   # make vi mode transitions faster
HISTFILE=~/.cache/zsh/zhistory # hint: must be created manually
HISTSIZE=1000
SAVEHIST=5000

zle -N edit-command-line # to edit command in $EDITOR

zstyle ':completion:*'           special-dirs true                     # add slash on ./ ../
zstyle ':completion::complete:*' gain-privileges 1                     # auto-complete sudo cmds
zstyle ':completion:*'           rehash true                           # update external commands on every search
zstyle ':completion:*'           matcher-list '' 'm:{a-zA-Z}={A-Za-z}' # case insenstiive

################################################################################
# prompt
################################################################################

zle -N zle-line-init     # call on init (setting PROMPT to init)
zle -N zle-keymap-select # call on vim selection mode change

function zle-line-init zle-keymap-select {
	VIM_PROMPT="%B%F{yellow}[NORMAL]%f%b"
	RPROMPT='${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/} \
$(last_exit)\
$(last_cmd_exec_time)'
	zle reset-prompt
}

PROMPT='%F{magenta}%~%f\
$(vcs_data)\
$(k8s_context)\
$(check_jobs)\
'$'\n''\
%F{green}%B→%b%f '
RPROMPT="" # needs to bet set for zle-line-init is not loaded on startup

################################################################################
# external sources 
################################################################################

plugins=(
	/usr/share/bash-completion/completions
	/usr/share/doc/fzf/completion.zsh
	/usr/share/doc/fzf/key-bindings.zsh
	/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

	~/dev/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

	/opt/google-cloud-sdk/completion.zsh.inc 
	/opt/google-cloud-sdk/path.zsh.inc
	/opt/azure-cli/az.completion
)

for file in ${plugins[@]}; do 
	[[ ! -r $file ]] && continue
	source "$file"
done

for file in ~/.config/zsh/functions/*.zsh; do 
	source "$file"
done

################################################################################
# aliases
################################################################################

alias ls="exa"
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -I --one-file-system"
alias cat="bat"
alias kctl="kubectl"
alias dockerc="docker-compose"
alias gco="git checkout"
alias sv-user="SVDIR=~/.config/service sv" 
alias sv-x="SVDIR=~/.config/x-service sv"

################################################################################
# key bindings
################################################################################

bindkey -v                        # vim bindings
bindkey '^?' backward-delete-char # delete chars after mode switch
bindkey '^j' up-history
bindkey '^k' down-history
bindkey '^w' backward-kill-word
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
bindkey '^h' backward-word
bindkey '^l' forward-word
bindkey '^o' edit-command-line
bindkey '^p' clear-screen

bindkey -s '^b' 'launch_nnn^M' 

################################################################################
# settings
################################################################################

export EDITOR=nvim

# fzf
export FZF_DEFAULT_COMMAND='fd \
	--type f \
	--hidden \
	--follow \
	--no-ignore \
	--exclude .git \
	--exclude .cache'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd \
	--type d \
	--hidden . \
	--no-ignore \
	--exclude .git \
	--exclude .cache \
	~'
export FZF_DEFAULT_OPTS='
  --color fg:8,bg:-1,hl:5,fg+:7,bg+:-1,hl+:7
  --color info:4,prompt:5,spinner:3,pointer:6,marker:2'

# nnn
export NNN_TRASH=1         # use trash-cli
export NNN_USE_EDITOR=1
export NNN_NO_AUTOSELECT=1 # disable auto-select in navigate-as-you-type

################################################################################
# init
################################################################################

STARTX_LOG="$HOME/.local/share/xorg/startx.log"

if [[ ! $DISPLAY && $(tty) == "/dev/tty1" ]]; then
	[[ -f $STARTX_LOG ]] && mv -f $STARTX_LOG $STARTX_LOG.old
	exec startx 1> $STARTX_LOG 2>&1
fi

# launch tmux if display is set (x server running), interactive and 
# no tmux session is running. Force utf-8 output (-u).
if [[ ! -z $DISPLAY ]] && [[ $- == *i* ]] && [[ -z "$TMUX" ]]; then
	exec tmux -u
fi