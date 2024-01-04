#!/bin/bash
# This script create new user account on local system.

# This script need to be executed by root user or it wouldn't work.
if [[ "${UID}" -ne 0 ]]; then
	echo "You are not a root user. Please use sudo to execute this script"
	exit 1
fi
# Get the username(login).
read -p "Enter the username for the user: " USER_NAME
# Get the realname(content for the description field).
read -p "Enter the real name for the user whose account is for: " COMMENT
# Get the password.
read -p "Enter password for the user: " PASSWORD
# Create the user with the password.
useradd -c "${COMMENT}" -m ${USER_NAME}
# Check to see if the useradd command succeeded.
if [[ "${?}" -ne 0 ]]; then
	echo "useradd command failed to execute"
	exit 1
fi
# Set the password.
echo ${PASSWORD} | passwd --stdin ${USER_NAME}
# Check to see if the passwd command succeeded.
if [[ "${?}" -ne 0 ]]; then
	echo "The passwd command failed to execute"
	exit 1
fi
# Set the passowrd to expire on first login.
passwd -e ${USER_NAME}

# Display the username, password and the hostname where the user was created.
echo
echo "Your username is ${USER_NAME}"
echo
echo "Your password is ${PASSWORD}"
echo
echo "Your account was created on $(hostname)"

exit 0
