#!/bin/bash

ProgramName=$(osascript -e 'text returned of (display dialog "Please provide Program Name" with title "Homebrew - Install Program" default answer "Program Name" buttons {"OK"} default button 1)')

#######################
# check something set #
if [[ "$ProgramName" == "" ]]; then
echo "****  No ProgramName set! exiting ****"
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
if [[ $(sudo -H -iu ${ConsoleUser} ${brew} info ${ProgramName}) != *Not\ installed* ]]; then
	echo "${ProgramName} is installed already. Skipping installation"
else
	echo "${ProgramName} is either not installed or not available. Attempting installation..."
	sudo -H -iu ${ConsoleUser} ${brew} install ${ProgramName}
fi
