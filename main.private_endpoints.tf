module "private_endpoints_managed" {
  source              = "github.com/schubergphilis/terraform-azure-mcaf-private-endpoints?ref=v0.2.0"
  location            = var.location
  resource_group_name = var.resource_group_name
  private_endpoints   = local.private_endpoints
}