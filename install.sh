#!/bin/bash

# Get current username
USER_HOME="/home/$(whoami)"
PIFMRDS_DIR="$USER_HOME/PiFmRds"

# Install dependencies
echo "Install dependencies..."
sudo apt-get update
sudo apt-get install -y sox libsox-fmt-mp3 libsndfile1-dev

# Clone the github repository PiFmRds
echo "Clone the github repository PiFmRds to $PIFMRDS_DIR..."
git clone https://github.com/DABodr/PiFmRds.git "$PIFMRDS_DIR"

# Compile PiFmRds
echo "Compilation of PiFmRds..."
cd "$PIFMRDS_DIR/src"
make clean
make

# Make run.sh executable
chmod +x "$PIFMRDS_DIR/run.sh"

# Installation is complete
echo "PiFmRds installation completed in $PIFMRDS_DIR."
echo "You can run PiFmRds with a predefined configuration using the file $PIFMRDS_DIR/run.sh"
