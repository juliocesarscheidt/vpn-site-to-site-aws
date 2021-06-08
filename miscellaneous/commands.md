# Commands

## Generate SSH key

```bash
KEY_NAME="ssh_key"
ssh-keygen -t rsa -b 2048 -f "${KEY_NAME}"

cat "${KEY_NAME}"
cat "${KEY_NAME}.pub"

chmod 400 "${KEY_NAME}"
chmod 400 "${KEY_NAME}.pub"

# after apply...
ssh -i "${KEY_NAME}" ec2-user@"$(terraform output instance_openswan_public_ip)"
ssh -i "${KEY_NAME}" ec2-user@"$(terraform output instance_bastion_public_ip)"
```

## Terraform commands

```bash
terraform fmt -write=true -recursive

terraform init
terraform validate
terraform plan -detailed-exitcode -input=false
terraform apply -auto-approve

terraform refresh
terraform show
terraform output

terraform destroy -auto-approve
```
