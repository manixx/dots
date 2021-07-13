zstyle ':vcs_info:*'                  check-for-changes true
zstyle ':vcs_info:*'                  stagedstr         '#[fg=colour4] •#[fg=default]'
zstyle ':vcs_info:*'                  unstagedstr       '#[fg=colour1] •#[fg=default]'
zstyle ':vcs_info:*'                  formats           '#[fg=colour3]%b%c%u#[fg=default]'
zstyle ':vcs_info:git*+set-message:*' hooks             git-untracked

+vi-git-untracked(){
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
        git status --porcelain | grep '??' &> /dev/null ; then
        hook_com[staged]+='#[fg=colour2] •#[fg=default]'
    fi
}

vcs_data() { # print branch name 
  vcs_info

  if [ -n "$vcs_info_msg_0_" ]; then
    echo " %F{8}| git%f %B${vcs_info_msg_0_}%b"
  fi
}

vcs_data_tmux() { # print branch name 
  vcs_info

  if [ -n "$vcs_info_msg_0_" ]; then
    echo " #[fg=colour8]| git #[fg=colour2,bold]${vcs_info_msg_0_}"
  fi
}
