*This is a remote project, it requires a terraform cloud account. Remove the remote configuration from the main.tf file if you want to run it locally*

1. Provide your terraform cloud auth-token by running `terraform login` (not needed if you provide a token in the next step)

2. Provide your custom backend data by creating a *backend.hcl* file
```
hostname = "app.terraform.io"  
workspaces { name = "Example-Workspace" }
organization = "organization"
token = "token"
````
*token is optional*

3. Since this is a remote execution, *edit your terraform cloud workspace* to provide the AWS environment variables:
````
AWS_ACCESS_KEY_ID="anaccesskey"
AWS_SECRET_ACCESS_KEY="asecretkey"
````
More about AWS authentication: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication
In local executions, you can export those environment variables or rely on the ~/aws/credentials file

4. Initialize the deployment
````
terraform init -backend-config=backend.hcl
````

5. When applying or planning you can override the default variables defined in variables.tf:
````
terraform apply -var='instance_name="my-instance"'
````
More about variables: https://learn.hashicorp.com/tutorials/terraform/variables?in=terraform/configuration-language
On remote executions, you can add terraform variables to your terraform cloud workspace.

6. If you make changes to the configuration:
````
terraform init -backend-config=backend.hcl -reconfigure
````