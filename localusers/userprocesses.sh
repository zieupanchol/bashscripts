#!/bin/bash
# Display script usage when user use wrong option
Script_Usage() {
    echo "USAGE: ${0} [-c | -m] [-l LINES]" >&2
    echo "-c  Sort user processes based on cpu usage"
    echo "-m  Sort user processes based on memory usage"
    echo "-l  Specify the number of lines to be ouput (default is 10)"
    exit 1
}
# Initialize variables with default values.
LINES=10
# Parse options
while getopts "l:cm" OPTION; do
    case ${OPTION} in

    l)
        LINES=$OPTARG
        ;;
    c)
        CPU_USAGE='true'
        ;;
    m)
        MEMORY_USAGE='true'
        ;;
    \?)
        Script_Usage
        ;;
    esac
done
# Check if atleast one argument is provided.
if [ "${#}" -lt 1 ]; then
    Script_Usage
fi
# loop through the options
if [ "$MEMORY_USAGE" = 'true']; then
    ps aux --sort --rss | grep 'whoami' | head -n $LINES  | (echo "USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND" && cat)
fi

if [ "$CPU_USAGE" = 'true']; then
    ps aux --sort --%cpu | grep 'whoami' | head -n $LINES | (echo "USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND" && cat)

fi
