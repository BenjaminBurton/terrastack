# TerraStack

**Production-grade Infrastructure as Code for AWS using Terraform with GitOps principles.**

[![Terraform](https://img.shields.io/badge/Terraform-1.9.8-623CE4?logo=terraform)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-EKS%20%7C%20RDS-FF9900?logo=amazon-aws)](https://aws.amazon.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## Overview

TerraStack demonstrates enterprise-level infrastructure automation with:
- **Infrastructure as Code** using Terraform modules
- **GitOps workflow** with GitHub Actions
- **Kubernetes** on AWS EKS
- **Database** with RDS PostgreSQL
- **Security** best practices (IRSA, private subnets, encryption)

Built by a self-taught DevOps engineer as a portfolio project.

---


**Current Stack:**
- VPC with public/private subnets (2 AZs)
- NAT Gateways for private subnet internet
- EKS Kubernetes cluster (v1.31)
- Managed node group (2x t3.medium)
- RDS PostgreSQL (db.t3.micro)
- GitHub Actions CI/CD (GitOps)
- Secrets Manager for database credentials
- Full security groups and IAM roles

---

## Quick Start

### Prerequisites
- AWS account with credentials
- GitHub account (for GitOps workflows)
- DevContainer support (VS Code or CLI)

### Local Development

```bash
# Clone repository
git clone https://github.com/BenjaminBurton/terrastack.git
cd terrastack

# Open in DevContainer
devcontainer up --workspace-folder .
devcontainer exec --workspace-folder . zsh

# Configure AWS
aws configure

# Initialize Terraform
cd environments/dev
terraform init

# Plan changes
terraform plan

# Apply infrastructure
terraform apply

# Configure kubectl
aws eks update-kubeconfig --region us-east-1 --name terrastack-cluster

# Verify
kubectl get nodes
kubectl get pods -A
