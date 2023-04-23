# terraform.tfvars

terraform apply  = terraform apply --var-file  terraform.tfvars

terraform apply = terraform apply --var-file region.tfvars


## Terraform Workspace
erraform workspace
Usage: terraform [global options] workspace

  new, list, show, select and delete Terraform workspaces.

Subcommands:
    delete    Delete a workspace
    list      List Workspaces
    new       Create a new workspace
    select    Select a workspace
    show      Show the name of the current workspace

```
terraform workspace new oregon
Created and switched to workspace "oregon"!

terraform workspace select ohio
Switched to workspace "ohio"
```

## Terraform Makefile
Should have in the directory where you are working.

