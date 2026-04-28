variable "name_prefix" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "app_port" {
  type = number
}

variable "allowed_ingress_cidrs" {
  type = list(string)
}
