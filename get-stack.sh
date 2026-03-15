#!/bin/bash

echo "--- grxm-stack Initializer ---"
echo "This script will clone the base stack, the IAM service, and your custom Webapp template."
echo ""

read -p "Enter GitHub Personal Access Token (press Enter to skip if using public repos or SSH): " GH_TOKEN

STACK_URL="https://github.com/CiviledCode/grxm-stack.git"
IAM_URL="https://github.com/CiviledCode/grxm-iam.git"

# Inject the token into the GitHub URLs if provided
if [ -n "$GH_TOKEN" ]; then
    STACK_URL="https://${GH_TOKEN}@github.com/CiviledCode/grxm-stack.git"
    IAM_URL="https://${GH_TOKEN}@github.com/CiviledCode/grxm-iam.git"
fi

read -p "Enter the directory name for your new project [my-grxm-project]: " PROJECT_DIR
PROJECT_DIR=${PROJECT_DIR:-my-grxm-project}

read -p "Enter a unique stack prefix for docker containers [grxm]: " STACK_NAME
STACK_NAME=${STACK_NAME:-grxm}

echo "Cloning grxm-stack into $PROJECT_DIR..."
git clone "$STACK_URL" "$PROJECT_DIR"

# Move into the newly cloned stack directory
cd "$PROJECT_DIR" || exit 1

echo "Cloning grxm-iam..."
git clone "$IAM_URL" grxm-iam

echo ""
read -p "Enter the Git repository URL for your Webapp (e.g., https://github.com/your-org/your-webapp.git): " WEBAPP_URL

if [ -n "$WEBAPP_URL" ]; then
    # Attempt to inject token for the webapp if it's a GitHub HTTPS URL
    if [ -n "$GH_TOKEN" ] && [[ "$WEBAPP_URL" == *"github.com"* && "$WEBAPP_URL" == "https://"* ]]; then
        WEBAPP_URL="${WEBAPP_URL/https:\/\//https:\/\/${GH_TOKEN}@}"
    fi
    echo "Cloning webapp into grxm-webapp directory..."
    git clone "$WEBAPP_URL" grxm-webapp
else
    echo "No Webapp URL provided. You will need to clone it manually into ./grxm-webapp"
fi

echo ""
echo "Bootstrap complete! Your new stack is ready in ./$PROJECT_DIR"
echo "STACK_NAME=$STACK_NAME" > .env
echo "PROJECT_ROOT=." >> .env

echo "Next steps:"
echo "  1. cd $PROJECT_DIR"
echo "  2. Review .env and configuration files"
echo "  3. ./start.sh"