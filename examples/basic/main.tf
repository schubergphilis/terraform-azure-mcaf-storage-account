module "storage_account" {
  source = "../.."

  name                = "Storage Account"
  resource_group_name = "Resource Group Name"
  location            = "West Europe"
  storage_containers = {
    "container1" = {}
  }
}