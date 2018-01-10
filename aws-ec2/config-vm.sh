#!/usr/bin/env bash

# This script install kubernetes (master + node) on AWS EC2.
# This is a script for preparing the VM environment.
# This script should be run in sudo modle
# author: gexinlu
export PATH=/usr/local/apache-maven/bin:/usr/local/apache-tomcat/bin:/usr/local/liquibase:/usr/local/apache-jmeter:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

#prepare log file
touch ./install-kuber-on-ec2.log

# update yum 
yum update -y

# disable firewalld
systemctl stop firewalld
systemctl disable firewalld
echo -e "Disable firewalld successfully! \n" >> ./install-kuber-on-ec2.log

# configure /etc/sysctl.d/k8s.conf
cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
vm.swappiness=0
EOF

# enable the /etc/sysctl.d/k8s.conf 
sysctl -p /etc/sysctl.d/k8s.conf
echo -e "Config the /etc/sysctl.d/k8s.conf file and enable the file successfully! \n" >> ./install-kuber-on-ec2.log

# disable the SELINUX
setenforce 0

# modify /etc/selinux/config file
sed 's/SELINUX\=enforcing/SELINUX\=disabled/' /etc/selinux/config > /etc/selinux/config2 && rm -rf /etc/selinux/config && mv /etc/selinux/config2 /etc/selinux/config
echo -e "Disable SELINUX successfully! \n" >> ./install-kuber-on-ec2.log

# disable swap 
swapoff -a
echo -e "disable swap file successfully! \n" >> ./install-kuber-on-ec2.log

# Config the sshd to keepalive modle
echo "ClientAliveInterval 10" >> /etc/ssh/sshd_config
echo "TCPKeepAlive yes" >> /etc/ssh/sshd_config
systemctl restart sshd.service
echo -e "Config the sshd modle to keepalive modle successfully! \n" >> ./install-kuber-on-ec2.log

# sync and reboot VM
sync
sync

# clean the swap in /etc/fstab file
echo "********************************"
echo "***********NOTICE***************"
echo "********************************"
echo "Please check the /etc/fstab file and *delete* the line contains swap then *reboot* the VM!"
