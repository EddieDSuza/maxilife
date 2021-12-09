#!/bin/bash

# system upgrade 
sudo apt-get install mosquitto -y
sudo apt-get install mosquitto-clients

# argon one upgrade
curl https://download.argon40.com/argon1.sh | bash
