#!/bin/bash

exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1
  echo "starting user-data $0"

  sleep 5

  yum update -y
  yum -y install openswan ipsec-tools net-tools bind-utils

  # copy the SSH keys
  mkdir -p ~/.ssh/
  echo "${SSH_KEY_BASE64_PUBLIC}" | base64 -d -w0 | tee -a ~/.ssh/id_rsa.pub
  echo "${SSH_KEY_BASE64_PRIVATE}" | base64 -d -w0 | tee -a ~/.ssh/id_rsa
  chmod 400 ~/.ssh/id_rsa.pub
  chmod 400 ~/.ssh/id_rsa

  modprobe br_netfilter 2> /dev/null
  sysctl --system

  echo "net.bridge.bridge-nf-call-iptables=1" >> /etc/sysctl.conf
  echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
  echo "net.ipv4.conf.default.accept_source_route=0" >> /etc/sysctl.conf
  echo "net.ipv4.conf.all.accept_redirects=0" >> /etc/sysctl.conf
  echo "net.ipv4.conf.all.send_redirects=0" >> /etc/sysctl.conf
  echo "net.ipv4.conf.all.rp_filter=0" >> /etc/sysctl.conf
  echo "net.ipv4.conf.default.rp_filter=0" >> /etc/sysctl.conf
  echo "net.ipv4.conf.eth0.rp_filter=0" >> /etc/sysctl.conf
  echo "net.ipv4.conf.ip_vti0.rp_filter=0" >> /etc/sysctl.conf
  sysctl -p

  service network restart

  echo "LEFT_EXTERNAL_IP:: ${LEFT_EXTERNAL_IP}"
  echo "LEFT_SUBNET_CIDR:: ${LEFT_SUBNET_CIDR}"
  echo "RIGHT_EXTERNAL_IP:: ${RIGHT_EXTERNAL_IP}"
  echo "RIGHT_SUBNET_CIDR:: ${RIGHT_SUBNET_CIDR}"

  mkdir -p /etc/ipsec.d

  cat > /etc/ipsec.d/aws-vpn.conf <<EOF
conn Tunnel1
      authby=secret
      auto=start
      left=%defaultroute
      leftid=${LEFT_EXTERNAL_IP}
      leftsubnet=${LEFT_SUBNET_CIDR}
      right=${RIGHT_EXTERNAL_IP}
      rightsubnet=${RIGHT_SUBNET_CIDR}
      type=tunnel
      ikelifetime=8h
      keylife=1h
      phase2alg=aes128-sha1;modp1024
      ike=aes128-sha1;modp1024
      keyingtries=%forever
      keyexchange=ike
      dpddelay=10
      dpdtimeout=30
      dpdaction=restart_by_peer
EOF

  cat > /etc/ipsec.d/aws-vpn.secrets <<EOF
${LEFT_EXTERNAL_IP} %any: PSK "${TUNNEL_PRESHARED_KEY}" 
EOF

  chkconfig ipsec on

  systemctl start ipsec
  ipsec verify
  systemctl status ipsec -l
