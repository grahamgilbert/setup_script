#!/bin/bash

# install r10k
gem install r10k

# Run r10k with Puppetfile
r10k puppetfile install Puppetfile -v

# Run Puppet Apply with grahamconfig class
/opt/puppetlabs/bin/puppet apply -e "include grahamconfig"

echo "Now run mas.sh as your normal user to install App Store Apps"
