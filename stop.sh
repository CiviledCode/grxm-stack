#!/bin/bash

# Stop and remove containers, networks, and images defined in docker-compose.yml
echo "Stopping grxm-stack environment..."
sudo docker-compose down

echo "Environment stopped."
