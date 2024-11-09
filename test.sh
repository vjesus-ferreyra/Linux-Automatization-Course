#!/bin/bash

# Functions
function install_ssh_service () {
    sudo apt install openssh-server vim -y
    sudo vim /etc/ssh/sshd_config  # Adjust indentation for clarity
    sudo systemctl enable ssh
    sudo systemctl status ssh
}

function install_docker_engine () {
    # Add Docker's official GPG key:
    sudo apt install ca-certificates curl  # Use apt for consistency
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update  # Use apt for consistency
    sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}

# Update package list
sudo apt update

# Check for updates
if [ -n "$(apt list --upgradable 2>/dev/null)" ]; then
    # Update if necessary
    sudo apt upgrade -y
    if [ $? -eq 0 ]; then
        echo "Actualización exitosa."
    else
        echo "Ocurrió un error durante la actualización. Abortamos."
        exit 1
    fi
else
    echo "No hay paquetes por actualizar."
fi

install_docker_engine
install_ssh_service
