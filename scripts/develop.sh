#!/bin/sh

sudo service ssh start

echo "SSH is now running. This is an ephemeral environment. All persistent data should be stored in /data."

tail -f /dev/null
