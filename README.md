# Infrastructure — Terraform

AWS infrastructure for the platform. Follows the architecture:

```
Internet → Route53 → ALB (HTTPS, Public Subnets)
                          ↓
               ECS Fargate Cluster (Private App Subnets)
               ├── Node.js Backend   (/health, /metrics)
               ├── Prometheus        (scrapes /metrics, EFS storage)
               └── Grafana           (dashboards, behind ALB)
                          ↓
               RDS PostgreSQL Multi-AZ (Private DB Subnets)
```

## Directory Structure

```
infra/
├── main.tf                   # Root module — wires everything together
├── variables.tf              # All input variables with descriptions
├── outputs.tf                # Key outputs (URLs, IDs)
├── Makefile                  # Convenience commands
├── prometheus.yml            # Prometheus scrape config
├── environments/
│   ├── prod/terraform.tfvars
│   └── staging/terraform.tfvars
└── modules/
    ├── vpc/                  # VPC, subnets (public/app/db), IGW, NAT, VPC endpoints
    ├── security-groups/      # SGs for ALB, backend, Prometheus, Grafana, RDS, EFS
    ├── iam/                  # ECS execution role, task role, autoscaling role
    ├── cloudwatch/           # Log groups (7-day retention, no custom metrics)
    ├── efs/                  # EFS for Prometheus persistent storage
    ├── alb/                  # ALB, target groups, HTTPS listener, host-based routing
    ├── rds/                  # RDS PostgreSQL, parameter group, Secrets Manager
    └── ecs/                  # Cluster, task defs, services, autoscaling
```

## Prerequisites

- Terraform >= 1.6
- AWS CLI configured with appropriate permissions
- ACM certificate provisioned for your domain
- ECR repository for your backend image

## First-time Setup

### 1. Create remote state bucket (one-time)

```bash
aws s3 mb s3://your-project-terraform-state --region af-south-1
aws s3api put-bucket-versioning \
  --bucket your-project-terraform-state \
  --versioning-configuration Status=Enabled

aws dynamodb create-table \
  --table-name terraform-state-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST
```

Then uncomment the `backend "s3"` block in `main.tf`.

### 2. Set sensitive variables via environment

```bash
export TF_VAR_rds_username="myapp_user"
export TF_VAR_rds_password="$(openssl rand -base64 32)"
export TF_VAR_grafana_admin_password="$(openssl rand -base64 16)"
```

### 3. Update tfvars

Edit `environments/prod/terraform.tfvars`:
- Set your `domain_name`
- Set your `certificate_arn`
- Set your `backend_image` ECR URI

### 4. Deploy

```bash
# Production
make ENV=prod init
make ENV=prod plan
make ENV=prod apply

# Staging
make ENV=staging init
make ENV=staging plan
make ENV=staging apply
```

## Useful Commands

```bash
# Check outputs after apply
make ENV=prod output

# ECS Exec into a running container (for debugging)
aws ecs execute-command \
  --cluster myapp-prod \
  --task <task-id> \
  --container backend \
  --interactive \
  --command "/bin/sh"

# Force new deployment (e.g. after pushing a new image)
aws ecs update-service \
  --cluster myapp-prod \
  --service myapp-prod-backend \
  --force-new-deployment
```

## Cost Notes

- **CloudWatch**: Logs only, 7-day retention. No custom metrics or dashboards.
- **Prometheus/Grafana**: Self-hosted on ECS. Metrics cost = ECS compute + EFS storage only.
- **RDS**: `db.t4g.small` with gp3 storage. Multi-AZ in prod only.
- **NAT Gateway**: Single NAT GW (not per-AZ) to save ~$32/month early on. Move to per-AZ when HA is critical.
- **VPC Endpoints**: S3 gateway (free) + Interface endpoints for ECR/Secrets Manager to reduce NAT traffic costs.

## Scaling

Backend autoscales on CPU > 70% and Memory > 80%. Min/max counts are configurable per environment in `terraform.tfvars`.

## Adding RDS Proxy Later

When connection exhaustion becomes an issue (typically at 10+ ECS tasks), add:

```hcl
module "rds_proxy" {
  source = "./modules/rds-proxy"
  ...
}
```

The module is not included now to keep early costs down.
