#!/bin/bash

# Display the UID and the username of the user executing this script

# Display if the user is root user or not

# Display UID
echo "Your UID is ${UID}"
# Display username
echo "You are $(whoami)"
# Display if the user is root user or not

if [[ "${UID}" -eq 0 ]]; then
	echo "You are root"
else
	echo "You are not root"
fi
