#!/bin/bash -xe
eks_cluster_name=eks-cluster
region=us-west-2
account_number=$(aws sts get-caller-identity --query Account --output text)
policy_arn="arn:aws:iam::${account_number}:policy/eks-cluster-ca-asg-policy"
git clone https://github.com/Thripura/eks-demo.git
cd eks-demo/eks-managed/cluster-autoscaler
current_dir=$(pwd)
eksctl utils associate-iam-oidc-provider   --cluster ${eks_cluster_name} --approve --region ${region}
aws iam create-policy  --policy-name ${eks_cluster_name}-ca-asg-policy  --policy-document file://cluster-autoscaler.json
eksctl create iamserviceaccount --name cluster-autoscaler --namespace kube-system --region ${region} --cluster ${eks_cluster_name} --attach-policy-arn ${policy_arn} --approve  --override-existing-serviceaccounts
curl -o ${current_dir}/cluster-autoscaler-autodiscover.yaml https://avinash-test-final-config.s3.us-west-2.amazonaws.com/cluster-autoscaler-autodiscover.yaml
sed -i "s|@CLUSTER_NAME@|${eks_cluster_name}|g" cluster-autoscaler-autodiscover.yaml
kubectl apply -f cluster-autoscaler-autodiscover.yaml