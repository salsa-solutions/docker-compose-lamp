#!/bin/bash

# Detect sudo usage
if [[ $(id -u) -ne 0 ]]; then
    echo "This script requires root privileges. Please run with sudo."
    exit 1
fi

# Detect the package manager
package_managers=("apt" "yum" "dnf" "pacman" "yay")
PACKAGE_MANAGER=""

for manager in "${package_managers[@]}"; do
    if command -v "$manager" >/dev/null 2>&1; then
        PACKAGE_MANAGER="$manager install -y git docker docker-compose"
        break
    fi
done

if [[ -z "$PACKAGE_MANAGER" ]]; then
    echo "Unable to detect a supported package manager (apt, yum, dnf, pacman, or yay). Exiting."
    exit 1
fi

# Install packages
echo "Usage: sudo bash script.sh [repository URL]"
echo "Example: sudo bash script.sh https://github.com/sprintcube/docker-compose-lamp"

# Prompt for repository URL or show help menu
if [[ $# -eq 0 ]]; then
    echo "Installing necessary packages using $PACKAGE_MANAGER..."
    if ! command -v docker-compose >/dev/null 2>&1; then
        echo "Docker Compose is already installed. Skipping."
        if ! command -v docker-compose >/dev/null 2>&1; then
            echo "Docker Compose is already installed. Skipping."
            if ! command -v git >/dev/null 2>&1; then
                echo "Git is already installed. Skipping."
            else
                if ! eval "$PACKAGE_MANAGER"; then
                    echo "Package installation failed. Exiting."
                    exit 1
                fi
            fi 
        else
        if ! eval "$PACKAGE_MANAGER"; then
            echo "Package installation failed. Exiting."
            exit 1
        fi
    fi
fi

    echo "Enabling and starting Docker..."
    systemctl enable --now docker.service docker.socket

    sleep 1

    REPO_URL="$1"

    # Clone the repository
    echo "Cloning repository..."
    if [[ -z "$REPO_URL" ]]; then
        echo "No repository URL provided. Exiting."
        exit 1
    fi

    git clone "$REPO_URL" ./www

    # Start Docker container using docker-compose
    echo "Starting Docker container..."
    docker-compose up -d
fi
