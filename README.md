# BP-Terraform
Sample project using Terraform to provision and configure resources for Jump Start's Blue Prism application.

## Instructions

*This assumes you have Terraform installed and an AWS account.*

1. Clone this repo

2. Modify **terraform.tfvars** to use your AWS login and private key

3. Modify variables in **bp-test.tf**, if necessary

4. From the terminal, navigate to **bp-test** and run `terraform init` then `terraform plan -var-file='..\terraform.tfvars'`

5. Run `terraform apply -var-file='..\terraform.tfvars'` to deploy your infrastructure to AWS and `terraform plan -var-file='..\terraform.tfvars'` to remove it
