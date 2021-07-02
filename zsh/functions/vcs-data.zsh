zstyle ':vcs_info:git*+set-message:*' hooks git-untracked

+vi-git-untracked(){
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
        git status --porcelain | grep '??' &> /dev/null ; then
        # This will show the marker if there are any untracked files in repo.
        # If instead you want to show the marker only if there are untracked
        # files in $PWD, use:
        #[[ -n $(git ls-files --others --exclude-standard) ]] ; then
        hook_com[staged]+='%F{green} •%f'
    fi
}

vcs_data() { # print branch name 
  vcs_info

  if [ -n "$vcs_info_msg_0_" ]; then
    echo " %F{8}| git%f %B${vcs_info_msg_0_}%b"
  fi
}
