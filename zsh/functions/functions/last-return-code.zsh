
last_return_code() {
	exit_code=$?
	color=8

	[[ $exit_code -ne 0 ]] && color=red
	echo "%F{$color}[$exit_code]%f"
}
