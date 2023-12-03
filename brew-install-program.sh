#!/bin/bash

function askForCaskName ()
{
## Capture the user input into a variable
CASKNAME=$(/usr/bin/osascript << EOF 
tell application "System Events"
    activate
    display dialog "write name of Cask. " default answer ""
    set appName to text returned of result
end tell
EOF)

## Check the variable to make sure it's not empty...
if [ "$CASKNAME" == "" ]; then
    echo "Cask name was not entered. Re prompting the user..."
    askForCaskName
else
    echo "Cask name entered was: $Caskname"
fi
}

#######################
# check something set #
if [[ "$CASKNAME" == "" ]]; then
echo "****  No CASKNAME set! exiting ****"
exit 1
fi

UNAME_MACHINE="$(uname -m)"

ConsoleUser=$( scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }' )

# Check if the CASKNAME is already installed. If not, install it

if [[ "$UNAME_MACHINE" == "arm64" ]]; then
    # M1/arm64 machines
    brew=/opt/homebrew/bin/brew
else
    # Intel machines
    brew=/usr/local/bin/brew
fi

cd /tmp/ # This is required to use sudo as another user or you get a getcwd error
if [[ $(sudo -H -iu ${ConsoleUser} ${brew} info ${CASKNAME}) != *Not\ installed* ]]; then
	echo "${CASKNAME} is installed already. Skipping installation"
else
	echo "${CASKNAME} is either not installed or not available. Attempting installation..."
	sudo -H -iu ${ConsoleUser} ${brew} install ${CASKNAME}
fi
