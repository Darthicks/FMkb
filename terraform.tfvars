# Constants
prefix              = "fmkb"
environment         = "dev"
location_code       = "weeu"

# Resource Names
rg_name             = "rg-migration-project"
location            = "East US" # Update to match your region

# Admin Credentials
admin_username      = "azureadmin"
admin_password      = "ComplexPassword123!" # Ideally stored in Azure Key Vault

# VM Configuration
vm_size             = "D4as_v5"
disk_size           = 128

# Generated Names
vnet_name           = "" # To be set in the main configuration
subnet_name         = "subnet-default"
vm_name             = "" # To be set in the main configuration
nsg_name            = "" # To be set in the main configuration
service_plan_name   = "" # To be set in the main configuration
function_app_name   = "" # To be set in the main configuration
storage_account_name = "" # To be set in the main configuration
blob_container_name = "migration-files"
