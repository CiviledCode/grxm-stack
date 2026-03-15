#!/bin/bash

echo "WARNING: This will completely wipe the IAM MongoDB database, the App MongoDB database, Redis cache, and all IAM users!"
read -p "Are you sure you want to proceed? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "Stopping containers and wiping volumes..."
    # The -v flag tells docker-compose to remove all named volumes (like mongo-data)
    sudo docker-compose down -v
    echo "Database wiped successfully."
else
    echo "Aborted."
fi
