#!/bin/bash

echo "--- grxm-stack Updater ---"

echo "Checking for uncommitted changes..."

echo -e "\n[1/3] Updating grxm-stack (Core Configuration)..."
git pull

echo -e "\n[2/3] Updating grxm-iam (Identity Service)..."
if [ -d "grxm-iam/.git" ]; then
    git -C grxm-iam pull
else
    echo "grxm-iam repository not found. Skipping."
fi

echo -e "\n[3/3] Updating grxm-webapp (Template Webapp)..."
if [ -d "grxm-webapp/.git" ]; then
    echo "WARNING: Pulling updates for the webapp template might cause merge conflicts"
    echo "if you have heavily modified the code for your specific project."
    read -p "Do you want to pull the latest upstream changes for the webapp? (y/N): " UPDATE_WEBAPP
    if [[ "$UPDATE_WEBAPP" =~ ^[Yy]$ ]]; then
        git -C grxm-webapp pull
    else
        echo "Skipping webapp update. Your local modifications are safe."
    fi
else
    echo "grxm-webapp repository not found. Skipping."
fi

echo -e "\nUpdate process complete."
echo "If any configurations or Dockerfiles changed, apply them by running:"
echo "  ./scripts/stop.sh && ./scripts/start.sh"