#!/bin/bash

# Written by K.Toda, 2021/3/19

# Objective
## To install Python 3.7.10, 3.8.8 in Ubuntu 18

# Reference
## https://qiita.com/123h4wk/items/d5aece92d1ee47ce603c

############ To execute ############
# after executing install_pyenv.sh
# chmod 755 install_python3.sh
# ./install_python3.sh
####################################


# Require password
printf "password: "
read -s password

# Install Python 3.7.10 and 3.8.8
## install packages that is necessary for building python
echo "$password" | sudo -S apt-get update
sudo -S apt-get -y install --no-install-recommends make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
## install Python
pyenv install 3.7.10
pyenv install 3.8.8