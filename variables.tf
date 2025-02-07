variable "name" {
  type        = string
  description = "Name of the Storage Account"
  nullable    = false
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group to Create the Storage account in"
  nullable    = false
}

variable "location" {
  type        = string
  description = "Location of the Storage account"
  nullable    = false
}

variable "account_tier" {
  type        = string
  default     = "Standard"
  description = "Tier to use for this storage account. Valid options are Standard and Premium. Defaults to Standard."
}

variable "account_replication_type" {
  type        = string
  default     = "ZRS"
  description = "Type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS, and RA_GZRS. Defaults to ZRS."
}

variable "account_kind" {
  type        = string
  default     = "StorageV2"
  description = "Type of account to create. Valid options are Storage, StorageV2, BlobStorage, FileStorage, BlockBlobStorage, and StorageV2. Defaults to StorageV2."
}

variable "access_tier" {
  type        = string
  default     = "Hot"
  description = "Access tier for the storage account. Valid options are Hot and Cool. Defaults to Hot."
}

variable "shared_access_key_enabled" {
  type        = bool
  default     = false
  description = "Allow or disallow shared access keys for this storage account. Defaults to false."
}

variable "default_to_oauth_authentication" {
  type        = bool
  default     = true
  description = "Allow or disallow defaulting to OAuth authentication for this storage account. Defaults to true."
}

variable "infrastructure_encryption_enabled" {
  type        = bool
  default     = true
  description = "Allow or disallow infrastructure encryption for this storage account. Defaults to true."
}

variable "cross_tenant_replication_enabled" {
  type        = bool
  default     = false
  description = "Allow or disallow cross Tenant replication for this storage account. Defaults to false."
}

variable "allowed_copy_scope" {
  type        = string
  default     = "PrivateLink"
  description = "Restrict copy scope for the storage account, valid values are 'Unrestricted', 'AAD' and 'PrivateLink'. Defaults to 'PrivateLink'. Unrestricted matches Azure Default of 'null'."

  validation {
    condition     = contains(["Unrestricted", "AAD", "PrivateLink"], var.allowed_copy_scope)
    error_message = "The channel must be either 'Unrestricted', 'AAD' or 'PrivateLink'"
  }
}

variable "min_tls_version" {
  description = "The minimum TLS version to allow for requests to this storage account. Valid options are 'TLS1_0', 'TLS1_1', and 'TLS1_2'. Defaults to 'TLS1_2'."
  type        = string
  default     = "TLS1_2"
}

variable "sftp_enabled" {
  type        = bool
  default     = false
  description = "Allow or disallow SFTP access to this storage account. Defaults to false."
}

variable "system_assigned_identity_enabled" {
  type        = bool
  default     = true
  description = "Enable or disable the system-assigned managed identity for this storage account. Defaults to true."
}

variable "user_assigned_identities" {
  type        = list(string)
  default     = []
  description = "list of user assigned identities to assign to the storage account. Defaults to an empty list."
}

variable "versioning_enabled" {
  type        = bool
  default     = true
  description = "Enable or Disable versioning is for the storage account. Defaults to true."
}

variable "change_feed_enabled" {
  type        = bool
  default     = true
  description = "Enable or Disable change feed events for the storage account. Defaults to true."
}

variable "storage_containers" {
  type = map(object({
    access_type = optional(string, "private")
  }))
  default     = {}
  description = "Map of Storage Containers to Create and whether the container should be publically accessible. Defaults to private."
}

variable "contributors" {
  type        = list(string)
  default     = []
  description = "list of principal IDs that are allowed to be contributor on this storage account. Defaults to an empty list."
}

variable "enable_cmk_encryption" {
  type        = bool
  default     = false
  description = "Optional variable to enable support for cmk encryption for tables and queues while not setting the cmk encryption. Defaults to false"
}

variable "cmk_key_vault_id" {
  type        = string
  default     = null
  description = "ID of the Key Vault to use for the Customer Managed Key"
}

variable "cmk_key_name" {
  type        = string
  default     = null
  description = "Name of the Key (within the cmk_key_vault_id) to use as the Customer Managed Key"
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "immutability_policy" {
  description = "immutability policy settings for the storage account. Defaults to null which does not set any immutability policy"
  type = object({
    state                         = optional(string, "Unlocked")
    allow_protected_append_writes = optional(bool, true)
    period_since_creation_in_days = optional(number, 14)
  })
  default = null
}

variable "storage_management_policy" {
  description = "the storage management policy of the base blob of the storage account, the builtin management policy only applies to the base blob and only supports last modification time to keep simplicity, for more advanced configurations do not set any move_to_* or delete_after_* and refer to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_management_policy"
  type = object({
    blob_delete_retention_days      = optional(number, 90)
    container_delete_retention_days = optional(number, 90)
    move_to_cool_after_days         = optional(number, null)
    move_to_cold_after_days         = optional(number, null)
    move_to_archive_after_days      = optional(number, null)
    delete_after_days               = optional(number, null)
  })
  default = {}
}

variable "network_configuration" {
  description = "the network configuration for the storage account. Defaults to no public access and https enforced"
  type = object({
    https_traffic_only_enabled      = optional(bool, true)
    allow_nested_items_to_be_public = optional(bool, false)
    public_network_access_enabled   = optional(bool, false)
    default_action                  = optional(string, "Deny")
    virtual_network_subnet_ids      = optional(set(string), [])
    ip_rules                        = optional(set(string), [])
    bypass                          = optional(set(string), ["AzureServices"])
  })
  default = {}
}