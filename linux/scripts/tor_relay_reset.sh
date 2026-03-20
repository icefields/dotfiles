#!/bin/bash

source torsocks off
echo "Tor mode deactivated. Command will NOT go through Tor anymore."
oldIp=$(torsocks wget -qO - https://api.ipify.org; echo)
echo $oldIp

# Define the Tor control port and password
TOR_HOST="127.0.0.1"
TOR_PORT="9051"
TOR_PASSWORD=$TOR_PASSWORD

# Send the commands via telnet using input redirection
{
  echo "AUTHENTICATE \"$TOR_PASSWORD\""
  sleep 1
  echo "SIGNAL NEWNYM"
  sleep 1
  echo "SIGNAL CLEARDNSCACHE"
  sleep 1
  echo "quit"
} | telnet $TOR_HOST $TOR_PORT

newIp=$(torsocks wget -qO - https://api.ipify.org; echo)
echo $newIp

notify-send "Old Tor IP:${oldIp}  -  New Tor IP: ${newIp}"
