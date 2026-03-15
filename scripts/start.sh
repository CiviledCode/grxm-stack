#!/bin/bash

cd "$(dirname "$0")/.." || exit 1

# Ensure iam-keys directory exists for volume mounting
mkdir -p ./iam-keys

# Build the docker images
echo "Building grxm-stack environment..."
sudo docker-compose build

# Start the environment in detached mode
echo "Starting grxm-stack environment..."
sudo docker-compose up -d

# Show running containers
echo "Environment status:"
sudo docker-compose ps
