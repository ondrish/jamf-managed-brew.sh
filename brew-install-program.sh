#!/bin/bash

function askForAPPNAME ()
{
## Capture the user input into a variable
APPNAME=$(/usr/bin/osascript << EOF 
tell application "System Events"
    activate
    display dialog "write name of Program. " default answer ""
    set appName to text returned of result
end tell
EOF)

## Check the variable to make sure it's not empty...
if [ "$APPNAME" == "" ]; then
    echo "Program name was not entered. Re prompting the user..."
    askForAPPNAME
else
    echo "Program name entered was: $APPNAME"
fi
}

#######################
# check something set #
if [[ "$APPNAME" == "" ]]; then
echo "****  No APPNAME set! exiting ****"
exit 1
fi

UNAME_MACHINE="$(uname -m)"

ConsoleUser=$( scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }' )

# Check if the APPNAME is already installed. If not, install it

if [[ "$UNAME_MACHINE" == "arm64" ]]; then
    # M1/arm64 machines
    brew=/opt/homebrew/bin/brew
else
    # Intel machines
    brew=/usr/local/bin/brew
fi

cd /tmp/ # This is required to use sudo as another user or you get a getcwd error
if [[ $(sudo -H -iu ${ConsoleUser} ${brew} info ${APPNAME}) != *Not\ installed* ]]; then
	echo "${APPNAME} is installed already. Skipping installation"
else
	echo "${APPNAME} is either not installed or not available. Attempting installation..."
	sudo -H -iu ${ConsoleUser} ${brew} install ${APPNAME}
fi
