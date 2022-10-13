#!/bin/bash
#
# Purpose: AVD Installation script
#          Available using curl -fsSL https://get.avd.sh/atd/install.sh | sh
# Author: @titom73
# Date: 2020-09-17
# Update: 2021-01-13
# Version: 1.2
# License: Apache 2.0
# --------------------------------------

# Update PATH to match ATD Jumphost setting
export PATH=$PATH:$HOME/.local/bin/
export PYTHONPATH=$PYTHONPATH:$HOME/.local/lib/python3.8/site-packages/

# Bin path
_CURL=$(which curl)
_GIT=$(which git)

# Local Installation Path
_INSTALLATION_PATH="labfiles/arista-ansible"
_ROOT_INSTALLATION_DIR="${PWD}/${_INSTALLATION_PATH}"

# List of Arista Repositories
_REPO_AVD="https://github.com/aristanetworks/ansible-avd.git"
_REPO_CVP="https://github.com/aristanetworks/ansible-cvp.git"
_REPO_EXAMPLES="https://github.com/arista-netdevops-community/atd-avd.git"

# Path for local repositories
_LOCAL_AVD="${_ROOT_INSTALLATION_DIR}/ansible-avd"
_LOCAL_CVP="${_ROOT_INSTALLATION_DIR}/ansible-cvp"
_LOCAL_EXAMPLES="${_ROOT_INSTALLATION_DIR}/atd-avd"

# Get latest stable version from github
# Automatic detection from Github
# _AVD_VERSION=$(curl -L -I -s -o /dev/null -w %{url_effective} https://github.com/aristanetworks/ansible-avd/releases/latest | cut -d "/" -f 8)
# _CVP_VERSION=$(curl -L -I -s -o /dev/null -w %{url_effective} https://github.com/aristanetworks/ansible-cvp/releases/latest | cut -d "/" -f 8)
# Static configuration
_AVD_VERSION=v3.8.0-dev1
_CVP_VERSION=v3.4.0

# Print post-installation instructions
info_installation_done() {
    echo ""
    echo "Installation done."
    echo ""
    echo "You can access setup at ${_ROOT_INSTALLATION_DIR} to review all the files: collections and playbooks"
    echo "You can login to AVD environment with:"
    echo "--------------------------------------"
    echo "   cd ${_LOCAL_EXAMPLES}"
    echo "   < start playing with AVD content >"
    echo "--------------------------------------"
    echo ""
    echo "For complete documentation, visit: https://github.com/arista-netdevops-community/atd-avd"
    echo ""
}


##############################################
# Main content for script
##############################################

echo "Arista Ansible AVD installation is starting"

# Test if git is installed
if hash git 2>/dev/null; then
    echo "  * git has been found here: " $(which git)
else
    echo "  ! git is not installed, installation aborted"
    exit 1
fi

echo "  * Deployed AVD environment"
if [ ! -d "${_ROOT_INSTALLATION_DIR}" ]; then
    echo "  * creating local installation folder: ${_ROOT_INSTALLATION_DIR}"
    mkdir -p ${_ROOT_INSTALLATION_DIR}
    echo "  * cloning ansible-avd collections (${_AVD_VERSION}) to ${_LOCAL_AVD}"
    ${_GIT} clone --depth 1 --branch ${_AVD_VERSION} ${_REPO_AVD} ${_LOCAL_AVD} > /dev/null 2>&1
    echo "  * cloning ansible-cvp collections (${_CVP_VERSION}) to ${_LOCAL_CVP}"
    ${_GIT} clone --depth 1 --branch ${_CVP_VERSION} ${_REPO_CVP} ${_LOCAL_CVP} > /dev/null 2>&1
    echo "  * cloning atd-avd demo to ${_LOCAL_EXAMPLES}"
    ${_GIT} clone ${_REPO_EXAMPLES} ${_LOCAL_EXAMPLES} > /dev/null 2>&1

    # Placeholder for specific ATD repos where we can position some topologies

    if [ -f "${_LOCAL_EXAMPLES}/requirements.txt" ]; then
        echo "Found custom requirements, installing ..."
        pip install --upgrade -r ${_LOCAL_EXAMPLES}/requirements.txt
    else
        echo "ATD demo has no custom requirements, skipped"
    fi

    info_installation_done
else
    echo "  ! local installation folder already exists - ${_ROOT_INSTALLATION_DIR}"
    exit 1
fi
