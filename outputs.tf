output "id" {
  value       = azurerm_storage_account.this.id
  description = "Resource Id of the storage account"
}

output "name" {
  value       = azurerm_storage_account.this.name
  description = "Name of the storage account"
}

output "endpoints" {
  value = {
    primary_blob_endpoint  = azurerm_storage_account.this.primary_blob_endpoint
    primary_blob_host      = azurerm_storage_account.this.primary_blob_host
    primary_dfs_endpoint   = azurerm_storage_account.this.primary_dfs_endpoint
    primary_dfs_host       = azurerm_storage_account.this.primary_dfs_host
    primary_file_endpoint  = azurerm_storage_account.this.primary_file_endpoint
    primary_file_host      = azurerm_storage_account.this.primary_file_host
    primary_queue_endpoint = azurerm_storage_account.this.primary_queue_endpoint
    primary_queue_host     = azurerm_storage_account.this.primary_queue_host
    primary_table_endpoint = azurerm_storage_account.this.primary_table_endpoint
    primary_table_host     = azurerm_storage_account.this.primary_table_host
    primary_web_endpoint   = azurerm_storage_account.this.primary_web_endpoint
  }
  description = "Endpoint information of the storage account"
}

output "access_keys" {
  value       = {
    primary = azurerm_storage_account.this.primary_access_key
    secondary = azurerm_storage_account.this.secondary_access_key
  }
  sensitive = true
}
