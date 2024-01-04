#!/bin/bash

# This script generate a random password.
# User can choose password length with -l option and add special character to the password with -s option
# Verbose mode can be enabled with -v option.

# Usage function
usage() {
  echo "USAGE: ${0} [-vs] [-l LENGTH] COMMAND >&2"
  echo "-v          Increase verbosity."
  echo "-l LENGTH   Set password length."
  echo "-s          Append special character to the end of password."
  exit 1
}

# Verbose mode function.
verbose_on() {
  local MESSAGE=${@}
  if [[ ${VERBOSE} = "true" ]]; then
    echo "${MESSAGE}"
  fi

}

#Set passsword length variable.
PASSWORD_LENGTH=48

# Parse the command line options with getopts command using while loop.
while getopts vl:s OPTION; do
  case ${OPTION} in

  v)
    VERBOSE="true"
    ;;
  l)
    PASSWORD_LENGTH=${OPTARG}
    ;;
  s)
    USE_SPECIAL_CHARACTER="true"
    ;;
  ?)
    usage
    exit 1
    ;;
  esac
done

# Shift by the number of options passed to the script.
shift "$((OPTIND - 1))"

# Check to make sure the user passed to the script only the expected options.
if [[ "${#}" -gt 0 ]]; then
  usage
fi

verbose_on "Generating password"

# Generate a random password.

PASSWORD=$(date +%s%N${RANDOM}${RANDOM} | sha256sum | head -c${PASSWORD_LENGTH})

# Append a special character if requested.
if [[ "${USE_SPECIAL_CHARACTER}" = "true" ]]; then
  verbose_on "Appending special character to the end of password."
  SPECIAL_CHARACTER=$(echo "!@#$%^&*()_-+=" | fold -w 1 | shuf | head -c 1)
  UPDATED_PASSWORD=${PASSWORD}${SPECIAL_CHARACTER}
else
UPDATED_PASSWORD=${PASSWORD}
fi

verbose_on "done."
verbose_on "Here is the password."

# Generated password.
echo ${UPDATED_PASSWORD}

exit 0
