# TerraStack

Infrastructure as Code for AWS using Terraform with GitOps principles.

## Architecture

**Current:**
- VPC with public/private subnets across 2 AZs
- NAT Gateways for private subnet internet access
- Internet Gateway for public access

**Planned:**
- EKS Kubernetes cluster
- RDS PostgreSQL database
- S3 buckets for application artifacts

## Quick Start

### Prerequisites
- AWS account with credentials configured
- DevContainer support (VS Code or CLI)

### Setup

```bash
# Clone repository
git clone https://github.com/BenjaminBurton/terrastack.git
cd terrastack

# Open in DevContainer
devcontainer up --workspace-folder .
devcontainer exec --workspace-folder . zsh

# Initialize Terraform
cd environments/dev
terraform init

# Plan changes
terraform plan

# Apply infrastructure
terraform apply
