#!/bin/bash
set -e

SERVER_IP=$1
ENV=$2
DIR="/home/ubuntu/app"
IMAGE="anitodevops/app-deploy-${ENV}:latest"

#Deploying Docker image to Application Server

ssh -i newtestkey.pem ubuntu@${SERVER_IP} << EOF
  set -e
  mkdir -p ${DIR}
  cd ${DIR}
  sudo apt update -y
  sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose

#Creating docker-compose.yml
  cat <<EOT > docker-compose.yml
version: "3"
services:
  app:
    image: ${IMAGE}
    container_name: app_container
    ports:
      - "80:80"
    restart: always
EOT
#pulling image from registry
  sudo docker-compose pull
#runs the App container 
  sudo docker-compose up -d --remove-orphans
EOF
