#!/bin/bash

echo "Bootstraping..."
minifab netup -s couchdb -e true -o manufacturer.auth.com
sleep 10
echo "Channel Creation..."
minifab create -c authchannel
sleep 10
echo "Channel Joining"
minifab join -c authchannel
sleep 10
echo "Anchor Update"
minifab anchorupdate
sleep 10
echo "Profile Creation..."
minifab profilegen -c authchannel