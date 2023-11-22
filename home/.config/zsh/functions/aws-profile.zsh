aws_profile() {
	if [[ $AWS_PROFILE != "" ]]; then
		echo " %F{8}| aws%f %F{4}${AWS_PROFILE}%f"
	fi
}
