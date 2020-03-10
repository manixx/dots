typeset -U path

path=(
  ~/.bin 
  ~/.npm-global/bin
  ~/.gem/ruby/2.6.0/bin
  ~/dev/go/bin
  /opt/google-cloud-sdk/bin
  /opt/az-cli/bin
  $path[@]
)

ZDOTDIR=~/.config/zsh
