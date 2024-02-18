# xymon-stuff
## UnxClient
This directory contains 2 scripts, one based on curl and the other based on wget.
The scripts can be used as dropin replacement for the xymon binary.
Data is tranmitted via https so it's encrypted.
It's also protected with usernaam / paswoord so only authorized clients can send data.

The default usernaam / paswoord for https access is client / client.

You als need the curl-confg or wget-config file and place the file in the etc directory of the client.

The xymon-apache.conf contains an extra config for a directory where you have to copy xymoncgimsg.cgi or create a symlink to it.
This contains also a htpasswd file so it's protected with usernaam / paswoord. This should match with the setting in curl-config or wget-config file.
This htpasswd file can be created with the httpasswd command.

## WinPSClient
I pachted the Windows Powershell to fix some bugs and add extra options.
