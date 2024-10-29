variable "name" {
  type        = string
  description = "The name of the Storage Account"
  nullable    = false
}

variable "resource_group_name" {
  description = "Name of the resource group to Create the Storage account in"
  type        = string
}

variable "location" {
  description = "Location of the Storage account"
  type        = string
}

variable "account_tier" {
  type        = string
  default     = "Standard"
  description = "The Tier to use for this storage account. Valid options are Standard and Premium. Defaults to Standard."
}

variable "account_replication_type" {
  type        = string
  default     = "LRS"
  description = "The type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS, and RA_GZRS. Defaults to GRS."
}

variable "account_kind" {
  type        = string
  default     = "StorageV2"
  description = "The Kind of account to create. Valid options are Storage, StorageV2, BlobStorage, FileStorage, BlockBlobStorage, and StorageV2. Defaults to StorageV2."
}

variable "access_tier" {
  type        = string
  default     = "Hot"
  description = "The access tier for the storage account. Valid options are Hot and Cool. Defaults to Hot."
}

variable "shared_access_key_enabled" {
  type        = bool
  default     = false
  description = "Allow or disallow shared access keys for this storage account. Defaults to false."
}

variable "public_network_access_enabled" {
  type        = bool
  default     = false
  description = "Allow or disallow public network access to this storage account. Defaults to false."
}

variable "https_traffic_only_enabled" {
  description = "Allow or disallow only HTTPS traffic to this storage account. Defaults to true."
  type        = bool
  default     = true
}

variable "default_to_oauth_authentication" {
  description = "Allow or disallow defaulting to OAuth authentication for this storage account. Defaults to true."
  type        = bool
  default     = true
}

variable "infrastructure_encryption_enabled" {
  description = "Allow or disallow infrastructure encryption for this storage account. Defaults to true."
  type        = bool
  default     = true
}


variable "min_tls_version" {
  description = "The minimum TLS version to allow for requests to this storage account. Valid options are TLS1_0, TLS1_1, and TLS1_2. Defaults to TLS1_2."
  type        = string
  default     = "TLS1_2"
}

variable "sftp_enabled" {
  type        = bool
  default     = false
  description = "Allow or disallow SFTP access to this storage account. Defaults to false."
}

variable "identity" {
  type        = bool
  default     = true
  description = "Enable or disable the system-assigned managed identity for this storage account. Defaults to true."
}

variable "allow_nested_items_to_be_public" {
  description = "Allow or disallow nested items to be public. Defaults to false."
  type        = bool
  default     = false
}

variable "network_bypass" {
  type        = list(string)
  default     = []
  description = "A list of services that are allowed to bypass the network rules. Defaults to [], could be any of [\"Logging\", \"Metrics\", \"AzureServices\", \"None\"]."
}

variable "subnet_ids" {
  type        = list(string)
  default     = []
  description = "A list of subnet IDs that are allowed to access this storage account. Defaults to an empty list."
}

variable "ip_rules" {
  type        = list(string)
  default     = []
  description = "A list of IP addresses that are allowed to access this storage account. Defaults to an empty list."
}

variable "blob_delete_retention_days" {
  type        = number
  default     = 90
  description = "The number of days to retain deleted blobs for. Defaults to 90."
}

variable "container_delete_retention_days" {
  type        = number
  default     = 90
  description = "The number of days to retain deleted containers for. Defaults to 90."
}

variable "versioning_enabled" {
  type        = bool
  default     = true
  description = "Is versioning enabled?"
}

variable "change_feed_enabled" {
  type        = bool
  default     = true
  description = "Is the blob service properties for change feed events enabled?"
}

variable "storage_containers" {
  type = map(object({
    access_type = optional(string, "private")
  }))
  description = "Map of Storage Containers to Create and whether the container should be publically accessible, defaults to private"
}

variable "contributors" {
  type        = list(string)
  default     = []
  description = "List of principal IDs that are allowed to be contributor on this storage account. Defaults to an empty list."
}

variable "cmk_key_vault_id" {
  type        = string
  default     = null
  description = "The ID of the Key Vault to use for the Customer Managed Key"
}

variable "cmk_key_name" {
  type        = string
  default     = null
  description = "The name of the Key (within the cmk_key_vault) to use as the Customer Managed Key"
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
