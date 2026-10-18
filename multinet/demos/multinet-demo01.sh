#!/bin/bash

# This script pings a list of servers and reports their status.

SERVER_FILE="/vagrant/demos/servers"

# Check if the server file exists
if [[ ! -e "${SERVER_FILE}" ]]
then
    echo "Cannot open ${SERVER_FILE}." >&2
    exit 1
fi

# Loop through each server in the file and ping it
for SERVER in $(cat ${SERVER_FILE})
do
    echo "Pinging ${SERVER}..."
    ping -c 1 ${SERVER} &> /dev/null
    if [[ "${?}" -eq 0 ]]
    then
        echo "${SERVER} is up."
    else
        echo "${SERVER} is down."
    fi
done 

# In the real world, if you can't ping a server, that doesn't necessarily mean that the server is down. It could mean that it's using a firewall that's preventing you from pinging it. It could mean a lot of different things. But for the purposes of this script, if you can't ping a server, we'll assume that it's down.