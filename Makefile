.PHONY: init plan apply destroy fmt validate output

ENV ?= prod
TFVARS = environments/$(ENV)/terraform.tfvars

# Initialise Terraform
init:
	terraform init -reconfigure

# Validate configuration
validate: init
	terraform validate

# Format all .tf files
fmt:
	terraform fmt -recursive

# Plan with environment vars
plan: validate
	terraform plan \
		-var-file=$(TFVARS) \
		-out=tfplan.$(ENV)

# Apply the saved plan
apply:
	terraform apply tfplan.$(ENV)

# Targeted apply (useful during development)
# make apply-target TARGET=module.vpc
apply-target:
	terraform apply \
		-var-file=$(TFVARS) \
		-target=$(TARGET)

# Destroy (requires ENV and confirmation)
destroy:
	@echo "⚠️  Destroying $(ENV) environment. Are you sure? [yes/no]"
	@read ans && [ $${ans:-no} = yes ] && \
		terraform destroy -var-file=$(TFVARS) || \
		echo "Aborted."

# Show outputs
output:
	terraform output

# Show state
state:
	terraform state list

# Unlock state if needed
unlock:
	terraform force-unlock $(LOCK_ID)

# Cost estimate (requires infracost)
cost:
	infracost breakdown --path . --terraform-var-file $(TFVARS)