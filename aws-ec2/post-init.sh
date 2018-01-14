#!/usr/bin/env bash

# This script configure the k8s cluster after join some nodes to the cluster

# taint the master node
# This command should be executed after the network plugin installed.
kubectl taint nodes --all node-role.kubernetes.io/master-
