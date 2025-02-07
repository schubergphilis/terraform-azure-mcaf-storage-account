variable "share_properties" {
  type = object({
    retention_policy = optional(object({
      days = optional(number)
    }), null)
    smb = optional(object({
      authentication_types            = optional(set(string), ["NTLMv2", "Kerberos"])
      channel_encryption_type         = optional(set(string), ["AES-128-CCM", "AES-128-GCM", "AES-256-GCM"])
      kerberos_ticket_encryption_type = optional(set(string), ["AES-256"])
      multichannel_enabled            = optional(bool, false)
      versions                        = optional(set(string), ["SMB3.1.1"])
    }), {})
  })
  description = <<DESCRIPTION

---
- `retention_policy` - (Optional) A set of properties for the retention policy.
  - `days` - (Optional) The number of days that the share should retain data. If not specified, the share will retain data indefinitely.

- `smb` - (Optional) A set of properties for the SMB protocol.
  - `authentication_types` - (Optional) A set of SMB authentication methods. Possible values are `NTLMv2`, and `Kerberos`.
  - `channel_encryption_type` - (Optional) A set of SMB channel encryption. Possible values are `AES-128-CCM`, `AES-128-GCM`, and `AES-256-GCM`.
  - `kerberos_ticket_encryption_type` - (Optional) A set of Kerberos ticket encryption. Possible values are `RC4-HMAC`, and `AES-256`.
  - `multichannel_enabled` - (Optional) Indicates whether multichannel is enabled. Defaults to `false`. This is only supported on Premium storage accounts.
  - `versions` - (Optional) A set of SMB protocol versions. Possible values are `SMB2.1`, `SMB3.0`, and `SMB3.1.1`.

---
```hcl
  share_properties = {
    smb = {
      authentication_types            = ["NTLMv2", "Kerberos"]
      channel_encryption_type         = ["AES-128-CCM", "AES-128-GCM", "AES-256-GCM"]
      kerberos_ticket_encryption_type = ["RC4-HMAC", "AES-256"]
      multichannel_enabled            = false
      versions                        = ["SMB2.1", "SMB3.0", "SMB3.1.1"]
    }
    retention_policy = {
      days = 30
    }
  }
```
DESCRIPTION
}

variable "storage_file_shares" {
  type = map(object({
    access_tier      = optional(string, "Hot")
    enabled_protocol = optional(string, "SMB")
    quota            = optional(number, 1)
  }))
  default     = {}
  description = <<DESCRIPTION

  Map of Storage File Shares to Create and their properties. Defaults to an empty map.
  - `access_tier` - (Optional) The access tier for the file share. Valid options are Hot, Cool, and TransactionOptimized. Defaults to Hot.
  - `enabled_protocol` - (Optional) The protocol to use for the file share. Valid options are SMB and NFS. Defaults to SMB.
  - `quota` - (Optional) The maximum size of the share, in gigabytes. For Standard storage accounts, this must be `1`GB (or higher) and at most `5120` GB (`5` TB). For Premium FileStorage storage accounts, this must be greater than 100 GB and at most `102400` GB (`100` TB).

```hcl
  storage_file_shares = {
    "share1" = {
      access_tier      = "Hot"
      enabled_protocol = "SMB"
      quota            = 1
    }
    "share2" = {
      access_tier      = "Cool"
      enabled_protocol = "NFS"
      quota            = 5120
    }
    "share3" = {
      access_tier      = "TransactionOptimized"
      enabled_protocol = "SMB"
      quota            = 500
    }
    "share4" = {
      access_tier      = "Premium"
      enabled_protocol = "SMB"
      quota            = 102400
    }
  }
```

DESCRIPTION

  validation {
    condition     = alltrue([for share in var.storage_file_shares : contains(["Hot", "Cool", "TransactionOptimized", "Premium"], share.access_tier)])
    error_message = "The access_tier must be either 'Hot', 'Cool, 'TransactionOptimized' or 'Premium'"
  }
  validation {
    condition     = alltrue([for share in var.storage_file_shares : contains(["SMB", "NFS"], share.enabled_protocol)])
    error_message = "The enabled_protocol must be either 'SMB' or 'NFS'"
  }
  validation {
    condition     = alltrue([for share in var.storage_file_shares : (share.enabled_protocol != "NFS") || (share.enabled_protocol == "NFS" && var.account_kind == "FileStorage")])
    error_message = "If the enabled_protocol is 'NFS', the account_kind must be 'FileStorage'."
  }
  validation {
    condition     = alltrue([for share in var.storage_file_shares : share.quota >= 1])
    error_message = "The quota must be greater than or equal to 1"
  }
  validation {
    condition     = alltrue([for share in var.storage_file_shares : (share.access_tier != "Premium" && share.quota <= 5120) || (share.access_tier == "Premium" && share.quota >= 100 && share.quota <= 102400)])
    error_message = "The quota must be less than or equal to 5120 for non-Premium tiers. For Premium tier, it must be between 100 and 102400."
  }
}