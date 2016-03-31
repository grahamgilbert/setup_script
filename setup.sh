#!/bin/bash

# A large proportion of this stuff relies on Dropbox being installed and synced.
# This will just do the initial bits, run <scriptname> once dropbox has finished syncing
# This is being run as root, so we'll clean up everything and setup AutoPkg again as the user

# Check we're running as root, exit if not
WHOAMI=$(whoami)
if [[ $WHOAMI != "root" ]]; then
    echo "This script must be run as root"
    exit 1
fi

# Install the xcode tools (stolen from https://github.com/timsutton/osx-vm-templates/blob/master/scripts/xcode-cli-tools.sh)
touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
# find the CLI Tools update
PROD=$(softwareupdate -l | grep "\*.*Command Line" | head -n 1 | awk -F"*" '{print $2}' | sed -e 's/^ *//' | tr -d '\n')
# install it
softwareupdate -i "$PROD" -v
rm /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress

# Git clone autopkg
AUTOPKG_DIR=$(mktemp -d /tmp/autopkg-XXXX)
git clone https://github.com/autopkg/autopkg "$AUTOPKG_DIR"
AUTOPKG="$AUTOPKG_DIR/Code/autopkg"

# Use the git clone to install the current release of autopkg
"${AUTOPKG}" repo-add rtrouton-recipes
"${AUTOPKG}" run AutoPkg-Release.install

AUTOPKG="/usr/local/bin"
"${AUTOPKG}" repo-add grahamgilbert-recipes
"${AUTOPKG}" run Dropbox.install

# Cleanup
rm -rf "{$AUTOPKG_DIR}" "~/Library/AutoPkg"

git clone https://github.com/grahamgilbert/setup_script.git /tmp/setup_script

open /tmp/setup_script

echo "Now open Dropbox and begin syncing and run install.sh as your regular user"
