#!/bin/bash

ARCHIVE_DIR="/archive"
# Display the usage and exit.
SCRIPT_USAGE() {
    echo "USAGE: ${0} [-dra]  >&2"
    echo "-a  Archive the user home directory"
    echo "-d  Delete user account"
    echo "-r  Recursively remove user account with home directory"
    exit 1
}
# Make sure the script is being executed with superuser privileges.
if [[ "${UID}" -ne 0 ]]; then
    echo "Use sudo or root privileges to run this script."
    exit 1
fi
# Parse the options.
while getopts dra OPTION; do
    case ${OPTION} in

    d)
        DELETE_USER_ACCOUNT='true'
        ;;
    r)
        DELETE_HOME_DIRECTORY='-r'
        ;;
    a)
        ARCHIVE_HOME_DIRECTORY='true'
        ;;
    \?)
        SCRIPT_USAGE
        exit 1
        ;;
    esac
done

# Remove the options while leaving the remaining arguments.
shift $((OPTIND - 1))
# If the user doesn't supply at least one argument, give them help.
if [[ "${#}" -lt 1 ]]; then
    SCRIPT_USAGE
    exit 1
fi
# Loop through all the usernames supplied as arguments.

for USER_NAME in ${@}; do
    echo "Processing user: ${USER_NAME}"
    # Make sure the UID is at least 1000.
    USER_UID=$(id -u ${USER_NAME})
    if [[ ${USER_UID} -lt 1000 ]]; then
        echo "Refusing to delete ${USER_NAME} with UID ${USER_UID}" >&2
        exit 1
    fi
    # Create an archive if requested to do so with -a option.
    # Make sure the ARCHIVE_DIR directory exists.
    if [[ "${ARCHIVE_HOME_DIRECTORY}" = 'true' ]]; then
        if [[ ! -d ${ARCHIVE_DIR} ]]; then
            echo "Creating ${ARCHIVE_DIR} directory."
            mkdir -p ${ARCHIVE_DIR}
            if [[ "${?}" -ne 0 ]]; then
                echo "The archive directory ${ARCHIVE_DIR} could not be created." >&2
                exit 1
            fi
        fi

        HOME_DIR="/home/${USER_NAME}"
        ARCHIVE_FILE="${ARCHIVE_DIR}/${USER_NAME}.tgz"
        if [[ -d "${HOME_DIR}" ]]; then
            echo "Archiving ${HOME_DIR} to ${ARCHIVE_FILE}"
            tar -zcf ${ARCHIVE_FILE} ${HOME_DIR} &>/dev/null
            if [[ "${?}" -ne 0 ]]; then
                echo "Could not create ${ARCHIVE_FILE}." >&2
                exit 1
            fi
        else
            echo "${HOME_DIR} does not exist or is not a directory." >&2
            exit 1
        fi
    fi # END of if "${ARCHIVE_HOME_DIRECTORY}" = 'true'

    # Delete the user with -dr options.
    if [[ "${DELETE_USER_ACCOUNT}" = 'true' ]]; then
        sudo userdel ${DELETE_HOME_DIRECTORY} $USER_NAME
        # Check to see if the userdel command succeeded.
        if [[ "${?}" -ne 0 ]]; then
            echo "${USER_NAME} home directory was not successfully deleted"
            exit 1
        else
            echo "${USER_NAME} home directory was successfully deleted"
        fi
    # Disable user account.
    else
        sudo chage -E 0 $USER_NAME
        # Check to see if the chage command succeeded.
        if [[ "${?}" -ne 0 ]]; then
            echo "${USER_NAME} was not successfully disabled"
            exit 1
        else
            echo "${USER_NAME} account was successfully disabled"
        fi

    fi

done
exit 1
