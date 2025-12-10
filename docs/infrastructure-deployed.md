# Infrastructure Deployed - TerraStack

## Last Updated
December 10, 2025

## Environment
Development (dev)

## Deployment Summary
- **Region:** us-east-1
- **Availability Zones:** us-east-1a, us-east-1b
- **Deployed By:** Benjamin Burton
- **Terraform Version:** 1.9.8

---

## VPC Infrastructure

### VPC
- **VPC ID:** vpc-0023ead7527050de0
- **CIDR Block:** 10.0.0.0/16
- **DNS Hostnames:** Enabled
- **DNS Support:** Enabled

### Public Subnets
- subnet-07020dace2b9dde32 (10.0.1.0/24) - us-east-1a
- subnet-04daf6db58120d126 (10.0.2.0/24) - us-east-1b

### Private Subnets
- subnet-065ee3cfd57d5125f (10.0.11.0/24) - us-east-1a
- subnet-095e3eee3b51788b9 (10.0.12.0/24) - us-east-1b

### Internet Gateway
- **IGW ID:** igw-093b251682ea51be9

### NAT Gateways
- **NAT Gateway 1:** nat-0fd25aca30b3f7051
  - **Elastic IP:** 18.214.72.55
  - **Availability Zone:** us-east-1a
- **NAT Gateway 2:** nat-0c32d94ecc3487220
  - **Elastic IP:** 3.226.99.125
  - **Availability Zone:** us-east-1b

---

## EKS Cluster

### Cluster Details
- **Cluster Name:** terrastack-cluster
- **Kubernetes Version:** 1.31
- **Platform Version:** eks.X
- **Status:** ACTIVE
- **Endpoint:** https://1D02652FFF8A411E85600BB4840136B8.gr7.us-east-1.eks.amazonaws.com
- **Certificate Authority:** [Managed by AWS]

### Cluster Security
- **Cluster Security Group:** sg-007c7dde78526a22a
- **Node Security Group:** sg-09933bc69d7271195
- **Endpoint Access:**
  - Public: Enabled
  - Private: Enabled

### OIDC Provider
- **OIDC Provider ARN:** arn:aws:iam::XXXXXXXXXXXX:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/XXXXXXXX
- **OIDC Issuer URL:** https://oidc.eks.us-east-1.amazonaws.com/id/1D02652FFF8A411E85600BB4840136B8
- **Purpose:** IAM Roles for Service Accounts (IRSA)

### IAM Roles
- **Cluster Role:** terrastack-cluster-cluster-role
- **Node Role:** terrastack-cluster-node-role

### Node Group
- **Name:** terrastack-cluster-node-group
- **Instance Type:** t3.medium (2 vCPU, 4 GiB RAM)
- **AMI Type:** AL2_x86_64
- **Disk Size:** 20 GiB (gp3)
- **Capacity Type:** ON_DEMAND
- **Scaling Configuration:**
  - Desired: 2
  - Minimum: 1
  - Maximum: 3
- **Status:** ACTIVE

### EKS Add-ons
1. **CoreDNS**
   - Version: [Check with: `kubectl get deployment coredns -n kube-system`]
   - Purpose: DNS resolution for services
   
2. **kube-proxy**
   - Version: [Matches cluster version]
   - Purpose: Network proxy on each node
   
3. **VPC CNI**
   - Version: [Latest]
   - Purpose: Pod networking with VPC IPs

### CloudWatch Logging
Enabled log types:
- API Server
- Audit
- Authenticator
- Controller Manager
- Scheduler

---

## Access Instructions

### Configure kubectl
```bash
# Update kubeconfig
aws eks update-kubeconfig --region us-east-1 --name terrastack-cluster

# Verify connection
kubectl cluster-info

# Check nodes
kubectl get nodes

# Check system pods
kubectl get pods -A
```

### Verify Cluster Health
```bash
# Node status
kubectl get nodes -o wide

# System pods status
kubectl get pods -n kube-system

# Cluster info
kubectl cluster-info dump
```

---

## Cost Breakdown (Monthly)

### Compute
- **EKS Control Plane:** $73.00 (fixed)
- **EC2 Instances (2x t3.medium):** ~$60.00
- **EBS Volumes (2x 20GB):** ~$3.20

### Networking
- **NAT Gateways (2x):** ~$65.00
- **Data Transfer:** ~$5.00

### Total Estimated Cost
**~$206/month** (VPC + EKS only, before RDS)

---

## Next Steps

- [ ] Deploy test application
- [ ] Add RDS PostgreSQL module
- [ ] Implement GitHub Actions CI/CD
- [ ] Add monitoring (Prometheus/Grafana)
- [ ] Configure horizontal pod autoscaling

---

## Troubleshooting

### Cannot connect with kubectl
```bash
# Re-configure kubectl
aws eks update-kubeconfig --region us-east-1 --name terrastack-cluster

# Verify AWS credentials
aws sts get-caller-identity

# Check cluster status
aws eks describe-cluster --name terrastack-cluster --region us-east-1
```

### Nodes not appearing
```bash
# Check node group status
aws eks describe-nodegroup \
  --cluster-name terrastack-cluster \
  --nodegroup-name terrastack-cluster-node-group \
  --region us-east-1

# Check EC2 instances
aws ec2 describe-instances \
  --filters "Name=tag:eks:cluster-name,Values=terrastack-cluster" \
  --region us-east-1
```

---

## Notes

- All infrastructure managed via Terraform
- State stored in S3: s3://terrastack-tfstate-1765377369/dev/terraform.tfstate
- State locking via DynamoDB: terrastack-locks
- Infrastructure as Code repository: https://github.com/BenjaminBurton/terrastack

