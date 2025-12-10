terraform {
  required_version = ">= 1.9.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "TerraStack"
      Environment = "dev"
      ManagedBy   = "Terraform"
      Owner       = "Benjamin Burton"
    }
  }
}

# VPC Module
module "vpc" {
  source = "../../modules/vpc"

  project_name = var.project_name
  vpc_cidr     = var.vpc_cidr

  availability_zones = [
    "${var.aws_region}a",
    "${var.aws_region}b"
  ]

  public_subnet_cidrs = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]

  private_subnet_cidrs = [
    "10.0.11.0/24",
    "10.0.12.0/24"
  ]

  tags = {
    Environment = "dev"
  }
}

# EKS Module
module "eks" {
  source = "../../modules/eks"

  cluster_name    = "${var.project_name}-cluster"
  cluster_version = var.eks_cluster_version
  environment     = "dev"

  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids

  # Node group configuration
  desired_size   = var.eks_desired_size
  max_size       = var.eks_max_size
  min_size       = var.eks_min_size
  instance_types = var.eks_instance_types

  tags = {
    Environment = "dev"
  }

  depends_on = [module.vpc]
}
