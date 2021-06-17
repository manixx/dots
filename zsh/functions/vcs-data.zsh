vcs_data() { # print branch name 
  vcs_info

  if [ -n "$vcs_info_msg_0_" ]; then
    echo " %F{8}| %f %B${vcs_info_msg_0_}%b"
  fi
}
