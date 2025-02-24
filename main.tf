data "azurerm_client_config" "current" {}

resource "azurerm_storage_account" "this" {
  resource_group_name               = var.resource_group_name
  location                          = var.location
  name                              = var.name
  account_tier                      = var.account_tier
  account_replication_type          = var.account_replication_type
  account_kind                      = var.account_kind
  access_tier                       = var.access_tier
  shared_access_key_enabled         = var.shared_access_key_enabled
  public_network_access_enabled     = var.network_configuration.public_network_access_enabled
  https_traffic_only_enabled        = var.network_configuration.https_traffic_only_enabled
  min_tls_version                   = var.min_tls_version
  default_to_oauth_authentication   = var.default_to_oauth_authentication
  infrastructure_encryption_enabled = var.infrastructure_encryption_enabled
  cross_tenant_replication_enabled  = var.cross_tenant_replication_enabled
  allowed_copy_scope                = var.allowed_copy_scope == "Unrestricted" ? null : var.allowed_copy_scope
  sftp_enabled                      = var.sftp_enabled
  is_hns_enabled                    = var.is_hns_enabled
  allow_nested_items_to_be_public   = var.network_configuration.allow_nested_items_to_be_public
  queue_encryption_key_type         = (var.enable_cmk_encryption || var.cmk_key_vault_id != null) ? "Account" : "Service"
  table_encryption_key_type         = (var.enable_cmk_encryption || var.cmk_key_vault_id != null) ? "Account" : "Service"

  blob_properties {
    delete_retention_policy {
      days = var.storage_management_policy.blob_delete_retention_days
    }
    container_delete_retention_policy {
      days = var.storage_management_policy.container_delete_retention_days
    }
    versioning_enabled  = var.versioning_enabled
    change_feed_enabled = var.change_feed_enabled
  }

  dynamic "identity" {
    for_each = coalesce(local.identity_system_assigned_user_assigned, local.identity_system_assigned, local.identity_user_assigned, {})

    content {
      type         = identity.value.type
      identity_ids = identity.value.user_assigned_resource_ids
    }
  }

  dynamic "immutability_policy" {
    for_each = var.immutability_policy != null ? { this = var.immutability_policy } : {}

    content {
      allow_protected_append_writes = immutability_policy.value.allow_protected_append_writes
      state                         = immutability_policy.value.state
      period_since_creation_in_days = immutability_policy.value.period_since_creation_in_days
    }
  }

  dynamic "share_properties" {
    for_each = var.share_properties == null ? [] : [var.share_properties]

    content {
      dynamic "retention_policy" {
        for_each = share_properties.value.retention_policy == null ? [] : [share_properties.value.retention_policy]

        content {
          days = retention_policy.value.days
        }
      }

      dynamic "smb" {
        for_each = share_properties.value.smb == null ? [] : [share_properties.value.smb]

        content {
          authentication_types            = smb.value.authentication_types
          channel_encryption_type         = smb.value.channel_encryption_type
          kerberos_ticket_encryption_type = smb.value.kerberos_ticket_encryption_type
          multichannel_enabled            = smb.value.multichannel_enabled
          versions                        = smb.value.versions
        }
      }
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

  default_action             = var.network_configuration.default_action
  ip_rules                   = var.network_configuration.ip_rules
  virtual_network_subnet_ids = var.network_configuration.virtual_network_subnet_ids
  bypass                     = var.network_configuration.bypass
}

resource "azurerm_storage_management_policy" "this" {
  count              = length(compact([var.storage_management_policy.move_to_cool_after_days, var.storage_management_policy.move_to_cold_after_days, var.storage_management_policy.move_to_archive_after_days, var.storage_management_policy.delete_after_days])) > 0 ? 1 : 0
  storage_account_id = azurerm_storage_account.this.id

  rule {
    name    = "Storage Account Module builtin management policy"
    enabled = true
    filters {
      blob_types = ["blockBlob"]
    }
    actions {
      base_blob {
        tier_to_cool_after_days_since_modification_greater_than = var.storage_management_policy.move_to_cool_after_days
        tier_to_cold_after_days_since_creation_greater_than     = var.storage_management_policy.move_to_cold_after_days
        tier_to_archive_after_days_since_creation_greater_than  = var.storage_management_policy.move_to_archive_after_days
        delete_after_days_since_modification_greater_than       = var.storage_management_policy.delete_after_days
      }
    }
  }
}

resource "azurerm_storage_container" "this" {
  for_each = var.storage_containers

  name                  = each.key
  storage_account_id    = azurerm_storage_account.this.id
  container_access_type = each.value.access_type
}

resource "azurerm_storage_share" "this" {
  for_each = var.storage_file_shares

  name               = each.key
  storage_account_id = azurerm_storage_account.this.id
  access_tier        = each.value.access_tier
  enabled_protocol   = each.value.enabled_protocol
  quota              = each.value.quota
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
  count = var.cmk_key_vault_id != null ? 1 : 0

  storage_account_id        = azurerm_storage_account.this.id
  user_assigned_identity_id = local.identity_user_assigned != null ? var.user_assigned_identities[0] : null
  key_vault_id              = var.cmk_key_vault_id
  key_name                  = var.cmk_key_name

  depends_on = [
    azurerm_role_assignment.cmk
  ]
}

resource "azurerm_role_assignment" "cmk" {
  count = (var.cmk_key_vault_id != null && (local.identity_system_assigned != null || local.identity_system_assigned_user_assigned != null)) ? 1 : 0

  scope                = var.cmk_key_vault_id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_storage_account.this.identity[0].principal_id
}

resource "azurerm_data_protection_backup_instance_blob_storage" "this" {
  for_each           = var.blob_storage_backup != null ? var.blob_storage_backup : {}
  name               = var.blob_storage_backup.name
  location           = var.location
  vault_id           = each.value.backup_vault_id
  storage_account_id = azurerm_storage_account.this.id
  backup_policy_id   = each.value.backup_policy_id
}

resource "azurerm_storage_account_local_user" "self" {
  count              = var.sftp_enabled != false && var.sftp_enabled == true ? length(var.sftp_local_user_config) : 0
  name               = var.sftp_local_user_config[count.index].name
  storage_account_id = azurerm_storage_account.this.id
  ssh_key_enabled    = true
  home_directory     = var.sftp_local_user_config[count.index].home_directory

  dynamic "ssh_authorized_key" {
    for_each = var.sftp_local_user_config[count.index].ssh_authorized_keys
    content {
      description = ssh_authorized_key.value.description
      key         = ssh_authorized_key.value.key
    }
  }

  dynamic "permission_scope" {
    for_each = var.sftp_local_user_config[count.index].permission_scopes
    content {
      service       = permission_scope.value.service
      resource_name = permission_scope.value.resource_name
      permissions {
        read   = permission_scope.value.permissions.read
        create = permission_scope.value.permissions.create
        delete = permission_scope.value.permissions.delete
        list   = permission_scope.value.permissions.list
        write  = permission_scope.value.permissions.write
      }
    }
  }
}
