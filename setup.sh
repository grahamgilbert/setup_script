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

# if [[ $# -eq 0 ]]; then
#     echo "App Store Username and password must be passed"
#     exit 1
# fi

loggedInUser=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`

# Install the xcode tools (stolen from https://github.com/timsutton/osx-vm-templates/blob/master/scripts/xcode-cli-tools.sh)
touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
# find the CLI Tools update
PROD=$(softwareupdate -l | grep "\*.*Command Line" | head -n 1 | awk -F"*" '{print $2}' | sed -e 's/^ *//' | tr -d '\n')
# install it
softwareupdate -i "$PROD" -v
rm /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress

# Git clone autopkg
AUTOPKG_DIR=$(mktemp -d /tmp/autopkg-XXXX)
# git clone https://github.com/autopkg/autopkg "$AUTOPKG_DIR"
# AUTOPKG="$AUTOPKG_DIR/Code/autopkg"
#
# # Use the git clone to install the current release of autopkg
# "${AUTOPKG}" repo-add rtrouton-recipes
#
# get_autopkg() {
#     local recipe_name="Autopkg-Release.download"
#     local report_path=$(mktemp /tmp/autopkg-report-XXXX)
#
#     # Run AutoPkg setting VERSION, and saving the results as a plist
#     "${AUTOPKG}" run --report-plist "${report_path}" "${recipe_name}" > \
#         "$(mktemp "/tmp/autopkg-runlog-${recipe_name}")"
#     /usr/libexec/PlistBuddy -c \
#         'Print :summary_results:url_downloader_summary_result:data_rows:0:download_path' \
#         "${report_path}"
#     rm -f report_path
# }

AUTOPKG_PKG=${AUTOPKG_DIR}/AutoPkg.pkg
curl -o ${AUTOPKG_PKG} -L https://github.com/autopkg/autopkg/releases/download/v1.0.3/autopkg-1.0.3.pkg
installer -pkg "${AUTOPKG_PKG}" -tgt /

# AUTOPKG="/usr/local/bin/autopkg"
# "${AUTOPKG}" repo-add recipes
# "${AUTOPKG}" repo-add grahamgilbert-recipes
# "${AUTOPKG}" run Dropbox.install

# Cleanup
rm -rf "${AUTOPKG_DIR}" "~/Library/AutoPkg" "/Users/${loggedInUser}/Library/AutoPkg"

git clone https://github.com/grahamgilbert/setup_script.git /tmp/setup_script

# echo "---------------------------------------------------------"
# echo "Now open Dropbox and begin syncing"

su ${loggedInUser} -C /tmp/setup_script/install.sh $1 $2

/tmp/setup_script/puppet.sh
rm -rf /tmp/setup_script
