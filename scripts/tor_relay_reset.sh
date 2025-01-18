#!/bin/bash

source torsocks off
echo "Tor mode deactivated. Command will NOT go through Tor anymore."
torsocks wget -qO - https://api.ipify.org; echo

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

torsocks wget -qO - https://api.ipify.org; echo

