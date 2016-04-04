#!/bin/bash

# This script uses autopkg to install most of the software needed (apart from homebrew stuff)

appstoreusername=$1
appstorepassword=$2
# Install homebrew
echo "Please enter your password to install Homebrew"
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" > /dev/null

AUTOPKG=/usr/local/bin/autopkg
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Add the needed recipes
repo_list=${DIR}/install_repos.txt
while IFS= read -r line
do
    ${AUTOPKG} repo-add $line
done < $repo_list

# Install the apps that have no changes from default

${AUTOPKG} run -l ${DIR}/install_recipes.txt

# Those awkward ones that need 'special help'

${AUTOPKG} run -k OS_VERSION="10.11" Puppet-Agent.install


# Install the mas binary from homebrew
/usr/local/bin/brew tap argon/mas

/usr/local/bin/brew install mas

get_mas() {
    local app_id=$1
    local app_path=$2
    echo "Installing ${app_path}"
    sleep 5
    [ ! -d "${app_path}"  ] && /usr/local/bin/mas install $app_id
    [ -d "${app_path}"  ] && echo "${app_path} is already installed."
}


# /usr/local/bin/mas signin $appstoreusername "${appstorepassword}"

# get_mas 927292435 "/Applications/iStat Mini.app"

# get_mas 961850017 "/Applications/GIFs.app"

# get_mas 409183694 "/Applications/Keynote.app"
#
# get_mas 409907375 "/Applications/Remote Desktop.app"
#
# get_mas 403304796 "/Applications/iNet Network Scanner.app"
#
# get_mas 413857545 "/Applications/Divvy.app"
#
# get_mas 494803304 "/Applications/WiFi Explorer.app"
#
# get_mas 407963104 "/Applications/Pixelmator.app"
#
# get_mas 425955336 "/Applications/Skitch.app"
#
# get_mas 557168941 "/Applications/Tweetbot.app"
#
# get_mas 880001334 "/Applications/Reeder.app"
#
# get_mas 497799835 "/Applications/Xcode.app"
#
# get_mas 847496013 "/Applications/Deckset.app"
#
# get_mas 409201541 "/Applications/Pages.app"
#
# get_mas 715768417 "/Applications/Microsoft Remote Desktop.app"
#
# get_mas 504544917 "/Applications/Clear.app"
#
# get_mas 420212497 "/Applications/Byword.app"
#
# get_mas 568494494 "/Applications/Pocket.app"
#
# get_mas 458034879 "/Applications/Dash.app"

echo "Now running puppet.sh as root"
