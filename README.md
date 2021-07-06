# terraform-base-infra
Repository to set up a new infraestructure from code

# terraform init
When you create a new configuration — or check out an existing configuration from version control — you need to initialize the directory with terraform init.
It downloads everything from the provider of your config (AWS) into .terraform dir.

Note: If you set or change modules or backend configuration, rerun this command to reinitialize.

# credentials
Run on you terminal
```
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
export AWS_DEFAULT_REGION="us-east-1"
```

# terraform plan
See any changes that are required for your infraestructure.

# terraform fmt
Format your configuration (like linter).

# terraform validate
Validate your config

# terraform apply
Creates/Updates/Deletes all your infraestructure changes based on your files.

# terraform.state
This file now contains the IDs and properties of the resources Terraform created so that it can manage or destroy those resources going forward.

You must save your state file securely and distribute it only to trusted team members who need to manage your infrastructure. In production, we recommend storing your state remotely. Remote stage storage enables collaboration using Terraform but is beyond the scope of this tutorial.

Note: Save this file in a s3 is a good practice.

# terraform destroy
Destroy all your infraestructure.
