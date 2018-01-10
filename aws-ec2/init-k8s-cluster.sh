#!/usr/bin/env bash

# This script init a k8s master node using kubeadm
# This script should be using in sudo mode
# author: gexinlu

# Init the kubernetes cluster by kubeadm
kubeadm init --kubernetes-version=v1.9.0 --pod-network-cidr=10.244.0.0/16 >> ./install-kuber-on-ec2.log

# copy the kubernetes admin config file
echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> ~/.bash_profile

# install flannel addon
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.9.1/Documentation/kube-flannel.yml

echo "Network addon flannel install successfully! \n" >> ./install-kuber-on-ec2.log
