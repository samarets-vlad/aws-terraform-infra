# AWS Terraform Infrastructure

[![Terraform CI](https://github.com/samarets-vlad/aws-terraform-infra/actions/workflows/terraform.yml/badge.svg)](https://github.com/samarets-vlad/aws-terraform-infra/actions/workflows/terraform.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

> 🇺🇦 [Українська версія](README.uk.md)

This repository contains production-ready AWS infrastructure described as code using **Terraform**.

Instead of clicking around in the AWS Console to create servers, databases, and load balancers — everything is described in files. You run one command and the infrastructure appears. You run another command and it disappears. Everything is reproducible and version-controlled.

---

## What Does This Infrastructure Create?

When you run `terraform apply`, the following resources are created in your AWS account:

```
                        Internet
                           │
                    ┌──────▼──────┐
                    │     ALB     │  ← Load Balancer (distributes traffic)
                    │  (port 80)  │
                    └──────┬──────┘
                           │
              ┌────────────┴────────────┐
              │                         │
       ┌──────▼──────┐           ┌──────▼──────┐
       │   EC2 App   │           │   EC2 App   │  ← Application servers
       │  (AZ-1)     │           │  (AZ-2)     │    (2 availability zones)
       └──────┬──────┘           └──────┬──────┘
              │                         │
              └────────────┬────────────┘
                           │
                    ┌──────▼──────┐
                    │  RDS (PG)   │  ← PostgreSQL database (private, encrypted)
                    └─────────────┘

       All resources live inside a VPC (Virtual Private Cloud)
       Public subnet  → ALB only
       Private subnet → EC2 app servers
       DB subnet      → RDS (no internet access)
```

### Resources created:

| Resource | What it is | Notes |
|----------|-----------|-------|
| **VPC** | Isolated network in AWS | Your own private section of the cloud |
| **Public subnets** | Subnets with internet access | ALB lives here |
| **Private subnets** | Subnets without internet access | App servers live here |
| **DB subnets** | Subnets isolated from everything | Database lives here |
| **ALB** | Application Load Balancer | Receives user traffic, distributes to app servers |
| **EC2** | Virtual servers | Run your application |
| **RDS (PostgreSQL)** | Managed database | Encrypted, with automatic backups |
| **S3 bucket** | File storage | For static assets or application files |
| **Security Groups** | Firewall rules | Controls who can talk to what |

---

## Repository Structure

```
aws-terraform-infra/
├── main.tf                    # Main entry point — connects all modules
├── variables.tf               # All input parameters with descriptions
├── outputs.tf                 # What Terraform prints after apply (URLs, IPs)
├── locals.tf                  # Internal computed values (e.g. common tags)
├── versions.tf                # Terraform and provider version requirements
├── backend.tf                 # Where to store the Terraform state file (S3)
├── providers.tf               # AWS provider configuration
├── terraform.tfvars.example   # Example values file — copy to terraform.tfvars
├── .tflint.hcl                # Linter configuration
├── .gitignore                 # Files NOT committed to Git (secrets, state, etc.)
│
├── modules/                   # Reusable infrastructure components
│   ├── vpc/                   # VPC, subnets, routing, internet gateway
│   ├── alb/                   # Application Load Balancer + target group
│   ├── ec2_app/               # EC2 instances + security group
│   └── rds/                   # RDS PostgreSQL + subnet group + security group
│
├── .github/
│   └── workflows/
│       └── terraform.yml      # CI/CD pipeline (runs on every push/PR)
│
├── SECURITY.md                # Security policy and disclosure guidelines
└── LICENSE                    # MIT License
```

**What is a "module"?**  
A module is a reusable building block. Instead of writing all 500 lines of Terraform in one file, we split it into logical groups (VPC, load balancer, server, database). Each module has its own folder, its own inputs, and its own outputs. This makes the code easier to understand, test, and reuse.

---

## Requirements

Before you can use this repository, you need:

| Tool | Version | Why |
|------|---------|-----|
| [Terraform](https://developer.hashicorp.com/terraform/install) | >= 1.11.0 | The main tool that creates infrastructure |
| [AWS CLI](https://aws.amazon.com/cli/) | >= 2.x | To authenticate with AWS |
| AWS Account | — | Where the infrastructure will be created |
| AWS IAM User/Role | With permissions | Terraform uses this to create resources |

---

## How to Deploy (Local)

> ⚠️ **Important:** `terraform apply` creates real AWS resources and **costs real money**. Always run `terraform plan` first to review what will be created.

### Step 1 — Clone the repository

```bash
git clone https://github.com/samarets-vlad/aws-terraform-infra.git
cd aws-terraform-infra
```

### Step 2 — Configure AWS credentials

```bash
aws configure
# Enter: AWS Access Key ID, Secret Access Key, Region (e.g. eu-central-1)
```

### Step 3 — Create your variables file

```bash
cp terraform.tfvars.example terraform.tfvars
# Open terraform.tfvars and fill in your values
```

The minimum required values:

```hcl
project_name = "my-app"
environment  = "dev"
aws_region   = "eu-central-1"

vpc_cidr                  = "10.0.0.0/16"
availability_zones        = ["eu-central-1a", "eu-central-1b"]
public_subnet_cidrs       = ["10.0.1.0/24", "10.0.2.0/24"]
private_app_subnet_cidrs  = ["10.0.11.0/24", "10.0.12.0/24"]
private_db_subnet_cidrs   = ["10.0.21.0/24", "10.0.22.0/24"]

ami_id       = "ami-0a1b2c3d4e5f6"   # Region-specific — find in AWS Console
db_password  = "CHANGE_ME_use_strong_password"
```

> 🔒 **Never commit `terraform.tfvars` to Git.** It is already in `.gitignore`. It contains your database password and region-specific values.

### Step 4 — Initialize Terraform

```bash
terraform init
```

This downloads the AWS provider plugin (~40 MB). Only needed once, or after changing `versions.tf`.

### Step 5 — Review the plan

```bash
terraform plan
```

Terraform will show you **exactly** what it will create, modify, or destroy — without actually doing anything. Read this carefully before proceeding.

### Step 6 — Apply

```bash
terraform plan -out=tfplan   # Save the plan
terraform apply tfplan        # Apply exactly that plan
```

### Step 7 — Destroy (when done)

```bash
terraform destroy
```

This removes **all** resources. Useful for dev/test to avoid ongoing costs.

> ⚠️ **For production:** `rds_deletion_protection = true` prevents accidental database deletion. You must set it to `false` before running `destroy`.

---

## Input Variables

All variables are defined in `variables.tf`. Copy `terraform.tfvars.example` and fill in your values.

### Required (no default — must be provided)

| Variable | Type | Description |
|----------|------|-------------|
| `vpc_cidr` | string | VPC network range, e.g. `10.0.0.0/16` |
| `public_subnet_cidrs` | list | CIDR blocks for public subnets, one per AZ |
| `private_app_subnet_cidrs` | list | CIDR blocks for app subnets, one per AZ |
| `private_db_subnet_cidrs` | list | CIDR blocks for DB subnets, one per AZ |
| `availability_zones` | list | AZs to deploy into, e.g. `["eu-central-1a", "eu-central-1b"]` |
| `ami_id` | string | EC2 AMI ID (region-specific — find in AWS Console) |
| `db_password` | string | PostgreSQL master password — **never hardcode** |

### Optional (have sensible defaults)

| Variable | Default | Description |
|----------|---------|-------------|
| `aws_region` | `eu-central-1` | AWS region to deploy into |
| `project_name` | `portfolio-app` | Prefix for all resource names |
| `environment` | `dev` | Must be `dev`, `stage`, or `prod` |
| `instance_type` | `t3.micro` | EC2 instance type |
| `app_port` | `8080` | Port your application listens on |
| `db_instance_class` | `db.t3.micro` | RDS instance type |
| `db_name` | `appdb` | PostgreSQL database name |
| `db_username` | `appuser` | PostgreSQL master username |
| `rds_deletion_protection` | `true` | Prevents accidental DB deletion |
| `rds_skip_final_snapshot` | `false` | If false, a snapshot is taken before deletion |
| `rds_backup_retention_period` | `7` | Days to keep automated backups |
| `ssh_allowed_cidrs` | `[]` | CIDRs allowed SSH. Empty = SSH disabled |
| `ssh_key_name` | `null` | EC2 key pair name. Null = no key pair |

---

## CI/CD Pipeline

Every push and every Pull Request automatically triggers the pipeline defined in `.github/workflows/terraform.yml`.

```
Push or Pull Request to main
          │
          ▼
    ┌─────────────┐
    │  1. Validate │  terraform fmt, init (no backend), validate, tflint
    └──────┬──────┘
           │ passes
           ▼
    ┌─────────────┐
    │  2. Security │  tfsec — scans for AWS misconfigurations
    └─────────────┘

  ✅ If both pass → PR can be merged
  ❌ If any fails → PR is blocked
```

### What each step does:

| Step | Tool | What it checks |
|------|------|----------------|
| Format check | `terraform fmt -check` | Code is properly formatted (spacing, alignment) |
| Init | `terraform init -backend=false` | Dependencies download correctly |
| Validate | `terraform validate` | Syntax is valid, no undefined variables |
| Lint | `tflint` | Best practices: pinned versions, documented variables, etc. |
| Security | `tfsec` | No open security groups, encryption enabled, IMDSv2 enforced, etc. |

> 💡 **No AWS credentials are used in CI.** All checks are static analysis only — they read the code without connecting to AWS. This means **zero cost** from running CI.

> ⚠️ **`terraform plan` and `terraform apply` are intentionally not in CI.** Run them manually from your local machine when you actually want to deploy.

---

## Security Hardening

This project implements AWS security best practices out of the box:

| What | Why it matters |
|------|----------------|
| **IMDSv2 enforced on EC2** | Prevents SSRF attacks from stealing instance credentials |
| **EBS volumes encrypted** | Data at rest is encrypted with AES-256 |
| **RDS storage encrypted** | Database data is encrypted at rest |
| **RDS deletion protection** | Prevents accidental database destruction |
| **RDS final snapshot** | Backup is taken automatically before any deletion |
| **S3 public access blocked** | All 4 public access block flags set to `true` |
| **S3 versioning enabled** | You can recover deleted or overwritten files |
| **S3 server-side encryption** | Files stored in S3 are encrypted |
| **SSH disabled by default** | `ssh_allowed_cidrs = []` — no SSH rule unless explicitly set |
| **DB in private subnet** | RDS has no internet access — only reachable from app servers |
| **Secrets not in code** | `db_password` is marked `sensitive`, never stored in Git |
| **Provider version pinned** | `aws ~> 5.98` — no surprise breaking changes |
| **Terraform >= 1.11.0 required** | Minimum version enforced in all modules |

---

## State File

Terraform needs to store a "state file" — a record of what infrastructure currently exists. This file must be stored remotely (not on your laptop) so a team can collaborate and so it is not lost.

This project is configured to use **AWS S3 + DynamoDB** for remote state storage (see `backend.tf`).

Before running `terraform init` for the first time, you must **manually create**:
- An S3 bucket (with versioning and encryption enabled)
- A DynamoDB table (for state locking — prevents two people from running `apply` at the same time)

Then update `backend.tf` with your bucket name and table name.

> This is a one-time setup step. After that, all state is managed automatically.

---

## Environment Differences

Use the `environment` variable to control behaviour per environment:

| Setting | `dev` | `stage` | `prod` |
|---------|-------|---------|--------|
| `rds_deletion_protection` | `false` | `true` | `true` |
| `rds_skip_final_snapshot` | `true` | `false` | `false` |
| `rds_backup_retention_period` | `1` | `7` | `14` |
| `instance_type` | `t3.micro` | `t3.small` | `t3.medium` |
| `ssh_allowed_cidrs` | your IP | your IP | `[]` (disabled) |

---

## License

[MIT](LICENSE) — free to use, modify, and distribute.

---

## Author

**Vladyslav Samarets** — DevOps Engineer  
[GitHub](https://github.com/samarets-vlad)
