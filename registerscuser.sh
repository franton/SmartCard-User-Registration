#!/bin/bash

# Script to grab smartcard hash and program it to the current user
# Horrible hack of sc_auth script provided on OS X

loggedInUser=$( python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");' )

hash=$( /usr/bin/security dump-keychain |
awk -v RE="$loggedInUser" '
/^    0x00000001/	{
	if (matched = ($2 ~ RE)) { name=$0; sub("^.*<blob>=\"", "", name); sub("\"$", "", name); count++; }}
/^    0x00000006/	{
	if (matched) { hash=$2; sub("<blob>=0x", "", hash); print hash; }}
'

/usr/bin/security dump-keychain |
awk -v RE="$loggedInUser" '
/^    0x01000000/	{
	if (matched = ($2 ~ RE)) { name=$0; sub("^.*<blob>=\"", "", name); sub("\"$", "", name); count++; }}
/^    0x06000000/	{
	if (matched) { hash=$2; sub("<blob>=0x", "", hash); print hash; }}
')

if [ "$hash" = "" ];
then
	echo "Hash not found."
	exit 1
else
	echo "Hash $hash found. Assigning to user $loggedInUser"
	dscl . -append "/Users/$loggedInUser" AuthenticationAuthority ";pubkeyhash;$hash"
fi

exit 0
