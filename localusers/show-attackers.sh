#!/bin/bash

# This script display the number of failed login attempt by IP address and location.

# Provide log file to be analyze as an argument to this script.
Log_file=${1}
LIMIT=10

if [[ ! -e "${Log_file}" ]]; then
    echo "The log file ${Log_file} does not exist."
    exit 1
fi

# Display a csv header.
echo "Count,IP,Location"
# Loop through the list of failed attempts and IP addresses.
grep 'Failed' ${Log_file} | awk '{print $(NF -3)}' | sort | uniq -c | sort -nr | while read COUNT IP; do
    if [[ ${COUNT} -gt ${LIMIT} ]]; then
        LOCATION=$(geoiplookup ${IP} | awk -F ', ' '{print $2}')
        echo "${COUNT},${IP},${LOCATION}"
    fi
done
