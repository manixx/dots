zstyle ':vcs_info:*'                  formats           '%F{yellow}%b%c%u%f'
zstyle ':vcs_info:*'                  check-for-changes true
zstyle ':vcs_info:*'                  stagedstr         '%F{blue} •%f'
zstyle ':vcs_info:*'                  unstagedstr       '%F{red} •%f'
zstyle ':vcs_info:git*+set-message:*' hooks             git-untracked

+vi-git-untracked(){
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
        git status --porcelain | grep '??' &> /dev/null ; then
        hook_com[staged]+='%F{green} •%f'
    fi
}

vcs_data() { # print branch name 
  vcs_info

  if [ -n "$vcs_info_msg_0_" ]; then
    echo " %F{8}| git%f %B${vcs_info_msg_0_}%b"
  fi
}
