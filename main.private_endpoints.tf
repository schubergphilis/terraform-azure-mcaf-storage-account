
resource "azurerm_private_endpoint" "managed" {
  for_each = { for k, v in local.private_endpoints : k => v if v.private_endpoints_manage_dns_zone_group }

  name                = coalesce(each.value.name, each.key)
  location            = var.location
  resource_group_name = coalesce(var.deploy_private_endpoints.resource_group_name, var.resource_group_name)
  subnet_id           = each.value.subnet_id

  private_service_connection {
    is_manual_connection           = false
    name                           = "${module.naming["intb"].naming["databases"].redis_cache}-redis-psc"
    subresource_names              = [each.value.subresource_name]
    private_connection_resource_id = azurerm_storage_account.this.id
  }
}


resource "azurerm_private_endpoint" "unmanaged" {
  for_each = { for k, v in local.private_endpoints : k => v if v.private_endpoints_manage_dns_zone_group == false }

  name                = coalesce(each.value.name, each.key)
  location            = var.location
  resource_group_name = coalesce(var.deploy_private_endpoints.resource_group_name, var.resource_group_name)
  subnet_id           = each.value.subnet_id

  private_service_connection {
    is_manual_connection           = false
    name                           = coalesce(each.value.private_service_connection_name, "${coalesce(each.value.name, each.key)}-psc")
    subresource_names              = [each.value.subresource_name]
    private_connection_resource_id = azurerm_storage_account.this.id
  }

  lifecycle {
    ignore_changes = [private_dns_zone_group]
  }
}