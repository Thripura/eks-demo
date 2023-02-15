#!/bin/bash
path=$(pwd)
rm -rf eks-config.yml aws-auth.yml
cluster_name="eks-demo"
profile_name="joyoushire"
region=us-west-2
aws eks update-kubeconfig --region ${region} --name ${cluster_name} --profile ${profile_name} --kubeconfig=${path}/eks-config.yml
kubectl  --kubeconfig=${path}/eks-config.yml  get -n kube-system configmap/aws-auth -o  yaml >> ${path}/aws-auth.yml
