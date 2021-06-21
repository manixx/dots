k8s_data() { # print k8s context 
	if command -v kubectl &> /dev/null; then	
		echo " %F{8}|  %f %F{green}$(kubectl config current-context)%f"
	fi
}
