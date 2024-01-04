#!/bin/bash

# This script execute a given command on multiple servers.
# Default file.
Default_File="/vagrant/servers"

# Display the usage and exit
usage() {
    echo "USAGE: ${0} [-vsn] [-f FILE] COMMAND" >&2
    echo "-s     Execute the COMMAND using sudo on the remote server." >&2
    echo "-v    Verbose mode. Displays the server name before executing" >&2
    echo "-n    Dry run mode"
    echo "-f FILE Use FILE for the list of servers. Default: /vagrant/servers." >&2
    exit 1
}

# Make sure the script is not being executed with superuser privileges.
if [[ ${UID} -eq 0 ]]; then
    echo "Do not execute this script as root" >&2
    usage
    exit 1
fi

# Parse the options.

while getopts f:vns OPTION; do
    case ${OPTION} in
    s)
        SUDO="sudo"
        ;;
    v)
        VERBOSE="true"
        ;;
    f)
        Default_File="${OPTARG}"
        ;;
    n)
        DRY_RUN="true"
        ;;
    ?)
        usage
        ;;
    esac
done

# Remove options while leaving the remaining arguments.
shift $((OPTIND - 1))

if [[ ${#} -lt 1 ]]; then
    usage
fi
# Anything that remain on the command line is to be treated as a single command.
COMMAND=${@}
# Check to make sure /vagrant/servers file exist.
if [[ ! -e ${Default_File} ]]; then
    echo "${Default_File} does not exist" >&2
    exit 1
else

    for SERVER in $(cat ${Default_File}); do

        if [[ ${VERBOSE} = 'true' ]]; then

            echo "${SERVER}"

        fi

        if [[ ${DRY_RUN} = 'true' ]]; then
            echo "ssh ${SERVER} DRY_RUN: ${SUDO} ${COMMAND}"
        else
            ssh ${SERVER} ${SUDO} ${COMMAND}
        fi

    done
fi
