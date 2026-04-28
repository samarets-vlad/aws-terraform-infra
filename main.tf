module "vpc" {
  source = "./modules/vpc"

  name_prefix              = local.name_prefix
  vpc_cidr                 = var.vpc_cidr
  public_subnet_cidrs      = var.public_subnet_cidrs
  private_app_subnet_cidrs = var.private_app_subnet_cidrs
  private_db_subnet_cidrs  = var.private_db_subnet_cidrs
  availability_zones       = var.availability_zones
}

module "alb" {
  source = "./modules/alb"

  name_prefix           = local.name_prefix
  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.vpc.public_subnet_ids
  app_port              = var.app_port
  allowed_ingress_cidrs = var.allowed_ingress_cidrs
}

module "ec2_app" {
  source = "./modules/ec2_app"

  name_prefix         = local.name_prefix
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.private_app_subnet_ids
  app_port            = var.app_port
  instance_type       = var.instance_type
  ami_id              = var.ami_id
  alb_security_group  = module.alb.alb_security_group_id
  target_group_arn    = module.alb.target_group_arn
  ssh_key_name        = var.ssh_key_name
  user_data_file_path = "${path.root}/files/user_data.sh"
}

module "rds" {
  source = "./modules/rds"

  name_prefix           = local.name_prefix
  vpc_id                = module.vpc.vpc_id
  subnet_ids            = module.vpc.private_db_subnet_ids
  app_security_group_id = module.ec2_app.app_security_group_id
  db_name               = var.db_name
  db_username           = var.db_username
  db_password           = var.db_password
  db_instance_class     = var.db_instance_class
}

resource "aws_s3_bucket" "assets" {
  bucket = "${local.name_prefix}-assets-${data.aws_caller_identity.current.account_id}"
}

data "aws_caller_identity" "current" {}
