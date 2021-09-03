check_jobs() {
	if jobs %% &> /dev/null; then 
		echo " %F{8}|%f %F{1}[%BACTIVE JOBS%b]%f"
	fi 
}
