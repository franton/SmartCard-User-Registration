# SmartCard-User-Registration
Script to assign a specific smart card to a local user account.

If you have a local user account on your Mac and you need to make it work with a specific smart card, run this script.

It's designed to be used as a Casper Self Service policy. It will find the current console user, pull the smart card token hash that matches that username and then make sure the account has the smart card hash attached to it's dscl record.

Please regard this as a proof of concept only. It's not quite ready for production at time of publishing.
