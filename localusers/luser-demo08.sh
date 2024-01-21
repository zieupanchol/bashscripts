#!/bin/bash
# This script backup file.
log() {
	# This function sned messages to syslog and to standard ouput if verbose is set to true.
	local MESSAGE="${@}"
	if [[ "${VERBOSE}" == true ]]; then
		echo "${MESSAGE}"
	fi
	logger -t luser-demo08.sh "${MESSAGE}"
}

readonly VERBOSE=true

log 'Hello'
log 'This is fun!'

backup-file() {

	# This function create a backup of a file.
	local FILE="${1}"

	# Test to make sure the file exist and then backup the file.

	if [[ -f "${FILE}" ]]; then
		local BACKUP_FILE="/var/tmp/$(basename ${FILE}).$(date +%F-%N)"
		log "Backing up ${FILE} to ${BACKUP_FILE}"
		cp -p ${FILE} ${BACKUP_FILE}
	else
		#If the file does not exist then return a non-zero exit status.
		return 1
	fi

}

backup-file '/etc/passwd'

# Check to see if the backup of the file succeeded or failed based on exit status.
if [[ "${?}" -eq "0" ]]; then
	log "The backup of the file succeeded!"
else
	log "The backup of the file failed"
	exit 1
fi
