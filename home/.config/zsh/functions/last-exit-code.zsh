last_exit() {
	local exit_code=$?
	local color=8 # gray

	[[ $exit_code -ne 0 ]] && color=red
	echo "%F{$color}[$exit_code]%f"
}
