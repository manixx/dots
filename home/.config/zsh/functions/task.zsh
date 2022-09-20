task_status() {
	if command -v task &> /dev/null; then
		local open_tasks=$(task count status:pending)
		if [[ ${open_tasks} != "0" ]]; then
			echo " %F{8}| task%f %F{3}${open_tasks}%f"
		fi
	fi
}
