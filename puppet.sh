#!/bin/bash

# install r10k
gem install r10k

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR"
# Run r10k with Puppetfile
r10k puppetfile install "Puppetfile" -v

loggedInUser=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`

# Run Puppet Apply with grahamconfig class
/opt/puppetlabs/bin/puppet apply -e "class {'grahamconfig': my_username => $loggedInUser', my_homedir => '/Users/$loggedInUser', my_sourcedir => '/Users/$loggedInUser/src' }"
