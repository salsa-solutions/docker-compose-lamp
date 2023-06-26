#!/bin/bash

# Detect sudo usage
if [[ $(id -u) -ne 0 ]]; then
    echo "This script requires root privileges. Please run with sudo."
    exit 1
fi

# Detect the package manager
if command -v apt >/dev/null 2>&1; then
    PACKAGE_MANAGER="apt"
elif command -v yum >/dev/null 2>&1; then
    PACKAGE_MANAGER="yum"
elif command -v dnf >/dev/null 2>&1; then
    PACKAGE_MANAGER="dnf"
elif command -v pacman >/dev/null 2>&1; then
    PACKAGE_MANAGER="pacman"
elif command -v yay >/dev/null 2>&1; then
    PACKAGE_MANAGER="yay"
else
    echo "Unable to detect a supported package manager (apt, yum, dnf, pacman, or yay). Exiting."
    exit 1
fi

# Install packages


# Prompt for repository URL or show help menu
if [[ $# -eq 0 ]]; then
    echo "Usage: sudo ./script.sh [repository URL]"
    echo "Example: sudo ./script.sh http://pioxy.net:3000/Salsa/C.R.A.P"
else
    echo "Installing necessary packages using $PACKAGE_MANAGER..."

    if [[ $PACKAGE_MANAGER == "apt" ]]; then
        apt install -y git docker docker-compose
    elif [[ $PACKAGE_MANAGER == "yum" || $PACKAGE_MANAGER == "dnf" ]]; then
        $PACKAGE_MANAGER install -y git docker docker-compose
    elif [[ $PACKAGE_MANAGER == "pacman" ]]; then
        pacman -Sy --noconfirm git docker docker-compose
    elif [[ $PACKAGE_MANAGER == "yay" ]]; then
        yay -Sy --noconfirm git docker docker-compose
    fi
    REPO_URL="$1"

    # Clone the repository
    echo "Cloning repository..."
    # git clone "$REPO_URL" ./www

    # Start Docker container using docker-compose
    echo "Starting Docker container..."
    docker-compose up -d
fi
