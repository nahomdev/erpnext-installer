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

# brew package installer
install_brew_package() {
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

upgrade_brew_package() {
    local package_name=$1
 
    if command -v $package_name > /dev/null; then
        echo "$package_name is already installed."
    else 
        echo "Installing $package_name..."
        brew upgrade $package_name
 
        if [ $? -eq 0 ]; then
            echo "$package_name installed successfully."
        else
            echo "Error: $package_name installation failed."
            exit 1
        fi
    fi
}

start_service() {
    local service_name=$1

    # Start the service
    echo "Starting $service_name service..."
    brew services start $service_name
}

#pyton package installer
install_pyton_package() {
    local package_name=$1

    if command -v $package_name > /dev/null; then
        echo "$package_name is already installed."
    else
        echo "Installing $package_name..."
        pip3 install $package_name
      if [ $? -eq 0 ]; then
            echo "$package_name installed successfully."
        else
            echo "Error: $package_name installation failed."
            exit 1
        fi
    fi
}

install_npm_package() {
    local package_name=$1

    if command -v npm > /dev/null; then
        echo "Installing $package_name using npm..."
        npm install -g $package_name

    # Check if the installation was successful
        if [ $? -eq 0 ]; then
            echo "$package_name installed successfully."
        else
            echo "Error: $package_name installation failed."
            exit 1
        fi
    else
        echo "Error: npm is not installed. Please install npm and try again."
        exit 1
    fi
}

update_config_file() {
    local file_path=$1
    local content=$2

    # Check if the content is already in the file
    if grep -q "$content" "$file_path"; then
        echo "Configuration already exists in $file_path."
    else
        # Add the content to the file
        echo -e "$content" >> "$file_path"
        echo "Configuration added to $file_path."
    fi
}

# Install Packages
install_brew_package "git" 
install_brew_package "python3"

# Install Python packages
install_pyton_package "setuptools"
install_pyton_package "virtualenv"

# Install mariadb
install_brew_package "mariadb"
# Upgrade mariadb
upgrade_brew_package "mariadb"
mysql_install_db #database installer
mysql.server start #start mariadb server
mysql_secure_installation #start secure installer

# Install mysql-client
install_brew_package "mysql-client"

#Edit the mariadb configuration
config_content="[mysqld]
character-set-client-handshake = FALSE
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci

[mysql]
default-character-set = utf8mb4"
update_config_file "/opt/homebrew/etc/mariadb/my.cnf" "$config_content"

# Start mariadb server
start_service "mariadb"

# install redis and node
install_brew_package "redis"
install_brew_package "node"

#install yarn using npm
install_npm_package "yarn"

install_brew_package "wkhtmltopdf"

#install frappe bench
install_pyton_package "frappe-bench"
# initilise the frappe bench & install frappe latest version"
bench init frappe-bench 
cd frappe-bench/

bench new-site site1.local
# install npm packages again

bench get-app https://github.com/frappe/erpnext  

bench --site site1.local add-to-hosts

bench start

echo "DISCLAIMER USE IT AT YOUR COST"
echo "frappe is BS"