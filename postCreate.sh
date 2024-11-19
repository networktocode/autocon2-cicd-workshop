#!/bin/bash
# install poetry
curl -sSL https://install.python-poetry.org | python3 -
# install containerlab
curl -sL https://containerlab.dev/setup | sudo -E bash -s "all"
# install tools
sudo apt install -y iputils-ping net-tools openssh-client python3-pip
# install gitlab-runner for shell
curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash
sudo apt-get install gitlab-runner
# Download GitLab Runner Docker image
docker pull gitlab/gitlab-runner:latest
docker pull batfish/batfish:latest
docker pull python:3.10
docker pull allprojeff66/ac2-cicd-workshop:latest
# wget -O cEOS64-lab-4.32.0F.tar "https://www.dropbox.com/scl/fo/33dz41vxj3ok00yc5g8wh/AOXKjycdCRpqEhVSEWFOsYU?rlkey=ga5m7qbf4krqq1hb4od065fe1&e=1&st=o7hqecmc&dl=0"
