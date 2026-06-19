variable "name_prefix" {
  description = "Prefix used for all resource names"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where EC2 resources will be created"
  type        = string
}

variable "subnet_ids" {
  description = "List of private subnet IDs to deploy instances into"
  type        = list(string)
}

variable "alb_security_group" {
  description = "Security group ID of the ALB (instances accept traffic from ALB only)"
  type        = string
}

variable "target_group_arn" {
  description = "ARN of the ALB target group to register instances into"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for EC2 instances (region-specific, use data source in production)"
  type        = string
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

variable "ssh_key_name" {
  description = "EC2 key pair name for SSH access (set to null to disable SSH)"
  type        = string
  default     = null
}

variable "ssh_allowed_cidrs" {
  description = "CIDR blocks allowed SSH access. Empty list = SSH SG rule disabled (recommended for prod)"
  type        = list(string)
  default     = []
}

variable "user_data_file_path" {
  description = "Path to the user data script file"
  type        = string
}

variable "tags" {
  description = "Additional tags to apply to all resources in this module"
  type        = map(string)
  default     = {}
}
