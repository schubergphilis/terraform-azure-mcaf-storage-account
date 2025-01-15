data "azurerm_client_config" "current" {
}

resource "azurerm_storage_account" "this" {
  resource_group_name               = var.resource_group_name
  location                          = var.location
  name                              = var.name
  account_tier                      = var.account_tier
  account_replication_type          = var.account_replication_type
  account_kind                      = var.account_kind
  access_tier                       = var.access_tier
  shared_access_key_enabled         = var.shared_access_key_enabled
  public_network_access_enabled     = var.public_network_access_enabled
  https_traffic_only_enabled        = var.https_traffic_only_enabled
  min_tls_version                   = var.min_tls_version
  default_to_oauth_authentication   = var.default_to_oauth_authentication
  infrastructure_encryption_enabled = var.infrastructure_encryption_enabled
  sftp_enabled                      = var.sftp_enabled
  allow_nested_items_to_be_public   = var.allow_nested_items_to_be_public
  queue_encryption_key_type         = (var.use_cmk_encryption || (local.cmk == 1 && var.use_cmk_encryption == null)) ? "Account" : "Service"
  table_encryption_key_type         = (var.use_cmk_encryption || (local.cmk == 1 && var.use_cmk_encryption == null)) ? "Account" : "Service"

  blob_properties {
    delete_retention_policy {
      days = var.blob_delete_retention_days
    }
    container_delete_retention_policy {
      days = var.container_delete_retention_days
    }
    versioning_enabled  = var.versioning_enabled
    change_feed_enabled = var.change_feed_enabled
  }

  dynamic "identity" {
    for_each = var.managed_identity_enabled ? [true] : []

    content {
      type = "SystemAssigned"
    }
  }

  tags = merge(
    try(var.tags),
    tomap({
      "Resource Type" = "Storage Account"
    })
  )

  lifecycle {
    ignore_changes = [
      customer_managed_key
    ]
  }
}

resource "azurerm_storage_account_network_rules" "this" {
  storage_account_id = azurerm_storage_account.this.id

  default_action             = length(var.ip_rules) == 0 && length(var.subnet_ids) == 0 ? "Allow" : "Deny"
  ip_rules                   = var.ip_rules
  virtual_network_subnet_ids = var.subnet_ids
  bypass                     = var.network_bypass
}

resource "azurerm_storage_container" "this" {
  for_each = var.storage_containers

  name                  = each.key
  storage_account_id    = azurerm_storage_account.this.id
  container_access_type = each.value.access_type
}

resource "azurerm_role_assignment" "this" {
  scope                = azurerm_storage_account.this.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "extra" {
  for_each = { for idx, val in var.contributors : idx => val }

  scope                = azurerm_storage_account.this.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = each.value
}

resource "azurerm_storage_account_customer_managed_key" "this" {
  count = local.cmk

  storage_account_id = azurerm_storage_account.this.id
  key_vault_id       = var.cmk_key_vault_id
  key_name           = var.cmk_key_name

  depends_on = [
    azurerm_role_assignment.cmk
  ]
}

resource "azurerm_role_assignment" "cmk" {
  count = local.cmk

  scope                = var.cmk_key_vault_id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_storage_account.this.identity[0].principal_id

  depends_on = [azurerm_storage_account.this]
}
