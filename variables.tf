variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "project_name" {
  description = "Project name used as resource name prefix"
  type        = string
  default     = "portfolio-app"
}

variable "environment" {
  description = "Environment name (dev, stage, prod)"
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "Owner tag for all resources"
  type        = string
  default     = "Vlad Samarets"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets (one per AZ)"
  type        = list(string)
}

variable "private_app_subnet_cidrs" {
  description = "CIDR blocks for private app subnets (one per AZ)"
  type        = list(string)
}

variable "private_db_subnet_cidrs" {
  description = "CIDR blocks for private DB subnets (one per AZ)"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones to deploy into"
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "app_port" {
  description = "Port the application listens on"
  type        = number
  default     = 8080
}

variable "allowed_ingress_cidrs" {
  description = "CIDR blocks allowed to reach the ALB on port 80"
  type        = list(string)
  default     = ["0.0.0.0/0"]
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
  description = "PostgreSQL master password (sensitive)"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "ssh_key_name" {
  description = "Optional EC2 key pair name for SSH access"
  type        = string
  default     = null
}

variable "ami_id" {
  description = "AMI ID for EC2 instances (region-specific)"
  type        = string
}
