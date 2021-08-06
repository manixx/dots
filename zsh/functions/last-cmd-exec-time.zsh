last_cmd_timestamp='' 

preexec() {
	last_cmd_timestamp=$(date +%s) 
}

last_cmd_exec_time() {
	if [ -n "$last_cmd_timestamp" ]; then
		now=$(date +%s)
		exec_time=$(expr $now - $last_cmd_timestamp)
		measurement="s"

		if [ "$exec_time" -ge "60" ]; then 
			exec_time=$(expr $exec_time / 60)
			measurement="m"
		fi 

		if [ $exec_time -ge 60 ] && [ $measurement == "m" ]; then 
			exec_time=$(expr $exec_time / 60)
			measurement="h"
		fi

		echo " %F{8}[$exec_time$measurement]%f"
	fi 
}

reset_last_cmd_timestamp() {
	last_cmd_timestamp=''
	zle .accept-line
}

zle -N accept-line reset_last_cmd_timestamp
