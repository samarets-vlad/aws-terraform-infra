# Complete example

Use the root module with values copied from `terraform.tfvars.example`.

```bash
cp ../../terraform.tfvars.example ../../terraform.tfvars
terraform -chdir=../.. init
terraform -chdir=../.. plan
```
