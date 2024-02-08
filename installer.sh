#!/bin/bash

 # Install Homebrew
if command -v brew > /dev/null; then
    echo "Homebrew is already installed."
else 
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
 
    if [ $? -eq 0 ]; then
        echo "Homebrew installed successfully."
    else
        echo "Error: Homebrew installation failed."
        exit 1
    fi
fi

# General package installer
install_package() {
    local package_name=$1
 
    if command -v $package_name > /dev/null; then
        echo "$package_name is already installed."
    else 
        echo "Installing $package_name..."
        brew install $package_name
 
        if [ $? -eq 0 ]; then
            echo "$package_name installed successfully."
        else
            echo "Error: $package_name installation failed."
            exit 1
        fi
    fi
}

# Install Git
install_package "git" 
