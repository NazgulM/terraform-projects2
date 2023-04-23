virginia:
	terraform workspace new virginia || terraform workspace select virginia
	terraform init
	terrafrom apply --var-file regions/virginia.tfvars --auto-approve

ohio:
	terraform workspace new ohio || terraform workspace select ohio
	terraform init
	terraform apply --var-file regions/ohio.tfvars --auto-approve

oregon:
	terraform workspace new oregon || terraform workspace select oregon
	terraform init
	terraform apply --var-file regions/oregon.tfvars --auto-approve

california:
	terraform workspace new california || terraform workspace select california
	terraform init
	terraform apply --var-file regions/california.tfvars --auto-approve
	terraform destroy --var-file regions/california.tfvars --auto-approve