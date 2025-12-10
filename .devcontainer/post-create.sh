#!/bin/bash

set -e

echo "🚀 Setting up TerraStack DevContainer..."

# Update system
apt-get update
apt-get install -y \
    curl \
    wget \
    git \
    vim \
    tmux \
    zsh \
    unzip \
    jq \
    ca-certificates \
    gnupg \
    lsb-release \
    python3 \
    python3-pip \
    software-properties-common

# Install Terraform
echo "📦 Installing Terraform..."
TERRAFORM_VERSION="1.9.8"
wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
mv terraform /usr/local/bin/
rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip
terraform version

# Install AWS CLI v2
echo "📦 Installing AWS CLI v2..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
rm -rf aws awscliv2.zip
aws --version

# Install kubectl
echo "📦 Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/
kubectl version --client

# Install Helm
echo "📦 Installing Helm..."
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
helm version

# Install tflint
echo "📦 Installing tflint..."
curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
tflint --version

# Install terraform-docs
echo "📦 Installing terraform-docs..."
TERRAFORM_DOCS_VERSION="v0.17.0"
curl -Lo ./terraform-docs.tar.gz https://github.com/terraform-docs/terraform-docs/releases/download/${TERRAFORM_DOCS_VERSION}/terraform-docs-${TERRAFORM_DOCS_VERSION}-linux-amd64.tar.gz
tar -xzf terraform-docs.tar.gz
chmod +x terraform-docs
mv terraform-docs /usr/local/bin/
rm terraform-docs.tar.gz
terraform-docs --version

# Install tfsec
echo "📦 Installing tfsec..."
curl -s https://raw.githubusercontent.com/aquasecurity/tfsec/master/scripts/install_linux.sh | bash
tfsec --version

# Install Oh My Zsh
echo "📦 Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
chsh -s $(which zsh)

# Configure shell aliases
cat >> ~/.zshrc << 'ZSHRC'

# Terraform aliases
alias tf='terraform'
alias tfi='terraform init'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfd='terraform destroy'
alias tfv='terraform validate'
alias tff='terraform fmt -recursive'
alias tfo='terraform output'

# AWS aliases
alias awswhoami='aws sts get-caller-identity'

# kubectl aliases
alias k='kubectl'
alias kg='kubectl get'
alias kd='kubectl describe'
alias kl='kubectl logs'

# Directory aliases
alias ll='ls -lah'

export PATH=$PATH:/usr/local/bin
export EDITOR=vim
ZSHRC

# Create AWS config directory
mkdir -p ~/.aws

# Create Makefile
cat > /workspaces/terrastack/Makefile << 'MAKEFILE'
.PHONY: help init plan apply destroy validate format lint

help:
	@echo "TerraStack Makefile Commands:"
	@echo "  make init      - Initialize Terraform"
	@echo "  make plan      - Run terraform plan"
	@echo "  make apply     - Run terraform apply"
	@echo "  make destroy   - Run terraform destroy"
	@echo "  make validate  - Validate Terraform files"
	@echo "  make format    - Format Terraform files"
	@echo "  make lint      - Run tflint"

init:
	cd environments/dev && terraform init

plan:
	cd environments/dev && terraform plan

apply:
	cd environments/dev && terraform apply

destroy:
	cd environments/dev && terraform destroy

validate:
	terraform fmt -check -recursive
	cd environments/dev && terraform validate

format:
	terraform fmt -recursive

lint:
	tflint --recursive
MAKEFILE

echo ""
echo "✨ TerraStack DevContainer setup complete!"
echo ""
echo "🎯 Quick Start:"
echo "  make help    - See all commands"
echo "  tf version   - Check Terraform"
echo "  aws --version - Check AWS CLI"
echo ""
