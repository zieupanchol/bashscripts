#!/bin/bash

# This script generate a random password for each user type on the command line.

# Display what the user type on the command line.
echo "Hello from my head: ${0}"


# Display the path to the file and the file name.
echo "You used $(dirname ${0}) as the path to $(basename ${0})"

# Display the number of arguments passed in.

echo "Number of params in this script: ${#}"

# Check to make sure the user supplied at least one argument.

if [[ "${#}" -lt 1 ]]
then
	echo "USAGE: ${0} USER_NAME [USER_NAME]..."
	exit 1
fi

# Generate password for user passed in as an argument on the command line.

for USER_NAME in ${@};
do	
	SPECIAL_CHARACTER="$(echo '!@#$%^&*()_-+=' | fold -w1 | shuf | head -c1)"
	PASSWORD="$(date +%s%N | sha256sum | head -c48)"
	echo "${USER_NAME}: ${PASSWORD}${SPECIAL_CHARACTER}"
done









