1. Provide your auth-token by running `terraform login`

2. Provide your custom backend data by creating a *backend.hcl* file
```
hostname = "app.terraform.io"  
workspaces { name = "Example-Workspace" }
organization = "organization"
````

3. Initialize the deployment
````
terraform init -backend-config=backend.hcl
````

4. When applying or planning you can override the default variables defined in variables.tf:
````
terraform apply -var='instance_name="my-instance"'
````