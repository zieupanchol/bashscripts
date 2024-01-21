#!/bin/bash

# This script create an account on the local system.
# You will be prompted for account name and password

# Ask for user name.
read -p "Enter username for this account: " USER_NAME
# Ask for real name.
read -p "Enter real name for the person whose this account is for: " COMMENT
# Ask for the password.
read -p "Enter a password for this account: " PASSWORD
# Create the user.
sudo useradd -c "$COMMENT" -m $USER_NAME
# Generate a better password using date/time and cryptographic hash function.
PASSWORD=$(date +%S%N${RANDOM}${RANDOM} | sha256sum | head -c48)
# Set password for the user.
echo ${PASSWORD} | passwd --stdin ${USER_NAME}
# Force password change on first login
passwd -e ${USER_NAME}
