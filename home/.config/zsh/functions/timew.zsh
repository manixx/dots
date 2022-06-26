timew_status() {
	if command -v timew &> /dev/null; then
		if [[ $(timew get dom.active) == "1" ]]; then
			local duration=$(timew | tail -1 | tr -s ' ' | cut -d ' ' -f3)
			local tags=$(timew get dom.active.json   | jq -r '.tags // [] | join(", ")')

			echo " %F{8}| track%f %F{4}${duration} ($tags)%f"
		fi
	fi
}
