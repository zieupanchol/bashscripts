#!/bin/bash

# Display the UID and the username of the user executing this script.
# Display if the user is vagrant user or not.

# Display the UID.
echo "Your UID is ${UID}"

# Only display if the UID does not match 1000.
UID_TO_TEST_FOR="1000"
if [[ "${UID}" -ne $UID_TO_TEST_FOR ]]; then
	echo "Your UID does not match ${UID_TO_TEST_FOR}"
	exit 1
fi

# Display the username.
USER_NAME=$(id -un)

# Test if the command suceeded.
if [[ "${?}" -ne 0 ]]; then
	echo "The id command did not execute successfully"
	exit 1
fi

echo "Your username is ${USER_NAME}"

# You can use a string test conditional.
TEST_USER="vagrant"
if [[ "${USER_NAME}" == "${TEST_USER}" ]]; then
	echo "Your username matched ${TEST_USER}"

fi

# Test for != (not equal) for the string.
if [[ "${USER_NAME}" != "${TEST_USER}" ]]; then
	echo "Your username does not match ${TEST_USER}"
	exit 1
fi

exit 0
