#!/bin/bash

# system upgrade 
sudo apt-get install mosquitto -y
sudo apt-get install mosquitto-clients

curl -fsSL https://get.docker.com -o get-docker.sh
