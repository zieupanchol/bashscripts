#!/bin/bash

# Check user processes in the system.
USER=$(id -un)
ps -aux | grep ${USER}

echo " "
# Ask user for input.
read -p "Would you like to sort the processes output by memory or CPU? (m/c) " sortby
read -p "How many results do you want to display? " lines
# Logic to handle user input when they choose "m" for Memory.
if [ "$sortby" = "m" ]; then
    ps aux --sort=-%cpu | grep ${USER} | grep -v grep | (echo "USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND" && cat)
# Logic to handle user input when they choose "c" for CPU.
elif [ "$sortby" = "c" ]; then
    ps aux --sort=-%cpu | grep ${USER} | grep -v grep | (echo "USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND" && cat)
else
    echo "No input was provided. Please provide an input"
    exit 1
fi
