#!/bin/bash
set -e

BOLD=$(tput bold)
BLUE=$(tput setaf 4)
RESET=$(tput sgr0)

LOG_FILE="install_script.log"

log_info() {
    local message=$1
    echo -e "${BLUE}${BOLD}[INFO]${RESET} $message"
    echo "[INFO] $message" | sudo tee -a "$LOG_FILE" > /dev/null
}

is_package_installed() {
    local package=$1
    dpkg -s "$package" &> /dev/null
}

install_apt_package() {
    local package=$1
    if is_package_installed "$package"; then
        log_info "Package $package is already installed."
    else
        log_info "Installing package: $package"
        sudo apt install -y "$package"
    fi
}

install_pip_package() {
    local package=$1
     if is_package_installed "$package"; then
        log_info "Package $package is already installed."
    else
        log_info "Installing package: $package"
        pip3 install --user $package
    fi
}

write_to_file() {
    local content=$1
    local destination=$2
    log_info "Writing content to file: $destination"
    echo "$content" | sudo tee "$destination" >/dev/null
}


prompt_frappe_bench_location() {
    read -p "Enter the path where you want to initialize Frappe Bench: " frappe_bench_location
 
    if [ ! -d "$frappe_bench_location" ]; then
        log_error "Error: The specified path does not exist or is not a directory."
        exit 1
    fi

    log_info "Frappe Bench will be initialized at: $frappe_bench_location"
}


log_info "Updating system packages..."
sudo apt update

log_info "Upgrading system packages..."
sudo apt upgrade -y

# Install required packages
install_apt_package python3-minimal
install_apt_package build-essential
install_apt_package python3-setuptools
install_apt_package python3-pip
install_apt_package python3-dev
install_apt_package libffi-dev
install_apt_package libssl-dev
install_apt_package ca-certificates
install_apt_package curl
install_apt_package gnupg
install_apt_package xvfb
install_apt_package libfontconfig
install_apt_package wkhtmltopdf
install_apt_package libmysqlclient-dev
install_apt_package software-properties-common
install_apt_package python3.10-venv
install_apt_package supervisor
install_apt_package mariadb-server
install_apt_package mariadb-client

sudo mysql_secure_installation

my_cnf_content="[mysqld]
character-set-client-handshake = FALSE
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci

[mysql]
default-character-set = utf8mb4"
write_to_file "$my_cnf_content" "/etc/mysql/my.cnf"


install_apt_package redis-server

log_info "Creating directory: /etc/apt/keyrings"
sudo mkdir -p /etc/apt/keyrings

log_info "Downloading NodeSource GPG key..."
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg

NODE_MAJOR=18
repository_line="deb [arch=amd64 signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main"
write_to_file "$repository_line" "/etc/apt/sources.list.d/nodesource.list"

log_info "Updating system packages to fetch the new repository information..."
sudo apt update

log_info "Installing Node.js..."
sudo apt install -y nodejs

log_info "Installing Yarn..."
sudo npm install -g yarn

install_pip_package "frappe-bench"

bash_content = "PATH=\$PATH:~/.local/bin/"
write_to_file "$bash_content" "~/.bashrc"
source ~/.bashrc


prompt_frappe_bench_location
 
cd "$frappe_bench_location"

bench init --frappe-branch version-14 frappe-bench

cd frappe-bench

echo "now you have bench at least, if you want erpnext on it. install it by yourself. i'm done with this shit."