#!/bin/bash

# This script will generate a list of random passwords.

# Generate a password with RANDOM.

PASSWORD="${RANDOM}"
echo "${PASSWORD}"

# Combine three RANDOMS numbers to generate a password.

PASSWORD="${RANDON}${RANDOM}${RANDOM}"
echo "${PASSWORD}"

# Generate a password using date/time.

PASSWORD=$(date +%s)
echo "${PASSWORD}"

# Generate a password using nanoseconds.

PASSWORD=$(date +%s%N)
echo "${PASSWORD}"

# Generate a better password using date/time and cryptographic hash function.

PASSWORD=$(date +%s%N | sha256sum | head -c32)
echo ${PASSWORD}

# Generate even a better password.

PASSWORD=$(date +%S%N${RANDOM}${RANDOM} | sha256sum | head -c48)
echo ${PASSWORD}

# Generate even a strongest password.

SPECIAL_CHARACTER=$(echo '!@#$%^&*()_-+=' | fold -w1 | shuf | head -c1)
echo "${PASSWORD}${SPECIAL_CHARACTER}"

