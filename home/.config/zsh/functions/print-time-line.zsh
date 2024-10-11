print_time_line() {
  # Get the terminal width
  local term_width=$(tput cols)

  # Get the current time
  local current_time=$(date '+%H:%M:%S')

  # Create the prefix with '-- HH:MM:SS -- '
  local prefix="-- [$current_time] -- "

  # Calculate the number of dashes needed to fill the rest of the line
  local remaining_width=$((term_width - ${#prefix}))

  # Generate the remaining dashes
  local dashes=$(printf '%*s' "$remaining_width" | tr ' ' '-')

  # Define color codes
  local darkgray=$'\033[38;5;8m'  # Dark gray (ANSI color 8)
  local white=$'\033[97m'         # White
  local reset=$'\033[0m'          # Reset color

  # Print the line with dark gray dashes and white time
  printf "${darkgray}-- [${white}${current_time}${darkgray}] ---${dashes}${reset}\n"
}
