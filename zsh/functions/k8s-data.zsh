k8s_data() { # print k8s context 
	if command -v kubectl &> /dev/null; then	
		echo " %F{8}| k8s%f %F{green}$(kubectl config current-context)%f"
	fi
}
