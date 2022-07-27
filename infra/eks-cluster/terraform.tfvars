# Region and Profile Information
aws_region = "us-west-2"
aws_profile = "joyoushire"


# VPC and Networking Information
vpc_id =  "vpc-0fe832c14a22d4432"
control_plane_subnet_ids =  ["subnet-0d92969cf926e72ab", "subnet-04351a5cf193448da"] #Public Subnetids
subnet_ids =  ["subnet-05500b56d3e5e7fc4", "subnet-0391fbaf051af0207"] #Private Subnet IDS


# EKS Cluster Information
cluster_name = "eks-demo"
cluster_version = "1.21"
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
