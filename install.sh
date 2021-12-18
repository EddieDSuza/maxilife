#!/bin/bash

# Welcome Message
echo "*******************************************"
echo "Setting Up Maxilife Hub W/ Zigbee - Ver 1.0"
echo "*******************************************"

# System Upgrade
echo "***********************"
echo "Commence System Upgrade"
echo "***********************"
sudo apt -y update
sudo apt -y upgrade
sudo rpi-eeprom-update -d -a
echo "************************"
echo "System Upgrade Completed"
echo "************************"

# Argon One setup
echo "************************"
echo "Commence Argon One Setup"
echo "************************"
curl https://download.argon40.com/argon1.sh | bash 

# Docker setup
echo "*********************"
echo "Commence Docker Setup"
echo "*********************"
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker pi
echo "**********************"
echo "Docker Setup Completed"
echo "**********************"

# Portainer setup
echo "************************"
echo "Commence Portainer Setup"
echo "************************"
sudo docker run -d -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
echo "*************************"
echo "Portainer Setup Completed"
echo "*************************"

# Watch Tower setup
echo "**************************"
echo "Commence Watch Tower Setup"
echo "**************************"
sudo docker run --name="watchtower" -d --restart=always -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower
echo "***************************"
echo "Watch Tower Setup Completed"
echo "***************************"

# Omada setup
echo "**********************"
echo "Commence Tp-Link Setup"
echo "**********************"
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
echo "***********************"
echo "Tp-Link Setup Completed"
echo "***********************"

# MQTT Install
echo "*******************"
echo "Commence MQTT Setup"
echo "*******************"
sudo mkdir mosquitto
sudo mkdir mosquitto/config/
sudo mkdir mosquitto/data/
sudo wget https://raw.githubusercontent.com/EddieDSuza/maxilife/main/mosquitto.conf -P /mosquitto/config/
sudo docker run -it --name MQTT --restart=always --net=host -tid -p 1883:1883 -v $(pwd)/mosquitto:/mosquitto/ eclipse-mosquitto
echo "********************"
echo "MQTT Setup Completed"
echo "********************"

# Z2M setup
echo "**************************"
echo "Commence Zigbee2MQTT Setup"
echo "**************************"
wget https://raw.githubusercontent.com/EddieDSuza/maxilife/main/configuration.yaml -P data

sudo docker run \
   --name zigbee2mqtt \
   --device=/dev/ttyACM0 \
   --net host \
   -v $(pwd)/data:/app/data \
   -v /run/udev:/run/udev:ro \
   -e TZ=Asia/Dubai \
   koenkk/zigbee2mqtt
echo "***************************"
echo "Zigbee2MQTT Setup Completed"
echo "***************************"

# Node Install
echo "*********************"
echo "Commence Node Upgrade"
echo "*********************"
yes | sudo hb-service update-node
sudo docker start zigbee2mqtt

echo "*************************************"
echo "ALL PACKAGES INSTALLED WITH NO ERRORS"
echo "*************************************"

sudo reboot
