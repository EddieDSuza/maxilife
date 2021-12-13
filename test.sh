#!/bin/bash

# Welcome Message
echo "*******************************************"
echo "Setting Up Maxilife Hub W/ Zigbee - Ver 1.0"
echo "*******************************************"

sudo apt-get install mosquitto -y
sudo apt-get install mosquitto-clients

sudo mosquitto_passwd -c /etc/mosquitto/pwfile admin

read -sp 'Password:' admin;

if [[ $password -ne WHAT GOES HERE? ]]; then
    MORE CODE HERE
else
    MORE CODE HERE
fi

read -sp 'Reenter password:' admin;
if [[ $password -ne WHAT GOES HERE? ]]; then
    MORE CODE HERE
else
    MORE CODE HERE
fi
