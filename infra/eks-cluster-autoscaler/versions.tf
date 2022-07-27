terraform {
  required_version = ">= 1.0"

  required_providers {
    utils = {
      source  = "cloudposse/utils"
      version = ">= 0.17.0"
    }
  }
}

provider "aws" {
  version = ">= 4.19.0"
  region  = var.aws_region
  profile = var.aws_profile
}

provider "kubernetes" {
  config_path = format("kubeconfig.yml")
  version = ">= 2.11.0"
}
provider "helm" {
  version = ">= 2.5.1"
  kubernetes {
    config_path = format("kubeconfig.yml")
  }
}
