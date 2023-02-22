#!/bin/bash -xe
# Modify below values accordingly
eks_cluster_name=eks-cluster-fargate
region=us-west-2
vpc_id="vpc-02227ca7af5c4f3e4"
private_subnet_1="subnet-017ee97dbf82e3781"
private_subnet_2="subnet-0034176b567174f70"
# Custom script for setting up Fargate profiles and AWS Loadbalancer controller
account_number=$(aws sts get-caller-identity --query Account --output text)
aws eks create-fargate-profile \
    --fargate-profile-name coredns \
    --cluster-name ${eks_cluster_name} --region ${region} \
    --pod-execution-role-arn arn:aws:iam::${account_number}:role/AmazonEKSFargatePodExecutionRole \
    --selectors namespace=kube-system \
    --subnets ${private_subnet_1} ${private_subnet_2}
kubectl patch deployment coredns \
    -n kube-system \
    --type json \
    -p='[{"op": "remove", "path": "/spec/template/metadata/annotations/eks.amazonaws.com~1compute-type"}]'
kubectl rollout restart -n kube-system deployment coredns
eksctl utils associate-iam-oidc-provider --cluster ${eks_cluster_name} --approve --region ${region}
curl -o iam_policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.4.4/docs/install/iam_policy.json
aws iam create-policy \
   --policy-name AWSLoadBalancerControllerIAMPolicy \
   --policy-document file://iam_policy.json
eksctl create iamserviceaccount \
  --cluster=${eks_cluster_name} \
  --namespace=kube-system --region=${region} \
  --name=aws-load-balancer-controller \
  --attach-policy-arn=arn:aws:iam::${account_number}:policy/AWSLoadBalancerControllerIAMPolicy \
  --override-existing-serviceaccounts \
  --approve
kubectl get serviceaccount aws-load-balancer-controller --namespace kube-system
/usr/local/bin/helm repo add eks https://aws.github.io/eks-charts
kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller//crds?ref=master"
/usr/local/bin/helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
    --set clusterName=${eks_cluster_name} \
    --set serviceAccount.create=false \
    --set region=${region} \
    --set vpcId=${vpc_id} \
    --set serviceAccount.name=aws-load-balancer-controller \
    -n kube-system
sleep 200
eksctl create fargateprofile --cluster ${eks_cluster_name} --region ${region} --name game-2048 --namespace game-2048
sleep 200
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.4.4/docs/examples/2048/2048_full.yaml
kubectl get ingress/ingress-2048 -n game-2048