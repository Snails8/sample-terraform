# usage:
# $ make ecr_repo
# $ make init-(dev or prod or etc.)
# $ make plan-(dev or prod or etc.)
# $ make apply-(dev or prod or etc.)
include .env

DC := docker-compose exec terraform

# aws cliは入っておく。
ecr_repo:
	aws ecr create-repository --repository-name $(TF_VAR_APP_NAME)-app
	aws ecr create-repository --repository-name $(TF_VAR_APP_NAME)-nginx

ssm-store:
	sh ssm-put.sh $(TF_VAR_APP_NAME) .env.production

init:
	@${DC} terraform init

plan:
	@${DC} terraform plan

# Make migrate if S3 bucket name is changed.
migrate:
	@${DC} terraform init -migrate-state

# Make resources by terraform
apply:
	@${DC} terraform apply

# Refresh tfstate if created resources are changed by manually.
refresh:
	@${DC} terraform refresh

# Make state list of resources.
list:
	@${DC} terraform state list

# Destroy terraform resources.
destroy:
	@${DC} terraform destroy