#!/bin/bash
set -e
 
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
 
LOG_FILE="$SCRIPT_DIR/install_script.log"
CONFIG_FILE="$SCRIPT_DIR/config.ini"

 
if [ -t 1 ]; then
    COLOR_RESET=$(tput sgr0)
    COLOR_INFO=$(tput setaf 2) 
    COLOR_ERROR=$(tput setaf 1) 
else
    COLOR_RESET=''
    COLOR_INFO=''
    COLOR_ERROR=''
fi
 
log_info() {
    local message=$1
    echo -e "${COLOR_INFO}[INFO] $message${COLOR_RESET}"
    echo "[INFO] $message" | sudo tee -a "$LOG_FILE" > /dev/null
}

log_error() {
    local message=$1
    echo -e "${COLOR_ERROR}[ERROR] $message${COLOR_RESET}"
    echo "[ERROR] $message" | sudo tee -a "$LOG_FILE" > /dev/null
}
 
 # install or upgrade brew package
install_or_upgrade_brew_package() {
    local package_name=$1

    if command -v "$package_name" > /dev/null; then
        log_info "$package_name is already installed."
    else 
        # if brew list -1 | grep -q "^$package_name\$"; then
        #     log_info "Upgrading $package_name..."
        #     arch -arm64 brew upgrade "$package_name"
        # else
        log_info "Installing $package_name..."
        arch -arm64 brew install "$package_name"
        # fi

        if [ $? -eq 0 ]; then
            log_info "$package_name installed/upgraded successfully."
        else
            log_error "Error: $package_name installation/upgrade failed."
            exit 1
        fi
    fi
}

# start a Homebrew service
start_brew_service() {
    local service_name=$1

    log_info "Starting $service_name service..."
    brew services start "$service_name"
}

# install a Python package using pip3
install_python_package() {
    local package_name=$1

    if command -v "$package_name" > /dev/null; then
        log_info "$package_name is already installed."
    else
        log_info "Installing $package_name..."
        pip3 install "$package_name"

        if [ $? -eq 0 ]; then
            log_info "$package_name installed successfully."
        else
            log_error "Error: $package_name installation failed."
            exit 1
        fi
    fi
}

# install an npm package globally
install_npm_package() {
    local package_name=$1

    if command -v npm > /dev/null; then
        log_info "Installing $package_name using npm..."

        if command -v $package_name > /dev/null; then
            echo "we need sudo permissions to install $package_name"
            sudo npm install -g "$package_name"
        else
            log_info "$package_name is already installed"
        fi

        if [ $? -eq 0 ]; then
            log_info "$package_name installed successfully."
        else
            log_error "Error: $package_name installation failed."
            exit 1
        fi
    else
        log_error "Error: npm is not installed. Please install npm and try again."
        exit 1
    fi
}

# update a configuration file
update_config_file() {
    local file_path=$1
    local content=$2
 
    if grep -q "$content" "$file_path"; then
        log_info "Configuration already exists in $file_path."
    else 
        echo -e "$content" >> "$file_path"
        log_info "Configuration added to $file_path."
    fi
}

# prompt user for Frappe Bench location
prompt_frappe_bench_location() {
    read -p "Enter the path where you want to initialize Frappe Bench: " frappe_bench_location
 
    if [ ! -d "$frappe_bench_location" ]; then
        log_error "Error: The specified path does not exist or is not a directory."
        exit 1
    fi

    log_info "Frappe Bench will be initialized at: $frappe_bench_location"
}

# load configurations from a file
load_configurations() {
    if [ -f "$CONFIG_FILE" ]; then
        source "$CONFIG_FILE"
    else
        log_error "Error: Configuration file $CONFIG_FILE not found."
        exit 1
    fi
}
 
load_configurations

 
install_or_upgrade_brew_package "$GIT_PACKAGE"
install_or_upgrade_brew_package "$PYTHON3_PACKAGE"
 
install_python_package "setuptools"
install_python_package "virtualenv"

 
install_or_upgrade_brew_package "$MARIADB_PACKAGE"
start_brew_service "mariadb"
 
install_or_upgrade_brew_package "mariadb"

 
mysql_install_db

 
mysql.server start

 
mysql_secure_installation

 
install_or_upgrade_brew_package "$MYSQL_CLIENT_PACKAGE"

 
update_config_file "/opt/homebrew/etc/my.cnf" "$MARIADB_CONFIG_CONTENT" 

 
install_or_upgrade_brew_package "$REDIS_PACKAGE"
install_or_upgrade_brew_package "$NODE_PACKAGE"

 
install_npm_package "$YARN_PACKAGE"

 
install_or_upgrade_brew_package "$WKHTMLTOPDF_PACKAGE"

 
prompt_frappe_bench_location

 
install_python_package "frappe-bench"
 
cd "$frappe_bench_location"
bench init frappe-bench 

cd frappe-bench

bench new-site site1.local
 
bench get-app https://github.com/frappe/erpnext

bench --site site1.local add-to-hosts

bench start

log_info "..... happy coding! ..." 
