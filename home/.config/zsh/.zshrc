path=(
	~/.local/bin
	~/.npm-global/bin
	~/.krew/bin
	$(go env GOPATH)/bin
	$path[@]
)

fpath=(
	~/.config/zsh/completion
	$fpath[@]
)

autoload -Uz \
	compinit \
	promptinit \
	vcs_info \
	edit-command-line \
	bashcompinit

# Zsh cache stuff must be created beforehand
if [ ! -d ~/.cache/zsh ]; then
	mkdir -p ~/.cache/zsh
fi

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
HISTFILE=~/.cache/zsh/zhistory
HISTSIZE=1000
SAVEHIST=5000

# hist file must be created manually
if [ ! -f ${HISTFILE} ]; then
	mkdir -p $(dirname ${HISTFILE})
	touch ${HISTFILE}
fi

# Yank to the system clipboard while in normale mode
function vi-yank-xclip {
	zle vi-yank
	echo "$CUTBUFFER" | xclip -in -sel cli
}

zle -N edit-command-line # to edit command in $EDITOR
zle -N vi-yank-xclip

zstyle ':completion:*'           special-dirs true                     # add slash on ./ ../
zstyle ':completion::complete:*' gain-privileges 1                     # auto-complete sudo cmds
zstyle ':completion:*'           rehash true                           # update external commands on every search
zstyle ':completion:*'           matcher-list '' 'm:{a-zA-Z}={A-Za-z}' # case insensitive
zstyle ':completion:*'           menu select                           # show menu and select by tab

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
$(timew_status)\
$(check_jobs)\
'$'\n''\
%F{green}%B→%b%f '
RPROMPT="" # needs to bet set for zle-line-init is not loaded on startup

setopt +o nomatch # if folder doesn't exist, skip no matches found error
plugins=(
	/usr/share/bash-completion/completions
	/usr/share/fzf/*.zsh
	/usr/share/zsh/plugins/*/*.plugin.zsh

	/opt/google-cloud-sdk/completion.zsh.inc
	/opt/google-cloud-sdk/path.zsh.inc
	/opt/azure-cli/az.completion

	~/.config/zsh/functions/*.zsh
	~/.config/zsh/bash-completion/*
)
setopt -o nomatch

for file in ${plugins[@]}; do
	[[ ! -r $file ]] && continue
	source "$file"
done

alias ls="exa -g"
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -I --one-file-system"
alias cat="bat"
alias kctl="kubectl"
alias dockerc="docker compose"
alias gco="git checkout"
alias sv-user="SVDIR=~/.config/service sv"
alias sv-x="SVDIR=~/.config/x-service sv"

bindkey -v                            # vim bindings
bindkey '^?'    backward-delete-char  # delete chars after mode switch
bindkey '^[[Z'  reverse-menu-complete # on menu use shift+tab to go back
bindkey "\e[3~" delete-char           # delete char on delete key
bindkey '^j'    up-history
bindkey '^k'    down-history
bindkey '^w'    backward-kill-word
bindkey '^a'    beginning-of-line
bindkey '^e'    end-of-line
bindkey '^h'    backward-word
bindkey '^l'    forward-word
bindkey '^o'    edit-command-line
bindkey '^p'    clear-screen

bindkey -M vicmd "\e[3~" delete-char   # delete char on delete key
bindkey -M vicmd 'y'     vi-yank-xclip

bindkey -s '^[b' 'launch_nnn^M'
bindkey -s '^[n' 'tmux new-window newsboat^M'

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

# bat
export BAT_THEME="ansi"

if test -z "${XDG_RUNTIME_DIR}"; then
	export XDG_RUNTIME_DIR=/tmp/${UID}-runtime-dir
	if ! test -d "${XDG_RUNTIME_DIR}"; then
		mkdir "${XDG_RUNTIME_DIR}"
		chmod 0700 "${XDG_RUNTIME_DIR}"
	fi
fi

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
