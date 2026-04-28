# Architecture

This stack deploys a two-tier AWS network with a clear separation between public and private layers.

## Network layout

- **Public subnets** — ALB and NAT Gateway (2 AZs)
- **Private app subnets** — EC2 application instances (no direct internet access)
- **Private DB subnets** — RDS PostgreSQL (accessible only from app layer)

## Traffic flow

```
Internet → ALB (public subnet) → EC2 (private subnet) → RDS (private subnet)
                                       ↓
                                 S3 (assets bucket)
```

## Security model

- ALB accepts HTTP on port 80 from configurable CIDRs
- EC2 instances accept traffic only from the ALB security group
- RDS accepts traffic only from the EC2 app security group
- SSH access is open in this demo config — restrict in production
- All data in transit encrypted via `encrypt = true` in S3 backend
