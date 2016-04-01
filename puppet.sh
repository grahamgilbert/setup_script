#!/bin/bash

# install r10k
gem install r10k

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
# Run r10k with Puppetfile
r10k puppetfile install "Puppetfile" -v

# Run Puppet Apply with grahamconfig class
/opt/puppetlabs/bin/puppet apply -e "include grahamconfig"
