#!/bin/bash

# Check to make sure the user uses sudo to run this script.
if [ $UID -ne 0 ]; then
    echo "You need to use sudo or have root privileges to run this script."
    exit 1
fi

# Display script usage when the user uses the wrong option
Script_Usage() {
    echo "USAGE: ${0} [-c | -m] [-l LINES]" >&2
    echo "-c  Sort user processes based on CPU usage"
    echo "-m  Sort user processes based on memory usage"
    echo "-l  Specify the number of lines to be output (default is 10)"
    exit 1
}

# Initialize variables with default values.
LINES=10
CPU_USAGE=false
MEMORY_USAGE=false

# Parse options
while getopts "l:cm" OPTION; do
    case ${OPTION} in
    l)
        LINES=${OPTARG}
        ;;
    c)
        CPU_USAGE=true
        ;;
    m)
        MEMORY_USAGE=true
        ;;
    \?)
        Script_Usage
        ;;
    esac
done


# Check if at least one argument is provided.
if [ "${#}" -lt 1 ]; then
    Script_Usage
fi

# Get the current user
USER=$(id -un)

# Display user processes
ps aux | grep "$USER"

# Sort and display processes based on user input
if [ "$MEMORY_USAGE" = true ]; then
    ps aux --sort=-rss | grep "$USER" | grep -v grep | head -n "$LINES"
fi

if [ "$CPU_USAGE" = true ]; then
    ps aux --sort=-%cpu | grep "$USER" | grep -v grep | head -n "$LINES"
fi
