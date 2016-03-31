#!/bin/bash

# This script uses autopkg to install most of the software needed (apart from homebrew stuff)

# Ask for MAS creds
# read -p "App Store Username:" appstoreusername
# read -s -p "App Store Password:" appstorepassword

AUTOPKG=/usr/local/bin/autopkg

# Add the needed recipes
repo_list=install_repos.txt
while IFS= read -r line
do
    ${AUTOPKG} repo-add $line
done < $repo_list

# Install the apps that have no changes from default

${AUTOPKG} run -l install_recipes.txt

# Those awkward ones that need 'special help'

${AUTOPKG} run -k OS_VERSION="10.11" Puppet-Agent.install

# Install homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install the mas binary from homebrew
/usr/local/bin/brew tap argon/mas

/usr/local/bin/brew install mas

get_mas() {
    local app_id=$1
    local app_path=$2

    [ ! -d "${app_path}"  ] && /usr/local/bin/mas install $app_id
}


/usr/local/bin/mas signin $appstoreusername "${appstorepassword}"

get_mas 927292435 "/Applications/iStat Mini.app"

get_mas 961850017 "/Applications/GIFs.app"

get_mas 409183694 "/Applications/Keynote.app"

get_mas 409907375 "/Applications/Apple Remote Desktop.app"

get_mas 403304796 "/Applications/iNet Network Scanner.app"

get_mas 413857545 "/Applications/Divvy.app"

get_mas 494803304 "/Applications/WiFi Explorer.app"

get_mas 407963104 "/Applications/Pixelmator.app"

get_mas 425955336 "/Applications/Skitch.app"

get_mas 557168941 "/Applications/Tweetbot.app"

get_mas 880001334 "/Applications/Reeder.app"

get_mas 497799835 "/Applications/Xcode.app"

get_mas 847496013 "/Applications/Deckset.app"

get_mas 409201541 "/Applications/Pages.app"

get_mas 715768417 "/Applications/Microsoft Remote Desktop.app"

get_mas 504544917 "/Applications/Clear.app"

get_mas 420212497 "/Applications/Byword.app"

get_mas 568494494 "/Applications/Pocket.app"

get_mas 458034879 "/Applications/Dash.app"

echo "Now run puppet.sh as root"
