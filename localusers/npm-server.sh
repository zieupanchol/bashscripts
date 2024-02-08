#!/bin/bash

## save the artifact details in a json file.
curl -u user:password -X GET 'http://159.203.123.227:8081/service/rest/v1/components?repository=npm-hosted-repository&sort=version' | jq "." >artifact.json
# Check the exit status of the curl command.
if [ '${?}' -ne 0 ]; then
    echo 'Failed to extract artifact details. Exiting...'
    exit 1
fi
# grab the download url from the saved artifact details using 'jq' json processor tool
artifactDownloadUrl=$(jq '.items[].assets[].downloadUrl' artifact.json --raw-output)

# fetch the artifact with the extracted download url using 'wget' tool.
wget --http-user=username --http-password=userpassword "$artifactDownloadUrl"

# Extract the tar file.
tar -xvf *.tgz
# Check the exit status of the tar command.
if [ "${?}" -ne 0 ]; then
    echo 'Failed to extract the tar file. Exiting...'
    exit 1
fi
# Change into extracted package directory.
cd package/
# Install the application dependencies.
npm install
# Start the application in the background.
node server.js &
