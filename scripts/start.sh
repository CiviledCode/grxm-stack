#!/bin/bash

cd "$(dirname "$0")/.." || exit 1

# Ensure iam-keys directory exists for volume mounting
mkdir -p ./iam-keys

# Source .env file to get STACK_NAME
if [ -f .env ]; then
    source .env
fi
STACK_NAME=${STACK_NAME:-grxm}

# Build the docker images
echo "Building grxm-stack environment..."
sudo docker-compose build

# Start the environment in detached mode
echo "Starting grxm-stack environment..."
sudo docker-compose up -d

# Show running containers
echo "Environment status:"
sudo docker-compose ps
