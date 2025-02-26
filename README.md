# terraform-azure-mcaf-storage-account
Terraform module that will deploy some infra that could be used for Azure Devops icm Terraform

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 4, < 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 4, < 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_data_protection_backup_instance_blob_storage.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_protection_backup_instance_blob_storage) | resource |
| [azurerm_role_assignment.cmk](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.extra](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_storage_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_account_customer_managed_key.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account_customer_managed_key) | resource |
| [azurerm_storage_account_local_user.self](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account_local_user) | resource |
| [azurerm_storage_account_network_rules.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account_network_rules) | resource |
| [azurerm_storage_container.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_storage_management_policy.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_management_policy) | resource |
| [azurerm_storage_share.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_share) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | Location of the Storage account | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the Storage Account | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group to Create the Storage account in | `string` | n/a | yes |
| <a name="input_access_tier"></a> [access\_tier](#input\_access\_tier) | Access tier for the storage account. Valid options are Hot and Cool. Defaults to Hot. | `string` | `"Hot"` | no |
| <a name="input_account_kind"></a> [account\_kind](#input\_account\_kind) | Type of account to create. Valid options are Storage, StorageV2, BlobStorage, FileStorage, BlockBlobStorage, and StorageV2. Defaults to StorageV2. | `string` | `"StorageV2"` | no |
| <a name="input_account_replication_type"></a> [account\_replication\_type](#input\_account\_replication\_type) | Type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS, and RA\_GZRS. Defaults to ZRS. | `string` | `"ZRS"` | no |
| <a name="input_account_tier"></a> [account\_tier](#input\_account\_tier) | Tier to use for this storage account. Valid options are Standard and Premium. Defaults to Standard. | `string` | `"Standard"` | no |
| <a name="input_allowed_copy_scope"></a> [allowed\_copy\_scope](#input\_allowed\_copy\_scope) | Restrict copy scope for the storage account, valid values are 'Unrestricted', 'AAD' and 'PrivateLink'. Defaults to 'PrivateLink'. Unrestricted matches Azure Default of 'null'. | `string` | `"PrivateLink"` | no |
| <a name="input_blob_storage_backup"></a> [blob\_storage\_backup](#input\_blob\_storage\_backup) | Blob storage backup policy settings for the storage account. Defaults to null which does not set any blob storage backup policy. | <pre>object({<br>    name             = optional(string, null)<br>    backup_vault_id  = optional(string, null)<br>    backup_policy_id = optional(string, null)<br>    container_names  = optional(list(string), null) # If the backup policy type is "Vaulted" you need to list each individual container you want to backup<br>  })</pre> | `null` | no |
| <a name="input_change_feed_enabled"></a> [change\_feed\_enabled](#input\_change\_feed\_enabled) | Enable or Disable change feed events for the storage account. Defaults to true. | `bool` | `true` | no |
| <a name="input_cmk_key_name"></a> [cmk\_key\_name](#input\_cmk\_key\_name) | Name of the Key (within the cmk\_key\_vault\_id) to use as the Customer Managed Key | `string` | `null` | no |
| <a name="input_cmk_key_vault_id"></a> [cmk\_key\_vault\_id](#input\_cmk\_key\_vault\_id) | ID of the Key Vault to use for the Customer Managed Key | `string` | `null` | no |
| <a name="input_contributors"></a> [contributors](#input\_contributors) | list of principal IDs that are allowed to be contributor on this storage account. Defaults to an empty list. | `list(string)` | `[]` | no |
| <a name="input_cross_tenant_replication_enabled"></a> [cross\_tenant\_replication\_enabled](#input\_cross\_tenant\_replication\_enabled) | Allow or disallow cross Tenant replication for this storage account. Defaults to false. | `bool` | `false` | no |
| <a name="input_default_to_oauth_authentication"></a> [default\_to\_oauth\_authentication](#input\_default\_to\_oauth\_authentication) | Allow or disallow defaulting to OAuth authentication for this storage account. Defaults to true. | `bool` | `true` | no |
| <a name="input_enable_cmk_encryption"></a> [enable\_cmk\_encryption](#input\_enable\_cmk\_encryption) | Optional variable to enable support for cmk encryption for tables and queues while not setting the cmk encryption. Defaults to false | `bool` | `false` | no |
| <a name="input_immutability_policy"></a> [immutability\_policy](#input\_immutability\_policy) | immutability policy settings for the storage account. Defaults to null which does not set any immutability policy | <pre>object({<br>    state                         = optional(string, "Unlocked")<br>    allow_protected_append_writes = optional(bool, true)<br>    period_since_creation_in_days = optional(number, 14)<br>  })</pre> | `null` | no |
| <a name="input_infrastructure_encryption_enabled"></a> [infrastructure\_encryption\_enabled](#input\_infrastructure\_encryption\_enabled) | Allow or disallow infrastructure encryption for this storage account. Defaults to true. | `bool` | `true` | no |
| <a name="input_is_hns_enabled"></a> [is\_hns\_enabled](#input\_is\_hns\_enabled) | (Optional) Enables Hierarchical Namespace for this storage account. | `bool` | `false` | no |
| <a name="input_min_tls_version"></a> [min\_tls\_version](#input\_min\_tls\_version) | The minimum TLS version to allow for requests to this storage account. Valid options are 'TLS1\_0', 'TLS1\_1', and 'TLS1\_2'. Defaults to 'TLS1\_2'. | `string` | `"TLS1_2"` | no |
| <a name="input_network_configuration"></a> [network\_configuration](#input\_network\_configuration) | the network configuration for the storage account. Defaults to no public access and https enforced | <pre>object({<br>    https_traffic_only_enabled      = optional(bool, true)<br>    allow_nested_items_to_be_public = optional(bool, false)<br>    public_network_access_enabled   = optional(bool, false)<br>    default_action                  = optional(string, "Deny")<br>    virtual_network_subnet_ids      = optional(set(string), [])<br>    ip_rules                        = optional(set(string), [])<br>    bypass                          = optional(set(string), ["AzureServices"])<br>  })</pre> | `{}` | no |
| <a name="input_sftp_enabled"></a> [sftp\_enabled](#input\_sftp\_enabled) | Allow or disallow SFTP access to this storage account. Defaults to false. | `bool` | `false` | no |
| <a name="input_sftp_local_user_config"></a> [sftp\_local\_user\_config](#input\_sftp\_local\_user\_config) | (Optional) Configuration for the local user identity in the Azure Storage Account for SFTP.<br><br>  For example:<br>  name            = "sasftpuser01"<br>  ssh\_key\_enabled = true<br>  home\_directory  = "/home/sasftpuser01"<br>  ssh\_authorized\_keys = [<br>    {<br>      description = "Public key of local user identity 01"<br>      key         = "ssh-rsa"<br>    },<br>    {<br>      description = "Public key of local user identity 02"<br>      key         = "ssh-rsa"<br>    }<br>  ]<br>  permission\_scopes = [<br>    {<br>      service       = "blob"<br>      resource\_name = "container01"<br>      permissions = {<br>        read   = true<br>        create = true<br>        delete = true<br>        list   = true<br>        write  = true<br>      }<br>    },<br>    {<br>      service       = "blob"<br>      resource\_name = "container02"<br>      permissions = {<br>        read   = true<br>        create = true<br>        delete = true<br>        list   = true<br>        write  = true<br>      }<br>    }<br>  ]<br>} | <pre>list(object({<br>    name           = string<br>    home_directory = optional(string, "")<br>    ssh_authorized_keys = list(object({<br>      description = string<br>      key         = string<br>    }))<br>    permission_scopes = optional(list(object({<br>      service       = string<br>      resource_name = string<br>      permissions = object({<br>        read   = bool<br>        create = bool<br>        delete = bool<br>        list   = bool<br>        write  = bool<br>      })<br>    })))<br>  }))</pre> | `null` | no |
| <a name="input_share_properties"></a> [share\_properties](#input\_share\_properties) | ---<br>- `retention_policy` - (Optional) A set of properties for the retention policy.<br>  - `days` - (Optional) The number of days that the share should retain data. If not specified, the share will retain data indefinitely.<br><br>- `smb` - (Optional) A set of properties for the SMB protocol.<br>  - `authentication_types` - (Optional) A set of SMB authentication methods. Possible values are `NTLMv2`, and `Kerberos`.<br>  - `channel_encryption_type` - (Optional) A set of SMB channel encryption. Possible values are `AES-128-CCM`, `AES-128-GCM`, and `AES-256-GCM`.<br>  - `kerberos_ticket_encryption_type` - (Optional) A set of Kerberos ticket encryption. Possible values are `RC4-HMAC`, and `AES-256`.<br>  - `multichannel_enabled` - (Optional) Indicates whether multichannel is enabled. Defaults to `false`. This is only supported on Premium storage accounts.<br>  - `versions` - (Optional) A set of SMB protocol versions. Possible values are `SMB2.1`, `SMB3.0`, and `SMB3.1.1`.<br><br>---<pre>hcl<br>  share_properties = {<br>    smb = {<br>      authentication_types            = ["NTLMv2", "Kerberos"]<br>      channel_encryption_type         = ["AES-128-CCM", "AES-128-GCM", "AES-256-GCM"]<br>      kerberos_ticket_encryption_type = ["RC4-HMAC", "AES-256"]<br>      multichannel_enabled            = false<br>      versions                        = ["SMB2.1", "SMB3.0", "SMB3.1.1"]<br>    }<br>    retention_policy = {<br>      days = 30<br>    }<br>  }</pre> | <pre>object({<br>    retention_policy = optional(object({<br>      days = optional(number)<br>    }), null)<br>    smb = optional(object({<br>      authentication_types            = optional(set(string), ["NTLMv2", "Kerberos"])<br>      channel_encryption_type         = optional(set(string), ["AES-128-CCM", "AES-128-GCM", "AES-256-GCM"])<br>      kerberos_ticket_encryption_type = optional(set(string), ["AES-256"])<br>      multichannel_enabled            = optional(bool, false)<br>      versions                        = optional(set(string), ["SMB3.1.1"])<br>    }), {})<br>  })</pre> | `{}` | no |
| <a name="input_shared_access_key_enabled"></a> [shared\_access\_key\_enabled](#input\_shared\_access\_key\_enabled) | Allow or disallow shared access keys for this storage account. Defaults to false. | `bool` | `false` | no |
| <a name="input_storage_containers"></a> [storage\_containers](#input\_storage\_containers) | Map of Storage Containers to Create and whether the container should be publically accessible. Defaults to private. | <pre>map(object({<br>    access_type = optional(string, "private")<br>  }))</pre> | `{}` | no |
| <a name="input_storage_file_shares"></a> [storage\_file\_shares](#input\_storage\_file\_shares) | Map of Storage File Shares to Create and their properties. Defaults to an empty map.<br>  - `access_tier` - (Optional) The access tier for the file share. Valid options are Hot, Cool, and TransactionOptimized. Defaults to Hot.<br>  - `enabled_protocol` - (Optional) The protocol to use for the file share. Valid options are SMB and NFS. Defaults to SMB.<br>  - `quota` - (Optional) The maximum size of the share, in gigabytes. For Standard storage accounts, this must be `1`GB (or higher) and at most `5120` GB (`5` TB). For Premium FileStorage storage accounts, this must be greater than 100 GB and at most `102400` GB (`100` TB).<pre>hcl<br>  storage_file_shares = {<br>    "share1" = {<br>      access_tier      = "Hot"<br>      enabled_protocol = "SMB"<br>      quota            = 1<br>    }<br>    "share2" = {<br>      access_tier      = "Cool"<br>      enabled_protocol = "NFS"<br>      quota            = 5120<br>    }<br>    "share3" = {<br>      access_tier      = "TransactionOptimized"<br>      enabled_protocol = "SMB"<br>      quota            = 500<br>    }<br>    "share4" = {<br>      access_tier      = "Premium"<br>      enabled_protocol = "SMB"<br>      quota            = 102400<br>    }<br>  }</pre> | <pre>map(object({<br>    access_tier      = optional(string, "Hot")<br>    enabled_protocol = optional(string, "SMB")<br>    quota            = optional(number, 1)<br>  }))</pre> | `{}` | no |
| <a name="input_storage_management_policy"></a> [storage\_management\_policy](#input\_storage\_management\_policy) | the storage management policy of the base blob of the storage account, the builtin management policy only applies to the base blob and only supports last modification time to keep simplicity, for more advanced configurations do not set any move\_to\_* or delete\_after\_* and refer to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_management_policy | <pre>object({<br>    blob_delete_retention_days      = optional(number, 90)<br>    container_delete_retention_days = optional(number, 90)<br>    move_to_cool_after_days         = optional(number, null)<br>    move_to_cold_after_days         = optional(number, null)<br>    move_to_archive_after_days      = optional(number, null)<br>    delete_after_days               = optional(number, null)<br>  })</pre> | `{}` | no |
| <a name="input_system_assigned_identity_enabled"></a> [system\_assigned\_identity\_enabled](#input\_system\_assigned\_identity\_enabled) | Enable or disable the system-assigned managed identity for this storage account. Defaults to true. | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_user_assigned_identities"></a> [user\_assigned\_identities](#input\_user\_assigned\_identities) | list of user assigned identities to assign to the storage account. Defaults to an empty list. | `list(string)` | `[]` | no |
| <a name="input_versioning_enabled"></a> [versioning\_enabled](#input\_versioning\_enabled) | Enable or Disable versioning is for the storage account. Defaults to true. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_keys"></a> [access\_keys](#output\_access\_keys) | n/a |
| <a name="output_endpoints"></a> [endpoints](#output\_endpoints) | Endpoint information of the storage account |
| <a name="output_id"></a> [id](#output\_id) | Resource Id of the storage account |
| <a name="output_name"></a> [name](#output\_name) | Name of the storage account |
<!-- END_TF_DOCS -->

## License

**Copyright:** Schuberg Philis

```text
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
