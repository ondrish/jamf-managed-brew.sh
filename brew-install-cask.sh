#!/bin/bash

function askForAppName ()
{
## Capture the user input into a variable
APPNAME=$(/usr/bin/osascript << EOF 
tell application "System Events"
    activate
    display dialog "write name of package. (example: btop, nano)" default answer ""
    set appName to text returned of result
end tell
EOF)

## Check the variable to make sure it's not empty...
if [ "$APPNAME" == "" ]; then
    echo "Package name was not entered. Re prompting the user..."
    askForAppName
else
    echo "Package name entered was: $APPNAME"
fi
}

#######################
# check something set #
if [[ "$APPNAME" == "" ]]; then
echo "****  No Package name set! exiting ****"
exit 1
fi

UNAME_MACHINE="$(uname -m)"

ConsoleUser=$( scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }' )

# Check if the APPNAME is already installed. If not, install it

if [[ "$UNAME_MACHINE" == "arm64" ]]; then
    # M1/arm64 machines
    cd /tmp/ # This is required to use sudo as another user or you get a getcwd error
        if [[ $(sudo -H -iu ${ConsoleUser} /opt/homebrew/bin/brew list --casks | grep -c ${APPNAME}) == "1"  ]]; then
        echo "${APPNAME} is installed already. Skipping installation"
        else
        echo "${APPNAME} is either not installed or not available. Attempting installation..."
        sudo -H -iu ${ConsoleUser} /opt/homebrew/bin/brew install --cask ${APPNAME}
        fi
else
    # Intel machines
    cd /tmp/ # This is required to use sudo as another user or you get a getcwd error
        if [[ $(sudo -H -iu ${ConsoleUser} /usr/local/bin/brew list --casks | grep -c ${APPNAME}) == "1" ]]; then
        echo "${APPNAME} is installed already. Skipping installation"
        else
        echo "${APPNAME} is either not installed or not available. Attempting installation..."
        sudo -H -iu ${ConsoleUser} /usr/local/bin/brew install --cask ${APPNAME}
        fi
fi