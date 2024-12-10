provider "aws" {
  region = "ap-south-1"
}

locals {
  cluster_name = "eks-auto-mode-cluster"
  vpc_cidr     = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24"] # Subnets for two AZs
  tags = {
    "Name"        = "eks-auto-mode"
    "Environment" = "test"
  }
}

# VPC Module with a single public subnet
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0" # Update to the version you need

  name             = "eks-auto-vpc"
  cidr             = local.vpc_cidr
  azs              = ["ap-south-1a", "ap-south-1b"] # Two Availability Zones
  public_subnets   = local.public_subnet_cidrs

  enable_nat_gateway = false
  tags               = local.tags
  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }
}

# EKS Auto Mode
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.31.1" # Update to the version you need
  cluster_name                   = local.cluster_name
  cluster_version                = "1.29"
  cluster_endpoint_public_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets

  enable_cluster_creator_admin_permissions = true

  cluster_compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  tags = local.tags
}
