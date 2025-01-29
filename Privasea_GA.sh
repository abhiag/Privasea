#!/bin/bash

printf "\n"
cat <<EOF


░██████╗░░█████╗░  ░█████╗░██████╗░██╗░░░██╗██████╗░████████╗░█████╗░
██╔════╝░██╔══██╗  ██╔══██╗██╔══██╗╚██╗░██╔╝██╔══██╗╚══██╔══╝██╔══██╗
██║░░██╗░███████║  ██║░░╚═╝██████╔╝░╚████╔╝░██████╔╝░░░██║░░░██║░░██║
██║░░╚██╗██╔══██║  ██║░░██╗██╔══██╗░░╚██╔╝░░██╔═══╝░░░░██║░░░██║░░██║
╚██████╔╝██║░░██║  ╚█████╔╝██║░░██║░░░██║░░░██║░░░░░░░░██║░░░╚█████╔╝
░╚═════╝░╚═╝░░╚═╝  ░╚════╝░╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░░░░░░░╚═╝░░░░╚════╝░
EOF

printf "\n\n"

##########################################################################################
#                                                                                        
#                🚀 THIS SCRIPT IS PROUDLY CREATED BY **GA CRYPTO**! 🚀                 
#                                                                                        
#   🌐 Join our revolution in decentralized networks and crypto innovation!               
#                                                                                        
# 📢 Stay updated:                                                                      
#     • Follow us on Telegram: https://t.me/GaCryptOfficial                             
#     • Follow us on X: https://x.com/GACryptoO                                         
##########################################################################################

# Green color for advertisement
GREEN="\033[0;32m"
RESET="\033[0m"

# Print the advertisement using printf
printf "${GREEN}"
printf "🚀 THIS SCRIPT IS PROUDLY CREATED BY **GA CRYPTO**! 🚀\n"
printf "Stay connected for updates:\n"
printf "   • Telegram: https://t.me/GaCryptOfficial\n"
printf "   • X (formerly Twitter): https://x.com/GACryptoO\n"
printf "${RESET}"

# Privanetix Node Setup Script

# Function to check the exit status of the last executed command
check_status() {
    if [ $? -ne 0 ]; then
        echo "❌ Error: $1 failed. Exiting."
        exit 1
    fi
}

# Update and install necessary dependencies
echo "🔄 Updating package list and installing dependencies..."
sudo apt update && sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
check_status "Package installation"

# Add Docker's official GPG key
echo "🔑 Adding Docker's GPG key..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
check_status "Adding Docker GPG key"

# Add Docker's official repository
echo "📦 Adding Docker repository..."
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
check_status "Adding Docker repository"

# Update package list again
echo "🔄 Updating package list..."
sudo apt update
check_status "Package list update"

# Install Docker
echo "🐳 Installing Docker..."
sudo apt install -y docker-ce
check_status "Docker installation"

# Start and enable Docker service
echo "🚀 Starting and enabling Docker service..."
sudo systemctl start docker
sudo systemctl enable docker
check_status "Starting Docker service"

# Function to restart Docker and retry pulling the image
pull_docker_image() {
    # Try pulling the Docker image
    echo "📥 Pulling Privanetix Node Docker image..."
    sudo docker pull privasea/acceleration-node-beta
    if [ $? -ne 0 ]; then
        echo "❌ Error: Pulling Docker image failed. Restarting Docker and retrying..."
        # Restart Docker service
        sudo systemctl daemon-reload
        sudo systemctl restart docker
        check_status "Restarting Docker service"
        # Retry pulling the image after restarting Docker
        echo "🔄 Retrying Docker image pull..."
        sudo docker pull privasea/acceleration-node-beta
        check_status "Retrying Docker image pull"
    fi
}

# Create the program running directory
echo "📂 Creating program directory..."
sudo mkdir -p /privasea/config
sudo chown -R $USER:$USER /privasea
cd /privasea
check_status "Creating program directory"

# Generate a new keystore
echo "🔐 Generating new keystore..."
sudo docker run -it -v "/privasea/config:/app/config" privasea/acceleration-node-beta:latest ./node-calc new_keystore
check_status "Keystore generation"

# Rename the keystore file in the /privasea/config folder to wallet_keystore
echo "📝 Checking for a keystore file starting with 'UTC--' to rename it to 'wallet_keystore'..."

# Navigate to the configuration directory
cd /privasea/config

# Find the file that starts with "UTC--" (handles unique file names)
keystore_file=$(ls | grep "^UTC--")

if [ -z "$keystore_file" ]; then
    echo "❌ Error: No keystore file found in /privasea/config. Exiting."
    exit 1
fi

# Rename the keystore file to wallet_keystore
echo "🔄 Renaming '$keystore_file' to 'wallet_keystore'..."
mv "$keystore_file" "wallet_keystore"

# Verify the rename was successful
if [ -f "wallet_keystore" ]; then
    echo "✅ The keystore file has been successfully renamed to 'wallet_keystore'."
else
    echo "❌ Error: Failed to rename the keystore file. Exiting."
    exit 1
fi

echo "✅ Setup completed successfully!"
echo "Please note down your node address and keystore password for future reference."
