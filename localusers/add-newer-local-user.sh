#!/bin/bash

# This script create an account on the local system.
# You need to pass in username, and real name as arguments on the command line.

# This script is executed sudo command or if you have root user priviliges.

if [[ "${UID}" -ne 0 ]]; then
	echo "You need to execute this script with sudo command" >&2
	exit 1
fi
# This script expect 3 arguments on the command line.
if [[ "${#}" -lt 1 ]]; then
	echo "USAGE: ${0} USER_NAME [USER_NAME]..." >&2
	exit 1
fi

# The first parameter is username.
USER_NAME=$1

# The rest of the parameters are for comment.
shift
COMMENT=$@

# Generate a better password using date/time and cryptographic hash function.

PASSWORD=$(date +%S%N${RANDOM}${RANDOM} | sha256sum | head -c48)

# Generate even a special character.

SPECIAL_CHARACTER=$(echo '!@#$%^&*()_-+=' | fold -w1 | shuf | head -c1)

# Append special to end of password for stronger password
NEW_PASSWORD="${PASSWORD}${SPECIAL_CHARACTER}"
# Create the user.
sudo useradd -c "$COMMENT" -m $USER_NAME &>/dev/null

# Check if the useradd command succeeded.
if [[ "${?}" -ne 0 ]]; then
	echo "useradd command has failed to execute" >&2
	exit 1
fi

# Set password for the user.
echo "${NEW_PASSWORD}" | passwd --stdin ${USER_NAME} &>/dev/null

# Check if the passwd command succeeded.
if [[ "${?}" -ne 0 ]]; then
	echo "passwd command did not execute" >&2
	exit 1
fi
# Force password change on first login
passwd -e ${USER_NAME} &>/dev/null

# Display username, password and the host name where this user was created.
echo "username:"
echo "${USER_NAME}"
echo
echo "password:"
echo "${NEW_PASSWORD}"
echo
echo "host:"
echo "${HOSTNAME}"
echo

exit 0
