terraform {
  backend "s3" {
    bucket       = "CHANGE_ME-tf-state-bucket"
    key          = "aws-terraform-infra/dev/terraform.tfstate"
    region       = "eu-central-1"
    use_lockfile = true
    encrypt      = true
  }
}
