# setup_script
A script to get a mac set up for my use

## Usage

This is designed to be used on a new Mac out of the box. Set up your usual username (the Puppet code assumes grahamgilbert) and sign in with your Apple ID (this logs you into the app store).

I know curling to bash is wrong and bad, but it's easier this way

```
$ curl -s https://raw.githubusercontent.com/grahamgilbert/setup_script/master/setup.sh | sudo bash
```

Once Dropbox is installed, open it and log in to start syncing - the Puppet class relies on some things being present.
