#!/bin/bash

# This script uses autopkg to install most of the software needed (apart from homebrew stuff)

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

echo "Now run puppet.sh as root"
