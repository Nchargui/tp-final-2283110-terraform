#!/bin/bash

# Step 1 - Installing dependencies
echo "Updating packages..."
sudo apt update
echo "Installing dependencies..."
sudo apt install -y git curl

# Step 2 - Installing Docker using convenience script
echo "Installing Docker using convenience script..."
sudo curl -fsSL https://get.docker.com -o /opt/get-docker.sh
sudo sh /opt/get-docker.sh

# Step 3 - Cloning the repo
echo "Cloning the repo..."
sudo git clone https://github.com/Nchargui/tp-final-infornuage-2283110.git /opt/tp-final-infornuage-2283110


# Running docker compose (deploying stack)
echo "Deploying application..."
sudo docker compose -f /opt/tp-final-infornuage-2283110/compose.yml up -d

# Sleeping to wait for db to populate
echo "Waiting for database to populate..."
sleep 30

