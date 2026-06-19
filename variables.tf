variable "aws_region" {
  description = "AWS region to deploy resources into"
  type        = string
  default     = "eu-central-1"
}

variable "project_name" {
  description = "Project name — used as resource name prefix and in common tags"
  type        = string
  default     = "portfolio-app"
}

variable "environment" {
  description = "Environment name (dev | stage | prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "stage", "prod"], var.environment)
    error_message = "environment must be one of: dev, stage, prod."
  }
}

variable "owner" {
  description = "Owner tag applied to all resources (name or team)"
  type        = string
  default     = "Vlad Samarets"
}

variable "vpc_cidr" {
  description = "VPC CIDR block (e.g. 10.0.0.0/16)"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets — one per AZ"
  type        = list(string)
}

variable "private_app_subnet_cidrs" {
  description = "CIDR blocks for private application subnets — one per AZ"
  type        = list(string)
}

variable "private_db_subnet_cidrs" {
  description = "CIDR blocks for private database subnets — one per AZ"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones to deploy into (e.g. [\"eu-central-1a\", \"eu-central-1b\"])"
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type for application servers"
  type        = string
  default     = "t3.micro"
}

variable "app_port" {
  description = "Port the application listens on (ALB forwards traffic to this port)"
  type        = number
  default     = 8080
}

variable "allowed_ingress_cidrs" {
  description = "CIDR blocks allowed to reach the ALB on port 80/443"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "ssh_allowed_cidrs" {
  description = "CIDR blocks allowed SSH access to EC2 instances. Empty list disables the SSH security group rule"
  type        = list(string)
  default     = []
}

variable "db_name" {
  description = "PostgreSQL database name"
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "PostgreSQL master username"
  type        = string
  default     = "appuser"
}

variable "db_password" {
  description = "PostgreSQL master password — must be provided via tfvars or environment variable TF_VAR_db_password. Never hardcode."
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "rds_deletion_protection" {
  description = "Enable RDS deletion protection. Set to false for dev environments."
  type        = bool
  default     = true
}

variable "rds_skip_final_snapshot" {
  description = "Skip final snapshot when deleting RDS. Set to true for dev environments."
  type        = bool
  default     = false
}

variable "rds_backup_retention_period" {
  description = "Number of days to retain RDS automated backups (0 disables backups)"
  type        = number
  default     = 7
}

variable "ssh_key_name" {
  description = "Optional EC2 key pair name for SSH access. Set to null to disable SSH."
  type        = string
  default     = null
}

variable "ami_id" {
  description = "AMI ID for EC2 instances — must be region-specific. Use AWS SSM Parameter Store to look up latest AMI dynamically."
  type        = string
}
