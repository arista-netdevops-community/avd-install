#!/bin/bash
#
# Purpose: AVD Installation script
#          Available using curl -fsSL https://get.avd.sh | sh
# Author: @titom73
# Date: 2020-09-14
# Update: 2020-09-15
# Version: 1.0.1
# License: Apache 2.0
# --------------------------------------

# Local Installation Path
_INSTALLATION_PATH="arista-ansible"
_ROOT_INSTALLATION_DIR="${PWD}/${_INSTALLATION_PATH}"

# List of Arista Repositories
_REPO_AVD="https://github.com/aristanetworks/ansible-avd.git"
_REPO_CVP="https://github.com/aristanetworks/ansible-cvp.git"
_REPO_EXAMPLES="https://github.com/arista-netdevops-community/ansible-avd-cloudvision-demo"

# Path for local repositories
_LOCAL_AVD="${_ROOT_INSTALLATION_DIR}/ansible-avd"
_LOCAL_CVP="${_ROOT_INSTALLATION_DIR}/ansible-cvp"
_LOCAL_EXAMPLES="${_ROOT_INSTALLATION_DIR}/ansible-avd-cloudvision-demo"

# Folder where Dockerfile and Makefile are located
_DEV_FOLDER="${_LOCAL_AVD}/development/"

# Print post-installation instructions
info_installation_done() {
    echo ""
    echo "Installtion done."
    echo ""
    echo "You can access setup at ${_ROOT_INSTALLATION_DIR} to review all the files"
    echo "You can login to AVD environment with:"
    echo "--------------------------------------"
    echo "   cd ${_ROOT_INSTALLATION_DIR}"
    echo "   make start"
    echo "--------------------------------------"
    echo ""
    echo "For complete documentaiton, visit: https://www.avd.sh/docs/installation/setup-environement/"
    echo ""
}

##############################################
# Main content for script
##############################################

echo "Arista Ansible installation is starting"

# Test if git is installed
if hash git 2>/dev/null; then
    echo "  * git has been found here: " $(which git)
else
    echo "  ! git is not installed, installation aborted"
    exit 1
fi

if [ ! -d "${_ROOT_INSTALLATION_DIR}" ]; then
    echo "  * creating local installation folder: ${_ROOT_INSTALLATION_DIR}"
    mkdir -p ${_ROOT_INSTALLATION_DIR}
    echo "  * cloning ansible-avd collections to ${_LOCAL_AVD}"
    git clone ${_REPO_AVD} ${_LOCAL_AVD} > /dev/null 2>&1
    echo "  * cloning ansible-cvp collections to ${_LOCAL_CVP}"
    git clone ${_REPO_CVP} ${_LOCAL_CVP} > /dev/null 2>&1
    echo "  * cloning netdevops-examples collections to ${_LOCAL_EXAMPLES}"
    git clone ${_REPO_EXAMPLES} ${_LOCAL_EXAMPLES} > /dev/null 2>&1
    if [ -d ${_DEV_FOLDER} ]; then
        echo "  * deploying development content to ${_ROOT_INSTALLATION_DIR}"
        cp ${_DEV_FOLDER}/Makefile ${_ROOT_INSTALLATION_DIR}
    else
        echo "  ! error: development folder is missing: ${_DEV_FOLDER}"
        exit 1
    fi
    info_installation_done
else
    echo "  ! local installation folder already exists - ${_ROOT_INSTALLATION_DIR}"
    exit 1
fi
