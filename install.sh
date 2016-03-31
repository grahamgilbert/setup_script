#!/bin/bash

# This script uses autopkg to install most of the software needed (apart from homebrew stuff)

# Ask for MAS creds
read -p "App Store Username:" appstoreusername
read -s -p "App Store Password:" appstorepassword

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

MAS=/usr/local/bin/mas

$MAS signin $appstoreusername "${appstorepassword}"

$MAS install 927292435

$MAS install 961850017

$MAS install 409183694

$MAS install 409907375

$MAS install 403304796

$MAS install 413857545

$MAS install 494803304

$MAS install 407963104

$MAS install 425955336

$MAS install 557168941

$MAS install 880001334

$MAS install 497799835

$MAS install 847496013

$MAS install 409201541

$MAS install 715768417

$MAS install 504544917

$MAS install 420212497

$MAS install 568494494

$MAS install 458034879

echo "Now run puppet.sh as root"
