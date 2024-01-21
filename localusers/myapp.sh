#!/bin/bash
 #This script automates the setup and deployment of a Node.js application, 
 #including installing dependencies, creating a dedicated user, 
 #fetching the project archive, setting up environment variables
 #and starting the Node.js application.

# Install nodejs and npm on the local system and net-tools.
echo "install node, npm, curl, wget, net-tools"
sudo apt update
sudo apt install -y nodejs npm curl net-tools
sleep 15
echo ""
echo "################"
echo ""

# Run nodjs application as myappuser.
APPUSER=myappuser

# Check to see if the above command succeeded.
if [ "${?}" -eq 0 ]; then
    echo "nodejs was succfully installed"
else
    echo "nodejs failed to install"
    exit 1
fi
# read user input for log directory
echo -n "Set log directory location for the application (absolute path): "
read LOG_DIRECTORY
if [ -d $LOG_DIRECTORY ]; then
    echo "$LOG_DIRECTORY already exists"
else
    mkdir -p $LOG_DIRECTORY
    echo "A new directory $LOG_DIRECTORY has been created"
fi

# display nodeJS version
node_version=$(node --version)
echo "NodeJS version $node_version installed"

# display npm version
npm_version=$(npm --version)
echo "NPM version $npm_version installed"

echo ""
echo "################"
echo ""

# create new user to run the application and make owner of log dir
useradd $APPUSER -m
chown $APPUSER -R $LOG_DIRECTORY

# fetch NodeJS project archive from s3 bucket
runuser -l $APPUSER -c "wget https://node-envvars-artifact.s3.eu-west-2.amazonaws.com/bootcamp-node-envvars-project-1.0.0.tgz"

# extract the project archive to ./package folder
runuser -l $APPUSER -c "tar zxvf ./bootcamp-node-envvars-project-1.0.0.tgz"

# start the nodejs application in the background, with all needed env vars with new user myapp
runuser -l $APPUSER -c "
    export APP_ENV=dev &&
    export DB_PWD=mysecret &&
    export DB_USER=myuser &&
    export LOG_DIR=$LOG_DIRECTORY &&
    cd package &&
    npm install &&
    node server.js &"

# display that nodejs process is running
ps aux | grep node | grep -v grep

# display that nodejs is running on port 3000
netstat -ltnp | grep '3000'
