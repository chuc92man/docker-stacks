#!/bin/bash

if [ "$(whoami)" != "jovyan" ]; then
    echo "This script must be run as the 'jovyan' user!"
    exit 1;
fi

cd

source activate cubeenv

conda install -y vim awscli

cat >> .bashrc <<EOF
source activate cubeenv
export GREP_OPTS='--color=auto'
alias grep='grep \${GREP_OPTS}'
export LS_OPTS='--color=auto'
alias ls='ls \${LS_OPTS}'
alias vi='vim'
EOF
