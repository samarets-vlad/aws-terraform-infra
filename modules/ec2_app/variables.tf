variable "name_prefix" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "app_port" {
  type = number
}

variable "instance_type" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "alb_security_group" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "ssh_key_name" {
  type    = string
  default = null
}

variable "user_data_file_path" {
  type = string
}
