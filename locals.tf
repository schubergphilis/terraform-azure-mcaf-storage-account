locals {
  identity_system_assigned_user_assigned = (var.system_assigned_identity_enabled && (length(var.user_assigned_identities) > 0)) ? {
    this = {
      type                       = "SystemAssigned, UserAssigned"
      user_assigned_resource_ids = var.user_assigned_identities
    }
  } : null
  identity_system_assigned = var.system_assigned_identity_enabled ? {
    this = {
      type                       = "SystemAssigned"
      user_assigned_resource_ids = null
    }
  } : null
  identity_user_assigned = (length(var.user_assigned_identities) > 0) ? {
    this = {
      type                       = "UserAssigned"
      user_assigned_resource_ids = var.user_assigned_identities
    }
  } : null

  private_endpoints = merge(
    var.deploy_private_endpoints.blob != null ? {
      "blob-private-endpoint" = {
        private_dns_zone_ids                    = var.deploy_private_endpoints.blob.private_dns_zone_ids
        private_connection_resource_id          = azurerm_storage_account.this.id
        subnet_id                               = var.deploy_private_endpoints.blob.subnet_id
        subresource_name                        = "blob"
        private_endpoints_manage_dns_zone_group = var.deploy_private_endpoints.private_endpoints_manage_dns_zone_group
      }
    } : {},
    var.deploy_private_endpoints.queue != null ? {
      "queue-private-endpoint" = {
        private_dns_zone_ids                    = var.deploy_private_endpoints.queue.private_dns_zone_ids
        private_connection_resource_id          = azurerm_storage_account.this.id
        subnet_id                               = var.deploy_private_endpoints.queue.subnet_id
        subresource_name                        = "queue"
        private_endpoints_manage_dns_zone_group = var.deploy_private_endpoints.private_endpoints_manage_dns_zone_group
      }
    } : {},
    var.deploy_private_endpoints.file != null ? {
      "file-private-endpoint" = {
        private_dns_zone_ids                    = var.deploy_private_endpoints.file.private_dns_zone_ids
        private_connection_resource_id          = azurerm_storage_account.this.id
        subnet_id                               = var.deploy_private_endpoints.file.subnet_id
        subresource_name                        = "file"
        private_endpoints_manage_dns_zone_group = var.deploy_private_endpoints.private_endpoints_manage_dns_zone_group
      }
    } : {},
    var.deploy_private_endpoints.table != null ? {
      "table-private-endpoint" = {
        name                                    = var.deploy_private_endpoints.table.name
        private_dns_zone_ids                    = var.deploy_private_endpoints.table.private_dns_zone_ids
        private_connection_resource_id          = azurerm_storage_account.this.id
        subnet_id                               = var.deploy_private_endpoints.table.subnet_id
        subresource_name                        = "table"
        private_endpoints_manage_dns_zone_group = var.deploy_private_endpoints.private_endpoints_manage_dns_zone_group
      }
    } : {},
  )
}
