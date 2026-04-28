# Design Decisions

## Module structure
Each AWS layer (VPC, ALB, EC2, RDS) is a separate module for reusability and readability.
This makes it easy to version modules independently or replace a single layer.

## Two-AZ deployment
Public and private subnets are spread across two availability zones for basic high availability.

## NAT Gateway
A single NAT Gateway is used for outbound internet access from private app instances.
For production, consider one NAT Gateway per AZ to avoid cross-AZ traffic costs.

## Remote state
S3 backend with native locking (`use_lockfile = true`, requires Terraform >= 1.11).
DynamoDB locking is deprecated as of Terraform 1.11 and not used here.

## RDS in private subnets
The database is never publicly accessible — only reachable from the app security group.

## Sensitive outputs
`db_endpoint` is marked as `sensitive = true` to avoid accidental exposure in CI logs.
