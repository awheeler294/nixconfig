#!/bin/bash

# This script will randomly go through the files of a directory, setting it
# up as the wallpaper at regular intervals
#
# NOTE: this script is in bash (not posix shell), because the RANDOM variable
# we use is not defined in posix

if [[ $# -lt 2 ]] || [[ ! -d $1   ]]; then
	echo "Usage:
	$0 <dir containing images> <output>"
	exit 1
fi

#start swwww
swww query || swww init

# Edit below to control the images transition
export SWWW_TRANSITION_FPS=60
export SWWW_TRANSITION_STEP=2

# This controls (in seconds) when to switch to the next image
BASE_INTERVAL=50
RANDOM_INTERVAL=10

while true; do
   find "$1" -type f | shuf --random-source=/dev/urandom \
      | while read -r img 
      do
         swww img -o "$2" "$img" --transition-type random
         sleep "$(( BASE_INTERVAL + (RANDOM % RANDOM_INTERVAL) ))"
      done
done
