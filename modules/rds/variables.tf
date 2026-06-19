variable "name_prefix" {
  description = "Prefix used for all resource names"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where DB resources will be created"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the DB subnet group (private DB subnets)"
  type        = list(string)
}

variable "app_security_group_id" {
  description = "Security group ID of the application tier (allowed to connect to DB)"
  type        = string
}

variable "db_name" {
  description = "Name of the PostgreSQL database"
  type        = string
}

variable "db_username" {
  description = "Master username for the RDS instance"
  type        = string
}

variable "db_password" {
  description = "Master password for the RDS instance (use sensitive tfvar or Secrets Manager)"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "RDS instance class (e.g. db.t3.micro, db.t3.medium)"
  type        = string
}

variable "backup_retention_period" {
  description = "Number of days to retain automated backups (0 disables backups)"
  type        = number
  default     = 7
}

variable "deletion_protection" {
  description = "Enable deletion protection — set to false only for dev/test environments"
  type        = bool
  default     = true
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot on DB deletion — set to true only for dev/test environments"
  type        = bool
  default     = false
}
