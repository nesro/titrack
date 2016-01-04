#!/usr/bin/env bash
# nesro <nesro@nesro.cz> 20160104
# https://github.com/nesro/titrack

# Use this variable
finish=0
trap 'finish=1' INT SIGINT TERM SIGTERM

check() {
	if ! hash xdotool 2>/dev/null; then
		echo "You need xdotool."
		exit 1
	fi
}

setup() {
	mkdir -p ~/.titrack
}

loop() {
	local track_file;	track_file=~/.titrack/$(date +"%Y_%m_%d").txt
	local spin="-/|\\"

	cat <<EOF
TiTrack - Window Title Tracker - is tracking in $track_file
Use Ctrl+C to quit please.
Remember, that every window title will be stored - no porn or weird things!
EOF

	while (( finish == 0 )); do
		local spin_temp=${spin#?}
		printf "[%c]" "$spin" 1>&2
		local spin=$spin_temp${spin%"$spin_temp"}

		date +"%Y %m %d %H %M %S " | tr -d '\n'
		xdotool getwindowfocus getwindowname
		sleep 1
		printf "\b\b\b" 1>&2
	done >> "$track_file"

	printf "\nTiTrack has finished!\n" 1>&2
}

main() {
	check
	setup
	loop
}

main

