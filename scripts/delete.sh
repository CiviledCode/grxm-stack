#!/bin/bash

cd "$(dirname "$0")/.." || exit 1

echo "WARNING: This will completely remove the Docker footprint of this stack (containers, networks, images, and volumes)."
read -p "Are you sure you want to proceed? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "Stopping containers and deleting docker footprint..."
    sudo docker-compose down -v --rmi all --remove-orphans
    echo "Docker footprint deleted successfully."
else
    echo "Aborted."
fi