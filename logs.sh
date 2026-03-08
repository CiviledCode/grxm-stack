#!/bin/bash

# Fetch logs for the environment
if [ -z "$1" ]; then
    echo "Tailing logs for all services (press Ctrl+C to stop)..."
    sudo docker-compose logs -f
else
    echo "Tailing logs for service: $1 (press Ctrl+C to stop)..."
    sudo docker-compose logs -f "$1"
fi
