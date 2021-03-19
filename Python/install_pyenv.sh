#!/bin/bash

# Written by K.Toda, 2021/3/19

# Objective
## To install pyenv in Ubuntu 18

# Reference
## https://qiita.com/123h4wk/items/d5aece92d1ee47ce603c

############ To execute ############
# chmod 755 install_pyenv.sh
# ./install_pyenv.sh
####################################


# Require password
printf "password: "
read -s password

# Update and Upgrade
echo "$password" | sudo -S apt update && sudo -S apt -y upgrade

# Install pyenv
## clone pyenv from GitHub
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
## write path
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
## setting to execute pyenv when starting shell
echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.bashrc
## reload shell
exec "$SHELL"