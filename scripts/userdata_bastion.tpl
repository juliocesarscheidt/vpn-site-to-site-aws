#!/bin/bash

exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1
  echo "starting user-data $0"

  sleep 5

  yum update -y
  yum -y install net-tools bind-utils

  # copy the SSH keys
  mkdir -p ~/.ssh/
  echo "${SSH_KEY_BASE64_PUBLIC}" | base64 -d -w0 | tee -a ~/.ssh/id_rsa.pub
  echo "${SSH_KEY_BASE64_PRIVATE}" | base64 -d -w0 | tee -a ~/.ssh/id_rsa
  chmod 400 ~/.ssh/id_rsa.pub
  chmod 400 ~/.ssh/id_rsa
