#!/bin/bash

# Script to grab CTK smartcard hash and program it to the current user
# Needs root. Assumes first hash is the smart card. Bad bad bad, needs error checking.

loggedInUser=$( python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");' )

hash=$( sc_auth list | awk 'NR==1{ print $2 }' )

echo "Hash $hash found. Assigning to user $loggedInUser"
sc_auth pair -u $loggedInUser -h $hash