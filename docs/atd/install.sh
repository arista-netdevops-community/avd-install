#!/bin/bash
#
# Purpose: AVD Installation script
#          Available using curl -fsSL https://get.avd.sh/atd/install.sh | sh
#          WORK IN PROGRESS
# Author: @titom73
# Date: 2020-09-17
# Update: 2020-09-17
# Version: 0.0.1
# License: Apache 2.0
# --------------------------------------

# Update PATH to match ATD Jumphost setting
export PATH=$PATH:$HOME/.local/bin/
export PYTHONPATH=$PYTHONPATH:$HOME/.local/lib/python3.8/site-packages/

# Local Installation Path
_INSTALLATION_PATH="arista-ansible"
_ROOT_INSTALLATION_DIR="${PWD}/${_INSTALLATION_PATH}"

# List of Arista Repositories
_REPO_AVD="https://github.com/aristanetworks/ansible-avd.git"
_REPO_CVP="https://github.com/aristanetworks/ansible-cvp.git"
_REPO_EXAMPLES="https://github.com/titom73/avd-atd-provisionner"

# Path for local repositories
_LOCAL_AVD="${_ROOT_INSTALLATION_DIR}/ansible-avd"
_LOCAL_CVP="${_ROOT_INSTALLATION_DIR}/ansible-cvp"
_LOCAL_EXAMPLES="${_ROOT_INSTALLATION_DIR}/avd-atd-provisionner"

# BIN Paths
_PIP_BIN=$(which pip3)
# For SSH jumphost
#_PIP_OPTIONS="--disable-pip-version-check --quiet --upgrade --use-feature=2020-resolver"
_PIP_OPTIONS="--disable-pip-version-check --quiet --upgrade"
_CURL_BIN=$(which curl)
_CURL_OPTIONS="-fsSL"

# Link to resources to install
_AVD_REQUIREMENTS_URL="https://raw.githubusercontent.com/aristanetworks/ansible-avd/devel/development/requirements.txt"
_AVD_DEV_REQUIREMENTS_URL="https://raw.githubusercontent.com/aristanetworks/ansible-avd/devel/development/requirements-dev.txt"

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
    echo "   source avd_venv/bin/activate"
    echo "   cd ${_ROOT_INSTALLATION_DIR}"
    echo "   < start playing with AVD content >"
    echo "--------------------------------------"
    echo ""
    echo "For complete documentaiton, visit: https://www.avd.sh/docs/installation/setup-environement/"
    echo ""
}

# Function to bootstrap AVD Python requirements from AVD repository
# WARNING: Python version is not enforced
avd_python_provision() {
    _PYTHON_VERSION=$(python -c 'import sys; version=sys.version_info[:3]; print("{0}.{1}.{2}".format(*version))')
    echo "  * Python found in version ${_PYTHON_VERSION}"
    echo "    - Standard requirements installation from ${_AVD_REQUIREMENTS_URL}"
    ${_PIP_BIN} install ${_PIP_OPTIONS} -r /tmp/requirements.txt
    echo "    - Development requirements installation from ${_AVD_DEV_REQUIREMENTS_URL}"
    ${_PIP_BIN} install ${_PIP_OPTIONS} -r /tmp/dev-requirements.txt
}

avd_get_req_files() {
    ${_CURL_BIN} ${_CURL_OPTIONS} ${_AVD_REQUIREMENTS_URL} -o /tmp/requirements.txt
    ${_CURL_BIN} ${_CURL_OPTIONS} ${_AVD_DEV_REQUIREMENTS_URL} -o /tmp/dev-requirements.txt
}

avd_python_provision_venv() {
    _AVD_VENV="avd_venv"
    _PYTHON_PATH=$(which python3)
    ${_PIP_BIN} install ${_PIP_OPTIONS} --user virtualenv
    virtualenv --clear -q -p ${_PYTHON_PATH} ${PWD}/${_AVD_VENV}
    echo "    * Standard requirements installation from ${_AVD_REQUIREMENTS_URL}"
    ${_AVD_VENV}/bin/pip install ${_PIP_OPTIONS} -r /tmp/requirements.txt
    echo "    * Development requirements installation from ${_AVD_DEV_REQUIREMENTS_URL}"
    ${_AVD_VENV}/bin/pip install ${_PIP_OPTIONS} -r /tmp/dev-requirements.txt
}

# user_shell_provisioning() {
#     ${_CURL_BIN} ${_CURL_OPTIONS} https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
#     echo 'plugins=(ansible common-aliases safe-paste git jsontools history git-extras)' >> $HOME/.zshrc
#     echo 'eval `ssh-agent -s`' >> $HOME/.zshrc
#     echo 'export TERM=xterm' >>  $HOME/.zshrc
# }


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

# echo "  * Start python requirements installation"
# echo "    * Get requirements files from AVD repository"
# avd_get_req_files
#avd_python_provision
# echo "    * Provision virtual-env"
# avd_python_provision_venv

echo "  * Deployed AVD environment"
if [ ! -d "${_ROOT_INSTALLATION_DIR}" ]; then
    echo "  * creating local installation folder: ${_ROOT_INSTALLATION_DIR}"
    mkdir -p ${_ROOT_INSTALLATION_DIR}
    echo "  * cloning ansible-avd collections to ${_LOCAL_AVD}"
    git clone ${_REPO_AVD} ${_LOCAL_AVD} > /dev/null 2>&1
    echo "  * cloning ansible-cvp collections to ${_LOCAL_CVP}"
    git clone ${_REPO_CVP} ${_LOCAL_CVP} > /dev/null 2>&1
    echo "  * cloning netdevops-examples collections to ${_LOCAL_EXAMPLES}"
    git clone ${_REPO_EXAMPLES} ${_LOCAL_EXAMPLES} > /dev/null 2>&1

    # Placeholder for specific ATD repos where we can position some topologies

    info_installation_done
else
    echo "  ! local installation folder already exists - ${_ROOT_INSTALLATION_DIR}"
    exit 1
fi
