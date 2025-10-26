#!/bin/bash
set -e

ENV=$1
IMAGE="anitodevops/app-deploy-${ENV}:latest"

echo "Building Docker ${IMAGE}"
docker build -t "${IMAGE}" .

echo "Pushing Docker ${IMAGE} to Docker Hub"
docker push "${IMAGE}"
