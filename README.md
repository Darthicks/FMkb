# Azure Infrastructure Deployment with Terraform

This repository contains Terraform scripts to deploy infrastructure on Azure. The infrastructure includes a Resource Group, Virtual Network, Subnet, Network Security Group, Virtual Machine, App Service Plan, Blob Storage Account, Blob Container, Azure Function App, and Azure Container Instances (Loaders, UI, Maintenance, Rest). The deployment can be configured for different environments such as Development (Dev), System Integration Testing (SIT), User Acceptance Testing (UAT), and Production (PRD).

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) installed and authenticated
- Azure Subscription

## Files in the Repository

- `main.tf`: Main Terraform configuration file
- `variables.tf`: Variable definitions
- `terraform.tfvars`: Variable values file
- `output.tf`: Output definitions

## Variables

The following variables are defined in `variables.tf`:

- `environment`: The environment to deploy (Dev, SIT, UAT, PRD)
- `prefix`: Constant prefix for all resources (e.g., "fmkb")
- `location`: Location of the resources
- `location_code`: Short code for the location (e.g., weeu for West Europe)
- `rg_name`: Name of the resource group
- `vnet_name`: Name of the virtual network
- `subnet_name`: Name of the subnet
- `vm_name`: Name of the virtual machine
- `admin_username`: Admin username for the virtual machine
- `admin_password`: Admin password for the virtual machine
- `nsg_name`: Name of the network security group
- `service_plan_name`: Name of the app service plan
- `function_app_name`: Name of the function app
- `storage_account_name`: Name of the storage account
- `blob_container_name`: Name of the blob container
- `vm_size`: Size of the virtual machine
- `disk_size`: Size of the virtual machine disk
- `loader_image`: Container image for the Loader instance
- `ui_image`: Container image for the UI instance
- `maintenance_image`: Container image for the Maintenance instance
- `rest_image`: Container image for the REST instance

## Usage

### 1. Install Prerequisites

Ensure you have Terraform and Azure CLI installed and authenticated.

### 2. Clone the Repository

```sh
git clone https://github.com/your-repo/azure-terraform-deployment.git
cd azure-terraform-deployment
```

### 3. Configure Variables
Update the terraform.tfvars file with the desired values. Ensure you set the environment variable to one of the following: Dev, SIT, UAT, PRD.

Example terraform.tfvars:

environment         = "Dev"
prefix              = "fmkb"
location            = "West Europe"
location_code       = "eust"
rg_name             = "rg-migration-project"
vnet_name           = "vnet-migration"
subnet_name         = "subnet-default"
vm_name             = "vm-linux-migration"
admin_username      = "azureadmin"
admin_password      = "ComplexPassword123!" # Ideally stored in Azure Key Vault
nsg_name            = "nsg-vm-linux"
service_plan_name   = "migration-service-plan"
function_app_name   = "migration-function-app"
storage_account_name = "mymigrationstorage"
blob_container_name = "migration-files"
vm_size             = "D4as_v5"
disk_size           = 128
loader_image        = "loader_image"
ui_image            = "ui_image"
maintenance_image   = "maintenance_image"
rest_image          = "rest_image"




### 4. Initialize Terraform
Initialize the Terraform configuration:

terraform init

### 5. Validate the Configuration
Validate the configuration to ensure there are no errors:

terraform validate

### 6. Plan the Deployment
Generate and review an execution plan. This will show you what Terraform will do when you apply the configuration:

terraform plan -out=tfplan

### 7. Apply the Configuration
Apply the configuration to deploy the resources in Azure:

terraform apply tfplan

Or specify the environment directly:

terraform apply -var="environment=Dev"
terraform apply -var="environment=SIT"
terraform apply -var="environment=UAT"
terraform apply -var="environment=PRD"

### 8. Verify the Deployment
After the deployment is complete, you can verify the deployed resources in the Azure Portal or by using the Azure CLI.

### 9. Outputs
The following outputs are defined in output.tf and will be displayed after a successful deployment:

vnet_name: Name of the virtual network
vm_name: Name of the virtual machine
nsg_name: Name of the network security group
storage_account_name: Name of the storage account
function_app_name: Name of the function app
loader_container_name: Name of the loader container instance
ui_container_name: Name of the UI container instance
maintenance_container_name: Name of the maintenance container instance
rest_container_name: Name of the REST container instance


### Cleanup
To destroy the deployed resources, run:
terraform destroy


### License
This project is licensed under the MIT License - see the LICENSE file for details.

Acknowledgements
Terraform (https://www.terraform.io/)
Azure (https://azure.microsoft.com/)


Make sure to update the repository link and any other specific details related to your project. This `README.md` provides a comprehensive guide on how to use the Terraform scripts to deploy infrastructure in Azure.
