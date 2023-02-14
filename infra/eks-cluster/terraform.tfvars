# Region and Profile Information
aws_region = "us-west-2"
aws_profile = "joyoushire"


# VPC and Networking Information
vpc_id =  "vpc-095bb5a3ca4982af5"
control_plane_subnet_ids =  ["subnet-063a53ccabaf8d598", "subnet-0775430255cb9edc1"] #Public Subnetids
subnet_ids =  ["subnet-02fd5dc0197abc926", "subnet-022e154c2a923396f"] #Private Subnet IDS


# EKS Cluster Information
cluster_name = "eks-demo"
cluster_version = "1.23"
cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
cluster_endpoint_private_access = "true"
cluster_endpoint_public_access = "true"


eks_managed_node_groups = {
   green = {
      min_size     = 1
      max_size     = 10
      desired_size = 1

      instance_types = ["t2.large"]
      capacity_type  = "ON_DEMAND"
    }
 }
