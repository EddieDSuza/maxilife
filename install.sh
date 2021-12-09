#!/bin/bash

curl https://download.argon40.com/argon1.sh | bash 
curl -fsSL https://get.docker.com -o get-docker.sh

sudo sh get-docker.sh

sudo usermod -aG docker pi
