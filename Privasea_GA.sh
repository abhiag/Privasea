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

# Function to retry a command multiple times until success
retry_command() {
    local command="$1"
    local retries=5
    local delay=10
    local count=0

    until $command; do
        count=$((count + 1))
        if [ $count -ge $retries ]; then
            echo "❌ Error: Command failed after $retries attempts. Exiting."
            exit 1
        fi
        echo "⏳ Retrying ($count/$retries)..."
        sleep $delay
    done
}

# Update and install necessary dependencies
echo "🔄 Updating package list and installing dependencies..."
retry_command "sudo apt update && sudo apt install -y apt-transport-https ca-certificates curl software-properties-common"

# Add Docker's official GPG key
echo "🔑 Adding Docker's GPG key..."
retry_command "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -"

# Add Docker's official repository
echo "📦 Adding Docker repository..."
retry_command "sudo add-apt-repository 'deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable'"

# Update package list again
echo "🔄 Updating package list..."
retry_command "sudo apt update"

# Install Docker
echo "🐳 Installing Docker..."
retry_command "sudo apt install -y docker-ce"

# Start and enable Docker service
echo "🚀 Starting and enabling Docker service..."
retry_command "sudo systemctl start docker && sudo systemctl enable docker"

# Function to restart Docker and retry pulling the image
pull_docker_image() {
    # Try pulling the Docker image
    echo "📥 Pulling Privanetix Node Docker image..."
    retry_command "sudo docker pull privasea/acceleration-node-beta"
}

# Pull Docker image
pull_docker_image

# Create the program running directory
echo "📂 Creating program directory..."
retry_command "sudo mkdir -p /privasea/config && sudo chown -R $USER:$USER /privasea"

# Generate a new keystore
echo "🔐 Generating new keystore..."
retry_command "sudo docker run -it -v \"/privasea/config:/app/config\" privasea/acceleration-node-beta:latest ./node-calc new_keystore"

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
retry_command "mv \"$keystore_file\" \"wallet_keystore\""

# Verify the rename was successful
if [ -f "wallet_keystore" ]; then
    echo "✅ The keystore file has been successfully renamed to 'wallet_keystore'."
else
    echo "❌ Error: Failed to rename the keystore file. Exiting."
    exit 1
fi

echo "✅ Setup completed successfully!"
echo "Please note down your node address and keystore password for future reference."
