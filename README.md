# homebrew.sh - ondrish's fork
Install homebrew via Jamf without giving users admin rights

This script installs homebrew for the logged in user without requiring them to be an Administrator.

It is designed to be used in an MDM such as Jamf Pro.

Thanks to Richard Purves for the first version.

Thanks to all my users for feedback and improvements.


# brewEA.sh
This EA compliments the script to produce a Jamf extension attribute to record brew version.
It uses the same method to detect device type and looks where the script installs.
 *If brew is installed in different locations this will not detect it!*

# brew-install-program.sh
This script can be used to install any brew program that installs using *brew install <name>* command.
It is designed to work with the brew install script here and be used in jamf.
˜˜Specify the install name as the first jamf variable.˜˜
Displays a dialog for user to input package name.

# brew-install-cask.sh
Like the *brew-install-program* script this variation is used to install casks where the *brew install --cask <name>* is used.
It is designed to work with the brew install script here and be used in jamf.
˜˜Specify the cask name as the first jamf variable.˜˜
Displays a dialog for user to input cask name.
