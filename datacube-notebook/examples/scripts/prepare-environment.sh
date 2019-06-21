#!/bin/bash

if [ "$(whoami)" != "jovyan" ]; then
    echo "This script must be run as the 'jovyan' user!"
    exit 1;
fi

source activate cubeenv

cd

conda install -y vim awscli
cat >> .bashrc <<EOF
alias vi=vim
source activate cubeenv
EOF
