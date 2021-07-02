#!/bin/zsh
# 
# Prints a sepearator line.
#

hr() {
	echo -n "%F{8}"
	printf '─%.s' {1..$(tput cols)}
	echo -n "%f"
}
