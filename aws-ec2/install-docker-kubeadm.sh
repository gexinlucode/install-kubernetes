#!/usr/bin/env bash

# This script install docker and kubernetes moudles
# This script should be run in sudo user
# author: gexinlu

export PATH=/usr/local/apache-maven/bin:/usr/local/apache-tomcat/bin:/usr/local/liquibase:/usr/local/apache-jmeter:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin 

# Install docker
yum install -y yum-utils device-mapper-persistent-data lvm2

yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

yum list docker-ce.x86_64  --showduplicates |sort -r

yum makecache fast

yum install -y --setopt=obsoletes=0 \
  docker-ce-17.03.2.ce-1.el7.centos \
  docker-ce-selinux-17.03.2.ce-1.el7.centos

systemctl start docker

systemctl enable docker

# Enable ipforward
iptables -P FORWARD ACCEPT

# check the cgroupdriver to systemd cause kubeadm using the systemd
cat <<EOF > /etc/docker/daemon.json
{
     "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF

systemctl daemon-reload

systemctl restart docker

echo -e "Docker Installation successfully! \n" >> ./install-kuber-on-ec2.log

# Config kubernetes repo
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

yum makecache fast

# Install kubectl kubeadm...
yum install -y kubelet kubeadm kubectl

systemctl enable kubelet

systemctl start kubelet

echo -e "Kubelet starts successfully! \n" >> ./install-kuber-on-ec2.log
