#!/bin/bash
# install poetry
curl -sSL https://install.python-poetry.org | python3 -
# install containerlab
curl -sL https://containerlab.dev/setup | sudo -E bash -s "all"
# install tools
sudo apt install -y iputils-ping net-tools openssh-client python3-pip
# install gitlab-runner
curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash
sudo apt-get install gitlab-runner
