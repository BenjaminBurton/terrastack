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
