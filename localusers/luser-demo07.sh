#!/bin/bash

# Accept and display positional parameters

echo "Parameter 1: $1"
echo "Parameter 2: $2"
echo "Parameter 3: $3"

# Loop through the number of positional parameters.

while [[ ${#} -gt 0 ]]; do
	echo "The number is of parameters is: ${#}"
	echo "Parameter 1: $1"
	echo "Parameter 2: $2"
	echo "Parameter 3: $3"
	echo
	shift
done
