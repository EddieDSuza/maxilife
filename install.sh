#!/bin/bash

# Welcome Message

echo "Setting Up Maxilife Hub - Ver 1.0"

# System Upgrade
yes | sudo apt-get install && sudo apt full-upgradedo 
yes | sudo sudo rpi-update

# Argon One setup
curl https://download.argon40.com/argon1.sh | bash 

# Docker setup
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker pi

# Portainer setup
sudo docker run -d -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest

# Watch Tower setup
sudo docker run --name="watchtower" -d --restart=always -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower

# Omada setup
sudo docker volume create omada-data
sudo docker volume create omada-work
sudo docker volume create omada-logs

sudo docker run -d \
  --name omada-controller \
  --restart unless-stopped \
  --net host \
  -e MANAGE_HTTP_PORT=8088 \
  -e MANAGE_HTTPS_PORT=8043 \
  -e PORTAL_HTTP_PORT=8088 \
  -e PORTAL_HTTPS_PORT=8843 \
  -e SHOW_SERVER_LOGS=true \
  -e SHOW_MONGODB_LOGS=false \
  -e SSL_CERT_NAME="tls.crt" \
  -e SSL_KEY_NAME="tls.key" \
  -e TZ=Etc/UTC \
  -v omada-data:/opt/tplink/EAPController/data \
  -v omada-work:/opt/tplink/EAPController/work \
  -v omada-logs:/opt/tplink/EAPController/logs \
  mbentley/omada-controller:latest
  
# Z2M setup
wget https://raw.githubusercontent.com/Koenkk/zigbee2mqtt/master/data/configuration.yaml -P data

sudo docker run \
   --name zigbee2mqtt \
   --device=/dev/ttyACM0 \
   --net host \
   -v $(pwd)/data:/app/data \
   -v /run/udev:/run/udev:ro \
   -e TZ=Europe/Amsterdam \
   koenkk/zigbee2mqtt

# MQTT Install
sudo apt-get install mosquitto -y
sudo apt-get install mosquitto-clients

# Node Install
yes | sudo hb-service update-node

echo "*************************************"
echo "ALL PACKAGES INSTALLED WITH NO ERRORS"
echo "*************************************"
