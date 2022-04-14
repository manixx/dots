k8s_context() {
	if [ -f ~/.kube/config ]; then
		local context=`cat ~/.kube/config | grep -o -P '(?<=current-context: ).*'`
		if [[ ${context} != "\"\"" ]]; then
			echo " %F{8}| k8s%f %F{6}${context}%f"
		fi
	fi
}
